// Tests in this file are run in the PR pipeline
package test

import (
	"fmt"
	"log"
	"math/rand"
	"os"
	"strings"
	"testing"

	"github.com/google/uuid"
	"github.com/gruntwork-io/terratest/modules/files"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/cloudinfo"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/common"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testschematic"
)

const fscloudExampleTerraformDir = "examples/fscloud"
const fullyConfigurableSolutionTerraformDir = "solutions/fully-configurable"
const securityEnforcedSolutionTerraformDir = "solutions/security-enforced"
const latestVersion = "7.0"

// Use existing resource group
const resourceGroup = "geretain-test-mongo"

// Restricting due to limited availability of BYOK in certain regions
const regionSelectionPath = "../common-dev-assets/common-go-assets/icd-region-prefs.yaml"

// Define a struct with fields that match the structure of the YAML data
const yamlLocation = "../common-dev-assets/common-go-assets/common-permanent-resources.yaml"

var permanentResources map[string]interface{}

var sharedInfoSvc *cloudinfo.CloudInfoService
var validICDRegions = []string{
	"eu-de",
	"us-south",
}

// TestMain will be run before any parallel tests, used to read data from yaml for use with tests
func TestMain(m *testing.M) {
	sharedInfoSvc, _ = cloudinfo.NewCloudInfoServiceFromEnv("TF_VAR_ibmcloud_api_key", cloudinfo.CloudInfoServiceOptions{})

	var err error
	permanentResources, err = common.LoadMapFromYaml(yamlLocation)
	if err != nil {
		log.Fatal(err)
	}

	os.Exit(m.Run())
}

func TestRunFullyConfigurableSolutionSchematics(t *testing.T) {
	t.Parallel()

	options := testschematic.TestSchematicOptionsDefault(&testschematic.TestSchematicOptions{
		Testing: t,
		TarIncludePatterns: []string{
			"*.tf",
			fmt.Sprintf("%s/*.tf", fullyConfigurableSolutionTerraformDir),
			fmt.Sprintf("%s/*.tf", fscloudExampleTerraformDir),
			fmt.Sprintf("%s/*.tf", "modules/fscloud"),
			fmt.Sprintf("%s/*.sh", "scripts"),
		},
		TemplateFolder:         fullyConfigurableSolutionTerraformDir,
		BestRegionYAMLPath:     regionSelectionPath,
		Prefix:                 "mdb-fc-da",
		ResourceGroup:          resourceGroup,
		DeleteWorkspaceOnFail:  false,
		WaitJobCompleteMinutes: 60,
	})

	serviceCredentialSecrets := []map[string]interface{}{
		{
			"secret_group_name": fmt.Sprintf("%s-secret-group", options.Prefix),
			"service_credentials": []map[string]string{
				{
					"secret_name": fmt.Sprintf("%s-cred-reader", options.Prefix),
					"service_credentials_source_service_role_crn": "crn:v1:bluemix:public:iam::::role:Viewer",
				},
				{
					"secret_name": fmt.Sprintf("%s-cred-writer", options.Prefix),
					"service_credentials_source_service_role_crn": "crn:v1:bluemix:public:iam::::role:Editor",
				},
			},
		},
	}

	options.TerraformVars = []testschematic.TestSchematicTerraformVar{
		{Name: "ibmcloud_api_key", Value: options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], DataType: "string", Secure: true},
		{Name: "access_tags", Value: permanentResources["accessTags"], DataType: "list(string)"},
		{Name: "kms_encryption_enabled", Value: true, DataType: "bool"},
		{Name: "deletion_protection", Value: false, DataType: "bool"},
		{Name: "existing_kms_instance_crn", Value: permanentResources["hpcs_south_crn"], DataType: "string"},
		{Name: "kms_endpoint_type", Value: "private", DataType: "string"},
		{Name: "mongodb_version", Value: latestVersion, DataType: "string"}, // Always lock this test into the latest supported MongoDB version
		{Name: "existing_resource_group_name", Value: resourceGroup, DataType: "string"},
		{Name: "plan", Value: "standard", DataType: "string"},
		{Name: "service_credential_names", Value: "{\"admin_test\": \"Administrator\", \"editor_test\": \"Editor\"}", DataType: "map(string)"},
		{Name: "existing_secrets_manager_instance_crn", Value: permanentResources["secretsManagerCRN"], DataType: "string"},
		{Name: "service_credential_secrets", Value: serviceCredentialSecrets, DataType: "list(object)"},
		{Name: "admin_pass_secrets_manager_secret_group", Value: options.Prefix, DataType: "string"},
		{Name: "admin_pass_secrets_manager_secret_name", Value: options.Prefix, DataType: "string"},
		{Name: "provider_visibility", Value: "private", DataType: "string"},
		{Name: "prefix", Value: options.Prefix, DataType: "string"},
	}
	err := options.RunSchematicTest()
	assert.Nil(t, err, "This should not have errored")
}

