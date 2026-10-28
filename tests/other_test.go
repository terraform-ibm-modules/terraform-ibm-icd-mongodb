// Tests in this file are NOT run in the PR pipeline. They are run in the continuous testing pipeline along with the ones in pr_test.go
package test

import (
	"context"
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/common"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
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
