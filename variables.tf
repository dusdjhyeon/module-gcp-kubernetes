variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "asia-northeast3"
}

variable "env_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "gke_machine_type" {
  type = string
}

variable "gke_num_nodes" {
  default = 3
}

variable "gke_namespace" {
  type = string
}

variable "subnet_id" {
  type = string
  default = "subnet"
}