func TestRunSecurityEnforcedUpgradeSolutionSchematics(t *testing.T) {
	t.Parallel()

	options := testschematic.TestSchematicOptionsDefault(&testschematic.TestSchematicOptions{
		Testing:       t,
		Region:        "us-south",
		Prefix:        "mo-se-upg",
		ResourceGroup: resourceGroup,
		TarIncludePatterns: []string{
			"*.tf",
			fullyConfigurableSolutionTerraformDir + "/*.tf",
			securityEnforcedSolutionTerraformDir + "/*.tf",
		},
		TemplateFolder:             securityEnforcedSolutionTerraformDir,
		Tags:                       []string{"mo-se-upg"},
		DeleteWorkspaceOnFail:      false,
		WaitJobCompleteMinutes:     120,
		CheckApplyResultForUpgrade: true,
	})

	options.TerraformVars = []testschematic.TestSchematicTerraformVar{
		{Name: "ibmcloud_api_key", Value: options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], DataType: "string", Secure: true},
		{Name: "prefix", Value: options.Prefix, DataType: "string"},
		{Name: "deletion_protection", Value: false, DataType: "bool"},
		{Name: "existing_resource_group_name", Value: resourceGroup, DataType: "string"},
		{Name: "existing_kms_instance_crn", Value: permanentResources["hpcs_south_crn"], DataType: "string"},
	}

	err := options.RunSchematicUpgradeTest()
	assert.Nil(t, err, "This should not have errored")
}

func TestRunSecurityEnforcedSolutionSchematics(t *testing.T) {
	t.Parallel()

	options := testschematic.TestSchematicOptionsDefault(&testschematic.TestSchematicOptions{
		Testing: t,
		TarIncludePatterns: []string{
			"*.tf",
			fmt.Sprintf("%s/*.tf", fullyConfigurableSolutionTerraformDir),
			fmt.Sprintf("%s/*.tf", securityEnforcedSolutionTerraformDir),
			fmt.Sprintf("%s/*.tf", fscloudExampleTerraformDir),
			fmt.Sprintf("%s/*.tf", "modules/fscloud"),
			fmt.Sprintf("%s/*.sh", "scripts"),
		},
		TemplateFolder:         securityEnforcedSolutionTerraformDir,
		BestRegionYAMLPath:     regionSelectionPath,
		Prefix:                 "mdb-se-da",
		ResourceGroup:          resourceGroup,
		DeleteWorkspaceOnFail:  false,
		WaitJobCompleteMinutes: 60,
	})

	serviceCredentialSecrets := []map[string]interface{}{
		{
			"secret_group_name": fmt.Sprintf("%s-secret-group", options.Prefix),
			"service_credentials": []map[string]string{
				{
					"secret_name": fmt.Sprintf("%s-cred-reader", options.Prefix),
					"service_credentials_source_service_role_crn": "crn:v1:bluemix:public:iam::::role:Viewer",
				},
				{
					"secret_name": fmt.Sprintf("%s-cred-writer", options.Prefix),
					"service_credentials_source_service_role_crn": "crn:v1:bluemix:public:iam::::role:Editor",
				},
			},
		},
	}

	uniqueResourceGroup := generateUniqueResourceGroupName(options.Prefix)

	options.TerraformVars = []testschematic.TestSchematicTerraformVar{
		{Name: "ibmcloud_api_key", Value: options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], DataType: "string", Secure: true},
		{Name: "access_tags", Value: permanentResources["accessTags"], DataType: "list(string)"},
		{Name: "deletion_protection", Value: false, DataType: "bool"},
		{Name: "existing_kms_instance_crn", Value: permanentResources["hpcs_south_crn"], DataType: "string"},
		{Name: "existing_backup_kms_key_crn", Value: permanentResources["hpcs_south_root_key_crn"], DataType: "string"},
		{Name: "mongodb_version", Value: latestVersion, DataType: "string"}, // Always lock this test into the latest supported MongoDB version
		{Name: "existing_resource_group_name", Value: uniqueResourceGroup, DataType: "string"},
		{Name: "plan", Value: "standard", DataType: "string"},
		{Name: "service_credential_names", Value: "{\"admin_test\": \"Administrator\", \"editor_test\": \"Editor\"}", DataType: "map(string)"},
		{Name: "existing_secrets_manager_instance_crn", Value: permanentResources["secretsManagerCRN"], DataType: "string"},
		{Name: "service_credential_secrets", Value: serviceCredentialSecrets, DataType: "list(object)"},
		{Name: "admin_pass_secrets_manager_secret_group", Value: options.Prefix, DataType: "string"},
		{Name: "admin_pass_secrets_manager_secret_name", Value: options.Prefix, DataType: "string"},
		{Name: "prefix", Value: options.Prefix, DataType: "string"},
	}
	err := sharedInfoSvc.WithNewResourceGroup(uniqueResourceGroup, func() error {
		return options.RunSchematicTest()
	})
	assert.Nil(t, err, "This should not have errored")
}

