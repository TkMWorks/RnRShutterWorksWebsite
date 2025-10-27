variable "access_key" {
  type        = string
  description = "AWS Access Key"
}

variable "secret_key" {
  type        = string
  description = "AWS Secret Key"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "eu-west-1"
}

variable "environment" {
  type        = string
  description = "Deployment Environment (e.g., dev, staging, prod)"
}

variable "project_name" {
  type        = string
  description = "Project Name"
  default     = "RnR ShutterWorks"
}

variable "project_code" {
  type        = string
  description = "Project Code"
  default     = "rnrshutterworks"
}

variable "alert_email" {
  type        = string
  description = "Email address for receiving alerts"
  default     = ""
}