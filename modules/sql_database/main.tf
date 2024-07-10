data "azurerm_resource_group" "sql" {
  name = var.resource_group_name
}

resource "azurerm_mssql_server" "main" {
  name                          = var.name
  resource_group_name           = data.azurerm_resource_group.sql.name
  location                      = var.location == null ? data.azurerm_resource_group.sql.location : var.location
  version                       = var.server_version
  administrator_login           = var.azuread_authentication_only ? "" : var.administrator_login
  administrator_login_password  = var.azuread_authentication_only ? "" : var.administrator_password
  minimum_tls_version           = var.minimum_tls_version
  public_network_access_enabled = var.public_network_access_enabled

  dynamic "azuread_administrator" {
    for_each = var.azuread_administrator_enabled ? ["azuread_administrator"] : []
    content {
      login_username              = each.value.login_username
      object_id                   = each.value.object_id
      azuread_authentication_only = var.azuread_authentication_only
    }
  }

  dynamic "identity" {
    for_each = var.identity_enabled ? ["identity"] : []

    content {
      type         = var.identity_type
      identity_ids = var.identity_ids
    }
  }

  tags = var.tags
}

resource "azurerm_mssql_database" "main" {
  count          = length(var.db_names)
  name           = var.db_names[count.index]
  server_id      = azurerm_mssql_server.main.id
  collation      = var.collation
  license_type   = var.license_type
  tags           = var.tags
  max_size_gb    = var.max_size_gb
  read_scale     = var.read_scale
  sku_name       = var.sku_name
  zone_redundant = var.zone_redundant
}

resource "azurerm_mssql_firewall_rule" "main" {
  count            = length(var.firewall_rules)
  name             = var.firewall_rules[count.index]["name"]
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = var.firewall_rules[count.index]["start_ip"]
  end_ip_address   = var.firewall_rules[count.index]["end_ip"]
}