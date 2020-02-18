provider "alicloud" {
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/market-jenkins"
}

data "alicloud_regions" "this" {
  current = true
}

data "alicloud_market_products" "products" {
  search_term           = var.product_keyword
  supplier_name_keyword = var.product_supplier_name_keyword
  suggested_price       = var.product_suggested_price
  product_type          = "MIRROR"
}

data "alicloud_market_product" "product" {
  product_code     = data.alicloud_market_products.products.products.0.code
  available_region = data.alicloud_regions.this.ids.0
}

locals {
  create_slb         = var.create_instance ? var.create_slb : false
  allocate_public_ip = !var.create_instance ? false : local.create_slb == true ? false : var.allocate_public_ip
  bind_domain        = local.create_slb ? var.bind_domain : local.allocate_public_ip ? var.bind_domain : false
}

resource "alicloud_instance" "this" {
  count           = var.create_instance ? 1 : 0
  image_id        = var.image_id != "" ? var.image_id : data.alicloud_market_product.product.product.0.skus.0.images.1.image_id
  instance_type   = var.ecs_instance_type
  security_groups = var.security_group_ids

  instance_name = var.ecs_instance_name
  password      = var.ecs_instance_password

  system_disk_category = var.system_disk_category
  system_disk_size     = var.system_disk_size

  vswitch_id = var.vswitch_id
  private_ip = var.private_ip

  internet_charge_type       = var.internet_charge_type
  internet_max_bandwidth_out = local.allocate_public_ip == true ? var.internet_max_bandwidth_out : 0
  description                = "An ECS instance used to deploy Jenkins."

  resource_group_id   = var.resource_group_id
  deletion_protection = var.deletion_protection
  force_delete        = true
  tags = merge(
    {
      Created     = "Terraform"
      Application = "Market-Jenkins"
    }, var.tags,
  )
}

resource "alicloud_slb" "this" {
  count         = local.create_slb ? 1 : 0
  name          = var.slb_name
  address_type  = "internet"
  vswitch_id    = var.vswitch_id
  specification = var.spec
  bandwidth     = var.bandwidth
  tags = merge(
    {
      Created     = "Terraform"
      Application = "Market-Jenkins"
    }, var.tags,
  )
}

resource "alicloud_slb_server_group" "this" {
  count            = local.create_slb && var.create_instance ? 1 : 0
  load_balancer_id = concat(alicloud_slb.this.*.id, [""])[0]
  servers {
    server_ids = alicloud_instance.this.*.id
    port       = 8080
  }
}

resource "alicloud_slb_listener" "this" {
  count            = local.create_slb ? 1 : 0
  frontend_port    = 8080
  load_balancer_id = concat(alicloud_slb.this.*.id, [""])[0]
  protocol         = "http"
  bandwidth        = var.bandwidth
  server_group_id  = concat(alicloud_slb_server_group.this.*.id, [""])[0]
}

resource "alicloud_dns_record" "this" {
  count       = local.bind_domain ? 1 : 0
  name        = var.domain_name
  host_record = var.host_record
  type        = var.type
  value       = var.create_slb == true ? concat(alicloud_slb.this.*.address, [""])[0] : concat(alicloud_instance.this.*.public_ip, [""])[0]
}
