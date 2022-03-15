# ECS instance
variable "ecs_instance_name" {
  description = "The name of ECS Instance."
  type        = string
  default     = "tf-testacc-instance"
}

variable "ecs_instance_password" {
  description = "The password of ECS instance."
  type        = string
  default     = "YourPassword123!"
}

variable "system_disk_size" {
  description = "The system disk size used to launch ecs instance."
  type        = number
  default     = 40
}

variable "private_ip" {
  description = "Configure ECS Instance private IP address"
  type        = string
  default     = "172.16.0.10"
}

variable "internet_charge_type" {
  description = "The internet charge type of ECS instance. Choices are 'PayByTraffic' and 'PayByBandwidth'."
  type        = string
  default     = "PayByTraffic"
}

variable "internet_max_bandwidth_out" {
  description = "The maximum internet out bandwidth of ECS instance."
  type        = number
  default     = 10
}

variable "description" {
  description = "Description of the instance, This description can have a string of 2 to 256 characters, It cannot begin with http:// or https://. Default value is null."
  type        = string
  default     = "tf-testacc-description"
}

variable "deletion_protection" {
  description = "Whether enable the deletion protection or not. 'true': Enable deletion protection. 'false': Disable deletion protection."
  type        = bool
  default     = true
}

variable "force_delete" {
  description = "If it is true, the 'PrePaid' instance will be change to 'PostPaid' and then deleted forcibly. However, because of changing instance charge type has CPU core count quota limitation, so strongly recommand that 'Don't modify instance charge type frequentlly in one month'."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to the ECS and SLB."
  type        = map(string)
  default = {
    Name = "Jenkins"
  }
}

# SLB
variable "slb_name" {
  description = "The name of a new load balancer."
  type        = string
  default     = "tf-testacc-slb-name"
}

variable "spec" {
  description = "The specification of the SLB instance."
  type        = string
  default     = "slb.s1.small"
}

variable "bandwidth" {
  description = "The load balancer instance bandwidth."
  type        = number
  default     = 10
}

variable "port" {
  description = "The port of instance."
  type        = number
  default     = 80
}

#DNS
variable "host_record" {
  description = "Host record for the domain record."
  type        = string
  default     = "jenkins"
}