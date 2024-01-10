variable "region" {
  default     = "us-wes-1"
  description = "define region name"

}


variable "environment" {

  default     = ""
  description = "name of environment"
}

variable "s3_count" {

  default = {

    "us-west-1.dev"     = "1"
    "us-west-1.staging" = "0"
    "us-west-1.prod"    = "0"
  }

}