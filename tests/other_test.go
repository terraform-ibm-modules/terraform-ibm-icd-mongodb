// Tests in this file are NOT run in the PR pipeline. They are run in the continuous testing pipeline along with the ones in pr_test.go
package test

import (
	"crypto/rand"
	"encoding/base64"
	"fmt"

	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
)

func TestRunRestoredDBExample(t *testing.T) {
	t.Parallel()

	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:       t,
		TerraformDir:  "examples/backup-restore",
		Prefix:        "mongo-restored",
		Region:        fmt.Sprint(permanentResources["mongodbRegion"]),
		ResourceGroup: resourceGroup,
		TerraformVars: map[string]interface{}{
			"existing_database_crn": permanentResources["mongodbCrn"],
		},
		CloudInfoService: sharedInfoSvc,
	})

	output, err := options.RunTestConsistency()
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

func TestRunCompleteExample(t *testing.T) {
	t.Parallel()

	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:            t,
		TerraformDir:       "examples/complete",
		Prefix:             "mongodb-cmp",
		BestRegionYAMLPath: regionSelectionPath,
		ResourceGroup:      resourceGroup,
		TerraformVars: map[string]interface{}{
			"users": []map[string]interface{}{
				{
					"name":     "testuser",
					"password": GetRandomAdminPassword(t),
					"type":     "database",
				},
			},
			"admin_pass": GetRandomAdminPassword(t),
		},
		CloudInfoService: sharedInfoSvc,
	})

	region := options.Region
	latestVersion, _ := GetRegionVersions(region)
	options.TerraformVars["mongodb_version"] = latestVersion

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func GetRandomAdminPassword(t *testing.T) string {
	// Generate a 15 char long random string for the admin_pass
	randomBytes := make([]byte, 13)
	_, randErr := rand.Read(randomBytes)
	require.Nil(t, randErr) // do not proceed if we can't gen a random password
	randomPass := "A1" + base64.URLEncoding.EncodeToString(randomBytes)[:13]
	return randomPass
}
