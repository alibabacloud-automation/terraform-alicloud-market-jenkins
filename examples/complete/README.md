# Complete Market Jenkins example

Configuration in this directory creates security_group and ECS Instance with image of jenkins.
Data sources are used to discover existing instance type.


## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Outputs

| Name | Description |
|------|-------------|
this_ecs_instance_public_ip
| this\_ecs\_instance\_public\_ip | The public ip of ecs instance |
| this\_slb\_address | The address of SLB |
| this\_domain\_address | The address of domain |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
