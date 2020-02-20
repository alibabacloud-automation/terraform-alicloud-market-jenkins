variable "region" {
  default = "cn-beijing"
}

provider "alicloud" {
  region = var.region
}

#############################################################
# Data sources to get VPC, vswitch details
#############################################################

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
#############################################################
# Create a new security and open all ports
#############################################################

module "security_group" {
  source              = "alibaba/security-group/alicloud"
  region              = var.region
  vpc_id              = data.alicloud_vpcs.default.ids.0
  name                = "jenkins-1"
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]
}

module "market_jenkins_with_ecs" {
  source = "../.."
  region = var.region

  ecs_instance_name          = "jenkins-instance"
  ecs_instance_password      = "YourPassword123"
  ecs_instance_type          = data.alicloud_instance_types.this.ids.0
  system_disk_category       = "cloud_efficiency"
  security_group_ids         = [module.security_group.this_security_group_id]
  vswitch_id                 = data.alicloud_vpcs.default.vpcs.0.vswitch_ids.0
  internet_max_bandwidth_out = 50
  allocate_public_ip         = true
  data_disks = [
    {
      name = "disk-for-jenkins"
      size = 50
    }
  ]
}

// Create a new slb to attach ecs instances
module "market_jenkins_with_slb" {
  source = "../.."
  region = var.region

  ecs_instance_name     = "jenkins-instance"
  ecs_instance_password = "YourPassword123"
  ecs_instance_type     = data.alicloud_instance_types.this.ids.0
  system_disk_category  = "cloud_efficiency"
  security_group_ids    = [module.security_group.this_security_group_id]
  vswitch_id            = data.alicloud_vpcs.default.vpcs.0.vswitch_ids.0

  create_slb = true
  slb_name   = "for-jenkins"
  bandwidth  = 5
  spec       = "slb.s1.small"
}

// Bind a dns domain for this module
module "market_jenkins_with_bind_dns" {
  source = "../.."
  region = var.region

  ecs_instance_name     = "jenkins-instance"
  ecs_instance_password = "YourPassword123"
  ecs_instance_type     = data.alicloud_instance_types.this.ids.0
  system_disk_category  = "cloud_efficiency"
  security_group_ids    = [module.security_group.this_security_group_id]
  vswitch_id            = data.alicloud_vpcs.default.vpcs.0.vswitch_ids.0

  create_slb = true
  slb_name   = "for-jenkins"
  bandwidth  = 5
  spec       = "slb.s1.small"

  bind_domain = true
  domain_name = "cloudfoundry.shop"
  host_record = "jenkins"
  type        = "A"
}