func TestRunExistingInstance(t *testing.T) {
	t.Parallel()
	prefix := fmt.Sprintf("mdb-t-%s", strings.ToLower(random.UniqueId()))
	realTerraformDir := ".."
	tempTerraformDir, _ := files.CopyTerraformFolderToTemp(realTerraformDir, fmt.Sprintf(prefix+"-%s", strings.ToLower(random.UniqueId())))
	region := validICDRegions[rand.Intn(len(validICDRegions))]

	// Verify ibmcloud_api_key variable is set
	checkVariable := "TF_VAR_ibmcloud_api_key"
	val, present := os.LookupEnv(checkVariable)
	require.True(t, present, checkVariable+" environment variable not set")
	require.NotEqual(t, "", val, checkVariable+" environment variable is empty")

	logger.Log(t, "Tempdir: ", tempTerraformDir)
	existingTerraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: tempTerraformDir + "/examples/basic",
		Vars: map[string]interface{}{
			"prefix":            prefix,
			"region":            region,
			"mongodb_version":   latestVersion,
			"service_endpoints": "private",
		},
		// Set Upgrade to true to ensure latest version of providers and modules are used by terratest.
		// This is the same as setting the -upgrade=true flag with terraform.
		Upgrade: true,
	})

	terraform.WorkspaceSelectOrNew(t, existingTerraformOptions, prefix)
	_, existErr := terraform.InitAndApplyE(t, existingTerraformOptions)
	if existErr != nil {
		assert.True(t, existErr == nil, "Init and Apply of temp existing resource failed")
	} else {
		logger.Log(t, "existing_mongodb_instance_crn: ", terraform.Output(t, existingTerraformOptions, "mongodb_crn"))
		options := testschematic.TestSchematicOptionsDefault(&testschematic.TestSchematicOptions{
			Testing: t,
			TarIncludePatterns: []string{
				"*.tf",
				fmt.Sprintf("%s/*.tf", fullyConfigurableSolutionTerraformDir),
				fmt.Sprintf("%s/*.tf", fscloudExampleTerraformDir),
				fmt.Sprintf("%s/*.tf", "modules/fscloud"),
				fmt.Sprintf("%s/*.sh", "scripts"),
			},
			TemplateFolder:         fullyConfigurableSolutionTerraformDir,
			BestRegionYAMLPath:     regionSelectionPath,
			Prefix:                 "mdb-sr-da",
			ResourceGroup:          resourceGroup,
			DeleteWorkspaceOnFail:  false,
			WaitJobCompleteMinutes: 60,
		})

		options.TerraformVars = []testschematic.TestSchematicTerraformVar{
			{Name: "prefix", Value: options.Prefix, DataType: "string"},
			{Name: "ibmcloud_api_key", Value: options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], DataType: "string", Secure: true},
			{Name: "existing_mongodb_instance_crn", Value: terraform.Output(t, existingTerraformOptions, "mongodb_crn"), DataType: "string"},
			{Name: "existing_resource_group_name", Value: resourceGroup, DataType: "string"},
			{Name: "deletion_protection", Value: false, DataType: "bool"},
			{Name: "region", Value: region, DataType: "string"},
			{Name: "provider_visibility", Value: "public", DataType: "string"},
		}
		err := options.RunSchematicTest()
		assert.Nil(t, err, "This should not have errored")

	}
	envVal, _ := os.LookupEnv("DO_NOT_DESTROY_ON_FAILURE")
	// Destroy the temporary existing resources if required
	if t.Failed() && strings.ToLower(envVal) == "true" {
		fmt.Println("Terratest failed. Debug the test and delete resources manually.")
	} else {
		logger.Log(t, "START: Destroy (existing resources)")
		terraform.Destroy(t, existingTerraformOptions)
		terraform.WorkspaceDelete(t, existingTerraformOptions, prefix)
		logger.Log(t, "END: Destroy (existing resources)")
	}

}

// Test the DA when using IBM owned encryption keys
func TestRunfullyConfigurableSolutionIBMKeys(t *testing.T) {
	t.Parallel()

	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:       t,
		TerraformDir:  fullyConfigurableSolutionTerraformDir,
		Region:        "us-south",
		Prefix:        "mongo-key",
		ResourceGroup: resourceGroup,
	})

	options.TerraformVars = map[string]interface{}{
		"mongodb_version":              latestVersion,
		"provider_visibility":          "public",
		"existing_resource_group_name": resourceGroup,
		"prefix":                       options.Prefix,
		"deletion_protection":          false,
	}

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func generateUniqueResourceGroupName(baseName string) string {
	id := uuid.New().String()[:8]
	return fmt.Sprintf("%s-%s", baseName, id)
}
