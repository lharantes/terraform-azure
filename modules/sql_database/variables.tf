
variable "resource_group_name" {
  type        = string
  description = "Nome do Resource Group"
}

variable "location" {
  type        = string
  description = "Localidade do Azure Sql Server"
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Mapa de caracteres identificando através de `chave = valor` quais são os rótulos dos recursos."
}

variable "name" {
  type        = string
  description = "Nome do Azure Sql Server"
  default     = ""
}

variable "server_version" {
  type        = string
  description = "Especifica a versão do SQL a ser usada"
  default     = "11.0"
  validation {
    condition     = can(regex("12.0|11.0", var.server_version))
    error_message = "Selecione apenas um dos valores aceitos: 12.0 ou 11.0."
  }
}

variable "administrator_login" {
  type        = string
  description = "O nome de login do administrador para o novo servidor."
  default     = ""
}

variable "administrator_password" {
  type        = string
  description = "A senha associada ao administrator_login usuário"
  default     = ""
}

variable "minimum_tls_version" {
  type        = string
  default     = "1.2"
  description = "A versão mínima do TLS para suporte no servidor."
  validation {
    condition     = can(regex("Disabled|1.0|1.1|1.2", var.minimum_tls_version))
    error_message = "Selecione apenas um dos valores aceitos: Disabled, 1.0, 1.1 e 1.2."
  }
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Se o acesso à rede pública é permitido para este servidor."
}

variable "primary_user_assigned_identity_id" {
  type        = string
  description = "Especifica o id de identidade gerenciada do usuário principal."
  default     = ""
}

variable "azuread_administrator_enabled" {
  type        = bool
  default     = false
  description = "Habilita usuarios do AAD a efeturam autenticação no SQL Server"
}

variable "azuread_administrator" {
  type = list(object({
    login_username = optional(string)
    object_id      = optional(string)
  }))
  description = <<-EOT
    list(object({
      login_username    = (Optional) O nome de usuário de logon do administrador do Azure AD deste SQL Server.
      object_id         = (Optional) A ID do objeto do administrador do Azure AD deste SQL Server.
  }))
EOT
  default     = []
  nullable    = false
}

variable "azuread_authentication_only" {
  type        = bool
  default     = false
  description = " Especifica se apenas AD Users e administradores (como azuread_administrator.0.login_username) podem ser usados para login, ou também usuários de bancos de dados locais (como administrator_login)."
}

variable "identity_enabled" {
  type        = bool
  default     = false
  description = "Habilita o uso de identidades gerenciadas no SQL Server"
}

variable "identity_type" {
  type        = string
  description = "Especifica o tipo de Identidade de Serviço Gerenciado que deve ser configurado neste SQL Server."
  default     = "SystemAssigned"
}

variable "identity_ids" {
  type        = list(any)
  description = "Especifica uma lista de IDs de identidade gerenciada atribuídas pelo usuário a serem atribuídas a este SQL Server."
  default     = [""]
}

variable "db_names" {
  description = "A lista de nomes da Base de Dados SQL. A alteração desta obriga à criação de um novo recurso."
  type        = list(string)
  default     = []
}

variable "collation" {
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
  description = "Especifica o agrupamento do banco de dados. Alterar isso força a criação de um novo recurso."
}

variable "license_type" {
  type        = string
  default     = "LicenseIncluded"
  description = "Especifica o tipo de licença aplicada a este banco de dados. Os valores possíveis são LicenseIncludede BasePrice"
  validation {
    condition     = can(regex("LicenseIncluded|BasePrice", var.license_type))
    error_message = "Selecione apenas um dos valores aceitos: LicenseIncluded e BasePrice"
  }
}

variable "max_size_gb" {
  type        = number
  default     = 4
  description = "O tamanho máximo do banco de dados em gigabytes."
}

variable "read_scale" {
  type        = bool
  default     = true
  description = "Se ativado, as conexões que têm a intenção do aplicativo definida como somente leitura em sua string de conexão podem ser roteadas para uma réplica secundária somente leitura. Esta propriedade só pode ser configurada para bancos de dados Premium e Business Critical."
}

variable "sku_name" {
  type        = string
  default     = "Basic"
  description = "Especifica o nome do SKU usado pelo banco de dados. Por exemplo, GP_S_Gen5_2, HS_Gen4_1, BC_Gen5_2, ElasticPool, Basic, S0, P2, DW100c, DS100. Alterar isso da camada de serviço HyperScale para outra camada de serviço criará um novo recurso."
  validation {
    condition     = can(regex("GP_S_Gen5_2|HS_Gen4_1|BC_Gen5_2|ElasticPool|Basic|S0|P2|DW100c|DS100", var.sku_name))
    error_message = "Selecione apenas um dos valores aceitos:  GP_S_Gen5_2, HS_Gen4_1, BC_Gen5_2, ElasticPool, Basic, S0, P2, DW100c, DS100"
  }
}

variable "zone_redundant" {
  type        = bool
  default     = true
  description = "Availability Zones habilitadas para o SQl Database."
}

variable "firewall_rules" {
  description = "A lista de mapas, descrevendo as regras de firewall. Itens válidos do mapa: nome, start_ip, end_ip."
  type        = list(map(string))
  default     = []
}