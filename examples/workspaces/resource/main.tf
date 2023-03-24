terraform {
  required_providers {
    singlestore = {
      source = "registry.terraform.io/singlestoredb/singlestore"
    }
  }
}

provider "singlestore" {
  # export SINGLESTORE_API_KEY with a SingleStore Management API key
  #test_replace_with_api_key
  #test_replace_with_api_service_url
}

data "singlestore_regions" "all" {}

resource "singlestore_workspace_group" "example" {
  name            = "terraform-provider-ci-integration-test-workspace-group"
  firewall_ranges = [] # Allows all the traffic. Make sure to set explicit CIDR ranges for production environments.
  expires_at      = "2222-01-01T00:00:00Z"
  region_id       = data.singlestore_regions.all.regions.0.id # In production, prefer indicating the explicit region ID because the list of regions changes.
  admin_password  = "fooBAR12$"                               # Exlicitly setting password is not mandatory. If it is not indicated, server generates one.
}

resource "singlestore_workspace" "example" {
  name               = "test-workspace"
  workspace_group_id = singlestore_workspace_group.example.id
  size               = "0.25"
}