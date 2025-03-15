## GENERAL

variable "zona" {
	default = "westeurope"
	description = "A Que region vamos"
}

variable "namespace" {
	default = "hiperion"
	description = "Namespace desplegar objetos"
}


variable "hostname" {
	default = "practica"
	description = "Nombre del Host"
}

variable "gr_recursos" {
	type = tuple([ string, string ])
  default = ["main_resources","westeurope"]
	description = "Grupo de Recursos "
}

variable "username" {
  type        = string
  description = "El usuario para la  VM."
  default     = "azureadmin"
}

variable "vm_name" {
  type        = string
  description = "Nombre para la  VM."
  default     = "practica_vm"
}

variable "vm_size" {
  type        = string
  description = "Tipo y tamaño VM"
  default     = "Standard_B2ls_v2"
  # B2als v2
}




## RED

variable "vn_address" {
	default =  ["10.0.0.0/16"]
	description = "Rangos region"
}

variable "terraformsubnet" {
	default = ["10.0.1.0/24"]
	description = "Rangos region subnet backend"
}

variable "k8s_subnet" {
	default = ["10.0.2.0/24"]
	description = "Rangos para Cluster de Kubernetes"
}

variable "vn_address_frontend" {
	default = ["10.0.3.0/24"]
	description = "Rangos region subnmet frontend"
}

variable "private_ip_address" {
	default = "10.0.1.10"
	description = "Ip privada interfaz"
}



## KEY VAULT



variable "key_vault" {
  type        = string
  description = "Nombre el key vault."
  default     = "terraform-keyvault15"
}



variable "key_vault_secret" {
  type        = string
  description = "Nombre del secreto del key vault."
  default     = "kv78"
}

## ACR


variable "acr_name" {
  type        = string
  description = "Nombre del ACR"
  default     = "terraformacr202503"
}

variable "acr_images" {
 description = "Lista de Imagenes de ACS"
 type        = list(string)
 default     = ["nginx:stable-otel", "redis:alpine3.21", "example-voting-app-vote:latest"]
}

## AKS
variable "kubernetes_name" {
  type        = string
  description = "Nombre del cluster de AKS"
  default     = "terraformk8s"
}

variable "default_node_pool_vm_size" {
  description = "(Optional) The size of the Virtual Machine, such as Standard_DS2_v2."
#  default     = "Standard_D2_v2"
   default     = "Standard_B2s"
}

variable "namespace_terraform" {
  description = "Namespace for AKS Objects"
  type = string
  default  = "from-terraform"
}


variable "default_node_pool_max_pods" {
  description = "(Optional) The maximum number of pods that can run on each agent. Changing this forces a new resource to be created."
  default     = "110"
}

variable "default_node_pool_os_disk_size_gb" {
  description = "(Optional) The size of the OS Disk which should be used for each agent in the Node Pool. Changing this forces a new resource to be created."
  default     = "40"
}

variable "default_node_pool_min_count" {
  description = "(Required if default_node_pool_enable_auto_scaling variable is set to true). The minimum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 100."
  default     = null
}

variable "default_node_pool_max_count" {
  description = "(Required if default_node_pool_enable_auto_scaling variable is set to true) The maximum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 100."
  default     = null
}

variable "default_node_pool_enable_auto_scaling" {
  description = "(Optional) Should the Kubernetes Auto Scaler be enabled for this Node Pool? Defaults to true."
  default     = "false"
}

variable "default_node_pool_name" {
  description = "(Optional) The name which should be used for the default Kubernetes Node Pool. Changing this forces a new resource to be created."
  default     = "poolmin"
}

variable "default_node_pool_node_count" {
  description = "(Required if default_node_pool_enable_auto_scaling variable is set to false). The initial number of nodes which should exist in this Node Pool. If specified this must be between 1 and 100."
  default     = 1
}

variable "default_node_pool_type" {
  description = "(Optional) The type of Node Pool which should be created. Possible values are AvailabilitySet and VirtualMachineScaleSets. Defaults to VirtualMachineScaleSets."
  default     = "VirtualMachineScaleSets"
}