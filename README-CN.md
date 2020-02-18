terraform-alicloud-market-jenkins
=====================================================================

本 Terraform 模块将使用 Jenkins 镜像来创建 ECS 实例，并将实例绑定到 SLB，如果域名变量存在，则会将域名与 SLB 关联。

## Terraform 版本

本模板要求使用版本 Terraform 0.12 和 阿里云 Provider 1.72.0+。

## 用法

```hcl
module "market-jenkins" {
  source                     = "../.."
  region                     = "cn-beijing"

  product_keyword            = "Jenkins自动化部署"
  product_suggested_price    = 0

  ecs_instance_name          = "jenkins-instance"
  ecs_instance_password      = "YourPassword123"
  ecs_instance_type          = "ecs.sn1ne.large"
  system_disk_category       = "cloud_efficiency"
  security_group_ids         = ["sg-45678xxx"]
  vswitch_id                 = "vsw-345678xxx"
  internet_max_bandwidth_out = 50
  create_slb                 = true
  bind_domain                = true
  slb_name                   = "slb_jenkins"
  bandwidth                  = 5
  spec                       = "slb.s1.small"
  domain_name                = "cloudxxxx.xxx"
  host_record                = "jenkins"
  type                       = "A"
}
```

## 示例

* [Jenkins 完整示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-market-jenkins/tree/master/examples/complete)

## 注意事项

* 本 Module 使用的 AccessKey 和 SecretKey 可以直接从 `profile` 和 `shared_credentials_file` 中获取。如果未设置，可通过下载安装 [aliyun-cli](https://github.com/aliyun/aliyun-cli#installation) 后进行配置。

提交问题
------
如果在使用该 Terraform Module 的过程中有任何问题，可以直接创建一个 [Provider Issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new)，我们将根据问题描述提供解决方案。

**注意:** 不建议在该 Module 仓库中直接提交 Issue。

作者
-------
Created and maintained by Li Xue(lixue_9250@163.com) and He Guimin(@xiaozhu36, heguimin36@163.com)

许可
----
Apache 2 Licensed. See LICENSE for full details.

参考
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)
