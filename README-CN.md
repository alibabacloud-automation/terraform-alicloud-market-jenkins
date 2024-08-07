# 下线公告

感谢您对阿里云 Terraform Module 的关注。即日起，本 Module 将停止维护并会在将来正式下线。更多丰富的 Module 可在 [阿里云 Terraform Module](https://registry.terraform.io/browse/modules?provider=alibaba) 中搜索获取。

再次感谢您的理解和合作。

terraform-alicloud-market-jenkins
=====================================================================

本 Terraform 模块将使用 Jenkins 镜像来创建 ECS 实例，并将实例绑定到 SLB，如果域名变量存在，则会将域名与 SLB 关联。

## 用法

使用云市场镜像搭建 Jenkins

```hcl
module "market_jenkins_with_ecs" {
  source  = "terraform-alicloud-modules/market-jenkins/alicloud"

  product_keyword            = "Jenkins自动化部署"
  product_suggested_price    = 0
  
  ecs_instance_name          = "jenkins-instance"
  ecs_instance_password      = "YourPassword123"
  ecs_instance_type          = "ecs.sn1ne.large"
  system_disk_category       = "cloud_efficiency"
  security_group_ids         = ["sg-132txxxxx"]
  vswitch_id                 = "vsw-32refxxxx"
  internet_max_bandwidth_out = 50
  allocate_public_ip         = true
  data_disks = [
    {
      name = "disk-for-jenkins"
      size = 50
    }
  ]
}
```

使用云市场镜像搭建 Jenkins 并为其绑定一个负载均衡器

```hcl
module "market_jenkins_with_slb" {
  source  = "terraform-alicloud-modules/market-jenkins/alicloud"

  product_keyword            = "Jenkins"
  product_suggested_price    = 0
  
  ecs_instance_name     = "jenkins-instance"
  ecs_instance_password = "YourPassword123"
  ecs_instance_type     = "ecs.sn1ne.large"
  system_disk_category  = "cloud_efficiency"
  security_group_ids    = ["sg-132txxxxx"]
  vswitch_id            = "vsw-32refxxxx"

  create_slb = true
  slb_name   = "for-jenkins"
  bandwidth  = 5
  spec       = "slb.s1.small"
}
```

使用云市场镜像搭建 Jenkins 并为其绑定一个负载均衡器和分配一个Dns

```hcl
module "market_jenkins_with_bind_dns" {
  source  = "terraform-alicloud-modules/market-jenkins/alicloud"

  ecs_instance_name     = "jenkins-instance"
  ecs_instance_password = "YourPassword123"
  ecs_instance_type     = "ecs.sn1ne.large"
  system_disk_category  = "cloud_efficiency"
  security_group_ids    = ["sg-132txxxxx"]
  vswitch_id            = "vsw-32refxxxx"

  create_slb = true
  slb_name   = "for-jenkins"
  bandwidth  = 5
  spec       = "slb.s1.small"

  bind_domain = true
  domain_name = "cloudxxxx.xxx"
  host_record = "jenkins"
  type        = "A"
}
```

## 示例

* [Jenkins 完整示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-market-jenkins/tree/master/examples/complete)

## 注意事项
本Module从版本v1.1.0开始已经移除掉如下的 provider 的显式设置：

```hcl
provider "alicloud" {
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/market-jenkins"
}
```

如果你依然想在Module中使用这个 provider 配置，你可以在调用Module的时候，指定一个特定的版本，比如 1.0.0:

```hcl
module "market_jenkins_with_ecs" {
  source                  = "terraform-alicloud-modules/market-jenkins/alicloud"
  version                 = "1.0.0"
  region                  = "cn-beijing"
  profile                 = "Your-Profile-Name"
  product_keyword         = "Jenkins自动化部署"
  product_suggested_price = 0
  // ...
}
```

如果你想对正在使用中的Module升级到 1.1.0 或者更高的版本，那么你可以在模板中显式定义一个相同Region的provider：
```hcl
provider "alicloud" {
  region  = "cn-beijing"
  profile = "Your-Profile-Name"
}
module "market_jenkins_with_ecs" {
  source                  = "terraform-alicloud-modules/market-jenkins/alicloud"
  product_keyword         = "Jenkins自动化部署"
  product_suggested_price = 0
  // ...
}
```
或者，如果你是多Region部署，你可以利用 `alias` 定义多个 provider，并在Module中显式指定这个provider：

```hcl
provider "alicloud" {
  region  = "cn-beijing"
  profile = "Your-Profile-Name"
  alias   = "bj"
}
module "market_jenkins_with_ecs" {
  source                  = "terraform-alicloud-modules/market-jenkins/alicloud"
  providers               = {
    alicloud = alicloud.bj
  }
  product_keyword         = "Jenkins自动化部署"
  product_suggested_price = 0
  // ...
}
```

定义完provider之后，运行命令 `terraform init` 和 `terraform apply` 来让这个provider生效即可。

更多provider的使用细节，请移步[How to use provider in the module](https://www.terraform.io/docs/language/modules/develop/providers.html#passing-providers-explicitly)

## Terraform 版本

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.71.0 |

提交问题
------
如果在使用该 Terraform Module 的过程中有任何问题，可以直接创建一个 [Provider Issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new)，我们将根据问题描述提供解决方案。

**注意:** 不建议在该 Module 仓库中直接提交 Issue。

作者
-------
Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com)

许可
----
Apache 2 Licensed. See LICENSE for full details.

参考
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)