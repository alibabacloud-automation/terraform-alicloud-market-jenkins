data "alicloud_zones" "default" {
}

data "alicloud_resource_manager_resource_groups" "default" {
}

data "alicloud_regions" "this" {
  current = true
}

data "alicloud_market_products" "products" {
  search_term           = "Jenkins自动化部署"
  supplier_name_keyword = "科技"
  suggested_price       = 0
  product_type          = "MIRROR"
}

data "alicloud_market_product" "product" {
  product_code     = data.alicloud_market_products.products.products.0.code
  available_region = data.alicloud_regions.this.ids.0
}

data "alicloud_instance_types" "this" {
  availability_zone = data.alicloud_zones.default.zones.0.id
}

resource "alicloud_ecs_disk" "default" {
  zone_id = data.alicloud_zones.default.zones.0.id
  size    = var.system_disk_size
}

resource "alicloud_ecs_snapshot" "default" {
  disk_id  = alicloud_ecs_disk_attachment.default.disk_id
  category = "standard"
  force    = var.force_delete
}

resource "alicloud_ecs_disk_attachment" "default" {
  disk_id     = alicloud_ecs_disk.default.id
  instance_id = module.ecs_instance.this_instance_id[0]
}

resource "alicloud_dns_domain" "default" {
  domain_name = "dns168.abc"
}

# Create a new vpc using terraform module
module "vpc" {
  source             = "alibaba/vpc/alicloud"
  create             = true
  vpc_cidr           = "172.16.0.0/16"
  vswitch_cidrs      = ["172.16.0.0/21"]
  availability_zones = [data.alicloud_zones.default.zones.0.id]
}

# Create a new security and open all ports
module "security_group" {
  source              = "alibaba/security-group/alicloud"
  vpc_id              = module.vpc.this_vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]
}

module "ecs_instance" {
  source = "alibaba/ecs-instance/alicloud"

  number_of_instances = 1

  instance_type      = data.alicloud_instance_types.this.instance_types.0.id
  image_id           = data.alicloud_market_product.product.product.0.skus.0.images.0.image_id
  vswitch_ids        = [module.vpc.this_vswitch_ids[0]]
  security_group_ids = [module.security_group.this_security_group_id]
}

module "market_jenkins_with_ecs_slb_dns" {
  source = "../.."

  #alicloud_market_products
  product_keyword               = "Jenkins"
  product_supplier_name_keyword = "科技"
  product_suggested_price       = 0

  #alicloud_instance
  create_instance = true

  image_id                   = data.alicloud_market_product.product.product.0.skus.0.images.0.image_id
  ecs_instance_type          = data.alicloud_instance_types.this.ids.0
  security_group_ids         = [module.security_group.this_security_group_id]
  ecs_instance_name          = var.ecs_instance_name
  ecs_instance_password      = var.ecs_instance_password
  system_disk_category       = "cloud_efficiency"
  system_disk_size           = var.system_disk_size
  vswitch_id                 = module.vpc.this_vswitch_ids[0]
  private_ip                 = var.private_ip
  internet_charge_type       = var.internet_charge_type
  allocate_public_ip         = true
  internet_max_bandwidth_out = var.internet_max_bandwidth_out
  description                = var.description
  resource_group_id          = data.alicloud_resource_manager_resource_groups.default.groups.0.id
  deletion_protection        = var.deletion_protection
  force_delete               = var.force_delete
  data_disks = [{
    name                 = "data_disks_name"
    size                 = 20
    category             = "cloud_efficiency"
    encrypted            = false
    snapshot_id          = alicloud_ecs_snapshot.default.id
    delete_with_instance = true
    description          = "tf-description"
  }]
  tags = var.tags

  #alicloud_slb
  create_slb = true

  slb_name     = var.slb_name
  address_type = "intranet"
  spec         = var.spec
  bandwidth    = var.bandwidth
  port         = var.port

  #alicloud_slb_listener
  frontend_port = 80

  #alicloud_dns_record
  bind_domain = true

  domain_name = alicloud_dns_domain.default.domain_name
  host_record = var.host_record
  type        = "A"

}