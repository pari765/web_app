variable "region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ssh_key_path" {
  description = "Path to SSH private key"
}
