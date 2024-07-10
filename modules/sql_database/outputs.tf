output "server_name" {
  description = "O nome do servidor PostgreSQL"
  value       = azurerm_mssql_server.main.name
}


output "server_id" {
  description = "O nome de domínio totalmente qualificado (FQDN) do servidor PostgreSQL"
  value       = azurerm_mssql_server.main.id
}

output "server_version" {
  value = azurerm_mssql_server.main.version
}

output "administrator_user" {
  value = azurerm_mssql_server.main.administrator_login
}


output "administrator_password" {
  value     = azurerm_mssql_server.main.administrator_login_password
  sensitive = true
}

output "database_ids" {
  description = "A lista de todas as identificações de recursos da base de dados"
  value       = [azurerm_mssql_database.main.*.id]
}

output "firewall_rule_ids" {
  description = "A lista de todos os IDs de recursos de regras de firewall"
  value       = [azurerm_mssql_firewall_rule.main.*.id]
}