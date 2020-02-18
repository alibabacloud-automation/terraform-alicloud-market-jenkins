variable "region" {
  default = "cn-beijing"
}

provider "alicloud" {
  region = var.region
}

data "alicloud_vpcs" "default" {
  is_default = true
}

data "alicloud_vswitches" "default" {
  ids = [data.alicloud_vpcs.default.vpcs.0.vswitch_ids.0]
}

data "alicloud_instance_types" "this" {
  cpu_core_count    = 1
  memory_size       = 2
  availability_zone = data.alicloud_vswitches.default.vswitches.0.zone_id
}

module "market-jenkins" {
  source                     = "../.."
  ecs_instance_name          = "jenkins-instance"
  ecs_instance_password      = "YourPassword123"
  ecs_instance_type          = data.alicloud_instance_types.this.ids.0
  system_disk_category       = "cloud_efficiency"
  security_group_ids         = [module.security_group.this_security_group_id]
  vswitch_id                 = data.alicloud_vpcs.default.vpcs.0.vswitch_ids.0
  internet_max_bandwidth_out = 50
  create_slb                 = true
  bind_domain                = true
  slb_name                   = "slb_jenkins"
  bandwidth                  = 5
  spec                       = "slb.s1.small"
  domain_name                = "cloudxxxx.xxx"
  host_record                = "jenkins"
  type                       = "A"
  allocate_public_ip         = true
}

module "security_group" {
  source              = "alibaba/security-group/alicloud"
  region              = var.region
  vpc_id              = data.alicloud_vpcs.default.ids.0
  name                = "jenkins-1"
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]
}
