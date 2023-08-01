variable "region" {
  type        = string
  description = "AWS Region (being set using environment variable TF_VAR_region)"

}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security groups IDs"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs"
}

variable "endpoints" {
  type        = string
  description = "Comma-separated list of domain addresses (HTTP/S endpoints)"
  default     = ""
}

variable "confluence_space" {
  type        = string
  description = "Confluence space key"
}

variable "confluence_parent_page_id" {
  type        = string
  description = "Confluence page parent ID under which page with report will be generated"
  default     = ""
}

variable "confluence_mail_address" {
  type        = string
  description = "Confluence mail address (being set using environment variable TF_VAR_confluence_mail_address)"
  default     = null
}

variable "confluence_api_key" {
  type        = string
  description = "Confluence API key (being set using environment variable TF_VAR_confluence_api_key)"
  default     = null
}
