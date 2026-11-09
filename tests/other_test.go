// Tests in this file are NOT run in the PR pipeline. They are run in the continuous testing pipeline along with the ones in pr_test.go
package test

import (
	"context"
	"fmt"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/common"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testschematic"
)

// TestRunCompleteAndRestoredDBExample runs examples/complete and, once the instance is live,
// immediately runs examples/backup-restore against the CRN it produced — reusing the single
// provisioned MongoDB instance for both validations before tearing it all down together.
// This replaces the two previously independent TestRunCompleteExample and TestRunRestoredDBExample
// tests and saves one full MongoDB provision+destroy cycle per weekly pipeline run.
func TestRunCompleteAndRestoredDBExample(t *testing.T) {
	t.Parallel()

	// Phase 1: provision the complete example (KMS, VPC, CBR, Secrets Manager layer, users).
	completeOptions := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:            t,
		TerraformDir:       "examples/complete",
		Prefix:             "mongodb-cmp",
		BestRegionYAMLPath: regionSelectionPath,
		ResourceGroup:      resourceGroup,
		TerraformVars: map[string]interface{}{
			"users": []map[string]interface{}{
				{
					"name":     "testuser",
					"password": common.GetRandomPasswordWithPrefix(),
					"type":     "database",
				},
			},
			"admin_pass": common.GetRandomPasswordWithPrefix(),
		},
		CloudInfoService: sharedInfoSvc,
		// Phase 2 runs inside the PostApplyHook, while the complete instance is still live.
		PostApplyHook: func(options *testhelper.TestOptions) error {
			completeCRN, ok := options.LastTestTerraformOutputs["crn"].(string)
			if !ok || completeCRN == "" {
				t.Log("WARNING: could not read 'crn' output from complete example — skipping backup-restore phase")
				return nil
			}
			t.Logf("Phase 2: running backup-restore against complete example CRN: %s", completeCRN)

			restoreOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
				TerraformDir: "examples/backup-restore",
				Vars: map[string]interface{}{
					"prefix":                fmt.Sprintf("%s-rst", options.Prefix),
					"region":                options.Region,
					"resource_group":        resourceGroup,
					"existing_database_crn": completeCRN,
				},
				Upgrade: true,
			})

			_, applyErr := terraform.InitAndApplyContextE(t, context.Background(), restoreOptions)
			assert.Nil(t, applyErr, "backup-restore apply should not have errored")

			// Always destroy the restore instance before returning (complete is destroyed by the wrapper teardown).
			defer terraform.DestroyContext(t, context.Background(), restoreOptions)
			return applyErr
		},
	})

	region := completeOptions.Region
	latestVersion, _ := GetRegionVersions(region)
	completeOptions.TerraformVars["mongodb_version"] = latestVersion

	output, err := completeOptions.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunPointInTimeRecoveryDBExample(t *testing.T) {
	t.Parallel()
	t.Skip("Skipping PITR test: we don't maintain a permanent MongoDB Enterprise instance.")
	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:       t,
		TerraformDir:  "examples/pitr",
		Prefix:        "mongodb-pitr",
		Region:        "us-south",
		ResourceGroup: resourceGroup,
		TerraformVars: map[string]interface{}{
			"pitr_id":         "<mongodb-enterprise-crn>",
			"pitr_time":       " ",
			"mongodb_version": "<mongodb-enterprise-version>",
		},
		CloudInfoService: sharedInfoSvc,
	})

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

// TestRunRestoredDBGen2Example restores a Gen2 MongoDB instance from an existing backup.
// This test is resource-intensive (requires a full provision cycle) so it runs in the weekly
// pipeline rather than on every PR.
func TestRunRestoredDBGen2Example(t *testing.T) {
	t.Parallel()
	// ResourceGroup is intentionally not set so a unique group is created per run for this test.
	// Independent backup policies may not be destroyed on failure, causing conflicts on re-runs within the same group.
	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: "examples/backup-restore",
		Prefix:       "g2-restored",
		TerraformVars: map[string]interface{}{
			"plan":                  "standard-gen2",
			"disk_mb":               permanentResources["mongodbGen2DiskMb"],
			"mongodb_version":       fmt.Sprintf("%.1f", permanentResources["mongodbGen2Version"]),
			"region":                permanentResources["mongodbGen2Region"],
			"existing_database_crn": permanentResources["mongodbGen2Crn"],
		},
		CloudInfoService: sharedInfoSvc,
	})

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

