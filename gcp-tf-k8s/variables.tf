variable "vm_state" {
  description = "Define state for all the nodes"
  type        = string
  default     = "RUNNING" # valid states: TERMINATED / RUNNING
}

variable "project" {
  description = "gcp project"
  type        = string
  default     = "affable-ring-478314-u4"
}

variable "cidr_controlplane_subnet" {
  description = "the cidr of the controlplane subnet"
  type        = string
  default     = "192.168.10.0/24"

}

variable "cidr_workers_subnet" {
  description = "the cidr of the controlplane subnet"
  type        = string
  default     = "192.168.20.0/24"
}

variable "pod_cidr" {
  description = "value set for pod cidr"
  type        = string
  default     = "10.244.0.0/16"
}
