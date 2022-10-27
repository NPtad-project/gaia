#define variable for instance use
variable "jumpbox-password" {
  type = string
  description = "Fill in password value for jumpbox"
  default = "Fsoft@2022"
  sensitive = true
  
}

variable "rg-name" {
  type = string
  default = "1-2ad15f29-playground-sandbox"
  description = "name of the resource group playground provide"
}





