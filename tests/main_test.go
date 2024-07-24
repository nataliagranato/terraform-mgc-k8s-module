package test

import (
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformCluster(t *testing.T) {
	t.Parallel()

	// Configura o caminho para os arquivos Terraform
	terraformOptions := &terraform.Options{
		TerraformDir: "../",
	}

	// Defer a função para destruir a infraestrutura ao final do teste
	defer terraform.Destroy(t, terraformOptions)

	// Executa o Terraform init e apply
	terraform.InitAndApply(t, terraformOptions)

	// Verifica se o cluster foi criado corretamente
	clusterID := terraform.Output(t, terraformOptions, "cluster_id")
	assert.NotEmpty(t, clusterID)

	// Verifica se o nodepool foi criado corretamente
	nodepoolID := terraform.Output(t, terraformOptions, "nodepool_id")
	assert.NotEmpty(t, nodepoolID)
}