
variable "resource_tags" {
  type      = map(string)
  sensitive = false
  default   = { "us-east-1" : "us-east-1", Name : "PROG8830-G1-LAB08" }
}

variable "public_subnet_cidr_blocks" {
  type      = list(string)
  sensitive = false
  default   = ["10.0.0.0/24", "10.0.1.0/24"]
}