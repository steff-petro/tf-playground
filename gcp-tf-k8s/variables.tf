variable "vm_state" {
  description = "Define state for all the nodes"
  type        = string
  default     = "TERMINATED" # valid states: TERMINATED / RUNNING
}
