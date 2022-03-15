# ECS instance
ecs_instance_name          = "update-tf-testacc-instance"
ecs_instance_password      = "YourPassword123!update"
system_disk_size           = 50
private_ip                 = "172.16.0.11"
internet_charge_type       = "PayByBandwidth"
internet_max_bandwidth_out = 20
description                = "update-tf-testacc-description"
deletion_protection        = false
force_delete               = true
tags = {
  Name = "updateJenkins"
}

# SLB
slb_name  = "update-tf-testacc-slb-name"
spec      = "slb.s2.medium"
bandwidth = 20
port      = 90

# DNS
host_record = "updatejenkins"