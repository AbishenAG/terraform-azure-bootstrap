# Uncomment if creating RG first time else fill existing RG.
# resource "azurerm_resource_group" "rg" { 
#   name     = "example-rg-name"
#   location = "West Europe"
# }

resource "azurerm_storage_account" "str" {
  name                     = "devbackendne02" # Backend Storage Account name. Must be globally unique. 
  resource_group_name      = "RG-BACKEND-ABZ-NE01" # Existing RG name. Use azurerm_resource_group.rg.name if creating RG first time
  location                 = "northeurope" # Use azurerm_resource_group.rg.location if creating RG
  account_tier             = "Standard" # Upgrade to Premium if app needs it in prod environments
  account_replication_type = "LRS" # Use LRS for non-critical environments in dev/stg for lower cost. Use GRS for prod. 
  min_tls_version          = "TLS1_2" # Transport layer security ensures all data  moving between clients and Azure services (like storage account) is encrypted. Protects sensitive data like TF state files, any REST API calls to Azure, internal service-to-service communication. Required for compliance such as ISO 27001, SOC 2, PCI DSS and GDPR - these require 'Encryption in Transit' and TLS is the standard. 

  blob_properties {
    versioning_enabled = true  # To automatically maintain previous versions of blobs.
    change_feed_enabled = true # Required for point-in-time restore

    delete_retention_policy {
       days = 30 # Enables soft-delete for blobs (e.g. terraform.tfstate blob). Number of days it is retained before being permanently deleted.
    }

    container_delete_retention_policy {
      days = 30 # Enables soft-delete for entire container (e.g. tfstate container). Number of days it is retained before being permanently deleted.
    }

    restore_policy {
      days = 14 # Enables point-in-time restore.The number of days you can go back using PITR in an Azure Storage Account. 
    }
  }

tags = {
    Environment    = "stg"
    Division       = "division"
    Department     = "department"
    "Service Name" = "Backend"
    "Cost Centre"  = "1234"
    "IaC"          = "Terraform"
  }
}

# The actual container that will hold Terraform .tfstate files.
resource "azurerm_storage_container" "container" {
  name                  = "tfstate" # Container name
  storage_account_id    = azurerm_storage_account.str.id
  container_access_type = "private" # Must be private. Only authenticated access via Azure SDK/CLI.
}

# To assign RBAC roles, admin account must be a member of the 'Owner' or 'User Access Administrator' role at the subscription or resource group level.
resource "azurerm_role_assignment" "tfstate_access" {
  principal_id   = "" # The object ID of the user, group, or service principal to assign the role to. To retrieve this, use the Azure CLI command: az ad sp show --id <APP_ID> --query objectId if no permission, contact Entra ID/Azure AD admin to retrieve Object ID.
  role_definition_name = "Storage Blob Data Contributor" # The name of the role to assign
  scope         = azurerm_storage_container.container.id
}

