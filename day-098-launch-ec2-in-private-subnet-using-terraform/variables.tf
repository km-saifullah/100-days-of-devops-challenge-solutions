variable "KKE_VPC_CIDR" {
  description = "CIDR block for the private VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "KKE_SUBNET_CIDR" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.1.0/24"
}