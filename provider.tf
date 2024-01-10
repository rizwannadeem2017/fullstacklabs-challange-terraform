provider "aws" {

  region     = var.region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key

}



variable "aws_access_key_id" {

  default     = ""
  description = "aws access key"

}


variable "aws_secret_access_key" {

  default     = ""
  description = "aws secret key"
}
