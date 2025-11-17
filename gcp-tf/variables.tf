variable "vm_state" {
  description = "Define state for all vm's"
  type        = string
  default     = "TERMINATED" # valid states: TERMINATED / RUNNING
}
