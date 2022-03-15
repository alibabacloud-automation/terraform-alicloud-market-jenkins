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
  allocate_public_ip = !var.create_instance ? false : local.create_slb ? false : var.allocate_public_ip
  bind_domain        = local.create_slb ? var.bind_domain : local.allocate_public_ip ? var.bind_domain : false
  this_app_url       = var.bind_domain ? format("%s%s", var.host_record != "" ? "${var.host_record}." : "", var.domain_name) : var.create_slb ? format("%s:8080", concat(alicloud_slb.this.*.address, [""])[0]) : var.create_instance ? format("%s:8080", concat(alicloud_instance.this.*.public_ip, [""])[0]) : ""
}

resource "alicloud_instance" "this" {
  count           = var.create_instance ? 1 : 0
  image_id        = var.image_id != "" ? var.image_id : data.alicloud_market_product.product.product.0.skus.0.images.0.image_id
  instance_type   = var.ecs_instance_type
  security_groups = var.security_group_ids

  instance_name = var.ecs_instance_name
  password      = var.ecs_instance_password

  system_disk_category = var.system_disk_category
  system_disk_size     = var.system_disk_size

  vswitch_id = var.vswitch_id
  private_ip = var.private_ip

  internet_charge_type       = var.internet_charge_type
  internet_max_bandwidth_out = local.allocate_public_ip ? var.internet_max_bandwidth_out : 0
  description                = var.description

  resource_group_id   = var.resource_group_id
  deletion_protection = var.deletion_protection
  force_delete        = var.force_delete
  dynamic "data_disks" {
    for_each = var.data_disks
    content {
      name                 = lookup(data_disks.value, "name", )
      size                 = lookup(data_disks.value, "size", 20)
      category             = lookup(data_disks.value, "category", "cloud_efficiency")
      encrypted            = lookup(data_disks.value, "encrypted", null)
      snapshot_id          = lookup(data_disks.value, "snapshot_id", null)
      delete_with_instance = lookup(data_disks.value, "delete_with_instance", null)
      description          = lookup(data_disks.value, "description", null)
    }
  }
  tags = merge(
    {
      Created     = "Terraform"
      Application = "Market-Jenkins"
    }, var.tags,
  )
}

resource "alicloud_slb" "this" {
  count              = local.create_slb ? 1 : 0
  load_balancer_name = var.slb_name
  address_type       = var.address_type
  vswitch_id         = var.vswitch_id
  load_balancer_spec = var.spec
  bandwidth          = var.bandwidth
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
    port       = var.port
  }
}

resource "alicloud_slb_listener" "this" {
  count            = local.create_slb ? 1 : 0
  frontend_port    = var.frontend_port
  load_balancer_id = concat(alicloud_slb.this.*.id, [""])[0]
  protocol         = "http"
  bandwidth        = var.bandwidth
  server_group_id  = concat(alicloud_slb_server_group.this.*.id, [""])[0]
}

resource "alicloud_dns_record" "this" {
  count       = local.bind_domain ? 1 : 0
  name        = var.domain_name
  value       = var.create_slb ? concat(alicloud_slb.this.*.address, [""])[0] : concat(alicloud_instance.this.*.public_ip, [""])[0]
  host_record = var.host_record
  type        = var.type
}