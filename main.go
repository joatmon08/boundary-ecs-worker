package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"

	"github.com/hashicorp/hcl/v2/gohcl"
	"github.com/hashicorp/hcl/v2/hclwrite"
)

type Tags map[string][]string

func (this *Tags) String() string {
	b, _ := json.Marshal(*this)
	return string(b)
}

func (this *Tags) Set(s string) error {
	return json.Unmarshal([]byte(s), this)
}

type Worker struct {
	PublicAddr      string              `hcl:"public_addr"`
	AuthStoragePath string              `hcl:"auth_storage_path"`
	Tags            map[string][]string `hcl:"tags"`
}

type Listener struct {
	Type    string `hcl:"type,label"`
	Address string `hcl:"address"`
	Purpose string `hcl:"proxy"`
}

type Config struct {
	HCPBoundaryClusterId               string    `hcl:"hcp_boundary_cluster_id"`
	ControllerGeneratedActivationToken string    `hcl:"controller_generated_activation_token"`
	DisableMlock                       bool      `hcl:"disable_mlock"`
	Listener                           *Listener `hcl:"listener,block"`
	Worker                             *Worker   `hcl:"worker,block"`
}

func generateWorkerConfig(clusterID string, controllerToken string, worker *Worker) []byte {
	config := Config{
		DisableMlock: true,
		Listener: &Listener{
			Type:    "tcp",
			Address: "0.0.0.0:9202",
			Purpose: "proxy",
		},
	}

	config.HCPBoundaryClusterId = clusterID
	config.ControllerGeneratedActivationToken = controllerToken
	config.Worker = worker

	f := hclwrite.NewEmptyFile()
	gohcl.EncodeIntoBody(&config, f.Body())

	return f.Bytes()
}

func main() {
	var tags Tags

	ecsCmd := flag.NewFlagSet("ecs", flag.ExitOnError)
	addressPtr := ecsCmd.String("public_address", os.Getenv("BOUNDARY_WORKER_PUBLIC_ADDRESS"), "Public address for Boundary worker")
	authStoragePathPtr := ecsCmd.String("auth_storage_path", "/opt/boundary/worker/auth", "Auth storage path for Boundary worker")
	ecsCmd.Var(&tags, "tags", "Boundary worker tags")

	switch os.Args[1] {
	case "ecs":
		ecsCmd.Parse(os.Args[2:])
		fmt.Println("subcommand 'ecs'")
		fmt.Println("  publicAddress:", *addressPtr)
		fmt.Println("  authStoragePath:", *authStoragePathPtr)
		fmt.Println("  tags:", tags)
	default:
		fmt.Println("expected 'ecs' subcommands")
		os.Exit(1)
	}
}
