package main

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestShouldGenerateCorrectBoundaryWorkerConfig(t *testing.T) {
	clusterID := "testCluster"
	token := "test-token"
	address := "10.0.0.0"
	tags := map[string][]string{
		"type": {"worker1", "upstream"},
	}
	authStoragePath := "/tmp"

	worker := &Worker{
		PublicAddr:      address,
		AuthStoragePath: authStoragePath,
		Tags:            tags,
	}

	config := generateWorkerConfig(clusterID, token, worker)
	fmt.Println(string(config))
	assert.Contains(t, string(config), clusterID, "Worker config does not contain cluster ID")
	assert.Contains(t, string(config), token, "Worker config does not contain token")
	assert.Contains(t, string(config), address, "Worker config does not contain address")
	assert.Contains(t, string(config), authStoragePath, "Worker config does not contain authStoragePath")
	assert.Contains(t, string(config), "tcp", "Worker config does not contain TCP listener")
	assert.Contains(t, string(config), "upstream", "Worker config does not contain upstream tag")
	assert.Contains(t, string(config), "worker1", "Worker config does not contain worker1 tag")
}