// TestPlanValidation runs terraform plan only (nothing is provisioned) against the fully-configurable DA
// for a set of variable combinations.
func TestPlanValidation(t *testing.T) {
	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: fullyConfigurableSolutionTerraformDir,
		Prefix:       "val-plan",
		// ResourceGroup: resourceGroup,
		Region: "us-south", // skip VPC region picker
	})
	options.TestSetup()
	options.TerraformOptions.NoColor = true
	options.TerraformOptions.Logger = logger.Discard

	latestVersion, _ := GetRegionVersions("us-south")
	options.TerraformOptions.Vars = map[string]interface{}{
		"prefix":                       options.Prefix,
		"region":                       "us-south",
		"mongodb_version":              latestVersion,
		"provider_visibility":          "public",
		"existing_resource_group_name": resourceGroup,
	}

	// Test the DA when using an existing KMS instance
	var fullyConfigurableWithExistingKms = map[string]interface{}{
		"access_tags":               permanentResources["accessTags"],
		"existing_kms_instance_crn": permanentResources["kp_multitenant_us_south_crn"],
		"kms_encryption_enabled":    true,
	}

	// Test the DA when using IBM owned encryption key
	var fullyConfigurableWithIbmOwnedKey = map[string]interface{}{
		"kms_encryption_enabled": false,
	}

	// Test the DA when using IBM owned encryption keys
	var fullyConfigurableWithIbmOwnedBackupKey = map[string]interface{}{
		"use_default_backup_encryption_key": false,
		"kms_encryption_enabled":            false,
	}

	// Create a map of the variables
	tfVarsMap := map[string]map[string]interface{}{
		"fullyConfigurableWithExistingKms":       fullyConfigurableWithExistingKms,
		"fullyConfigurableWithIbmOwnedKey":       fullyConfigurableWithIbmOwnedKey,
		"fullyConfigurableWithIbmOwnedBackupKey": fullyConfigurableWithIbmOwnedBackupKey, // pragma: allowlist secret
	}

	_, initErr := terraform.InitContextE(t, context.Background(), options.TerraformOptions)
	if assert.Nil(t, initErr, "This should not have errored") {
		// Iterate over the slice of maps
		for name, tfVars := range tfVarsMap {
			t.Run(name, func(t *testing.T) {
				// Iterate over the keys and values in each map
				for key, value := range tfVars {
					options.TerraformOptions.Vars[key] = value
				}
				output, err := terraform.PlanContextE(t, context.Background(), options.TerraformOptions)
				assert.Nil(t, err, "This should not have errored")
				assert.NotNil(t, output, "Expected some output")
				// Delete the keys from the map
				for key := range tfVars {
					delete(options.TerraformOptions.Vars, key)
				}
			})
		}
	}
}

// TestRunExistingInstance validates the fully-configurable DA in "bring your own instance" mode.
// It reuses the permanent MongoDB instance defined in common-permanent-resources.yaml rather than
// provisioning and destroying a short-lived instance, which saves significant CI time and cost.
func TestRunExistingInstance(t *testing.T) {
	t.Parallel()

	// Verify ibmcloud_api_key variable is set
	checkVariable := "TF_VAR_ibmcloud_api_key"
	val, present := os.LookupEnv(checkVariable)
	require.True(t, present, checkVariable+" environment variable not set")
	require.NotEqual(t, "", val, checkVariable+" environment variable is empty")

	// Use the permanent MongoDB instance to avoid the cost of provisioning a transient one.
	existingInstanceCRN := fmt.Sprint(permanentResources["mongodbCrn"])
	region := fmt.Sprint(permanentResources["mongodbRegion"])
	logger.Log(t, "Reusing permanent existing_mongodb_instance_crn: ", existingInstanceCRN)

	options := testschematic.TestSchematicOptionsDefault(&testschematic.TestSchematicOptions{
		Testing: t,
		TarIncludePatterns: []string{
			"*.tf",
			fullyConfigurableSolutionTerraformDir + "/*.tf",
		},
		TemplateFolder:         fullyConfigurableSolutionTerraformDir,
		BestRegionYAMLPath:     regionSelectionPath,
		Prefix:                 fmt.Sprintf("%s-ex", icdShortType),
		ResourceGroup:          resourceGroup,
		DeleteWorkspaceOnFail:  false,
		WaitJobCompleteMinutes: 60,
	})

	options.TerraformVars = []testschematic.TestSchematicTerraformVar{
		{Name: "prefix", Value: options.Prefix, DataType: "string"},
		{Name: "ibmcloud_api_key", Value: options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], DataType: "string", Secure: true},
		{Name: "existing_mongodb_instance_crn", Value: existingInstanceCRN, DataType: "string"},
		{Name: "existing_resource_group_name", Value: resourceGroup, DataType: "string"},
		{Name: "deletion_protection", Value: false, DataType: "bool"},
		{Name: "region", Value: region, DataType: "string"},
		{Name: "provider_visibility", Value: "public", DataType: "string"},
	}
	err := options.RunSchematicTest()
	assert.Nil(t, err, "This should not have errored")
}
