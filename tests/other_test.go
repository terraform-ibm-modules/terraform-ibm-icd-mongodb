// Tests in this file are NOT run in the PR pipeline. They are run in the continuous testing pipeline along with the ones in pr_test.go
package test

import (
	"fmt"
	"strings"

	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
)

func testPlanICDVersions(t *testing.T, version string) {
	t.Parallel()

	prefix := fmt.Sprintf("mongo-%s", strings.ToLower(random.UniqueId()))
	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: "examples/basic",
		TerraformVars: map[string]interface{}{
			"mongodb_version": version,
			"prefix":          prefix,
			"region":          fmt.Sprint(permanentResources["mongodbRegion"]),
		},
		CloudInfoService: sharedInfoSvc,
	})
	output, err := options.RunTestPlan()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestPlanICDVersions(t *testing.T) {
	t.Parallel()

	// This test will run a terraform plan on available stable versions of mongodb
	versions, _ := sharedInfoSvc.GetAvailableIcdVersions("mongodb")
	for _, version := range versions {
		t.Run(version, func(t *testing.T) { testPlanICDVersions(t, version) })
	}
}

func TestRunRestoredDBExample(t *testing.T) {
	t.Parallel()
	prefix := fmt.Sprintf("mongodb-res-%s", strings.ToLower(random.UniqueId()))
	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: "examples/backup-restore",
		TerraformVars: map[string]interface{}{
			"existing_database_crn": permanentResources["mongodbCrn"],
			"prefix":                prefix,
			"region":                fmt.Sprint(permanentResources["mongodbRegion"]),
			"resource_group":        resourceGroup,
		},
		CloudInfoService: sharedInfoSvc,
	})

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}
