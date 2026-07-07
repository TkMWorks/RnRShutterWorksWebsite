variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Deployment Environment (e.g., dev, staging, prod)"
  default     = "dev"
}

variable "project_name" {
  type        = string
  description = "Project Name"
  default     = "RnR ShutterWorks"
}

variable "alert_email" {
  type        = string
  description = "Email address for receiving alerts"
  default     = ""
}

variable "project_owner" {
  type        = string
  description = "Project Owner"
  default     = "TkM"
}