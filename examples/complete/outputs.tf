// module market_jenkins_with_ecs
output "this_url_of_market_jenkins_with_ecs" {
  description = "The url of jenkins."
  value       = module.market_jenkins_with_ecs.this_jenkins_url
}

output "this_instance_id_of_jenkins_with_ecs" {
  description = "The instance id of jenkins."
  value       = module.market_jenkins_with_ecs.this_ecs_instance_id
}

output "this_image_id_of_jenkins_with_ecs" {
  description = "The image id of jenkins."
  value       = module.market_jenkins_with_ecs.this_ecs_instance_image_id
}

output "this_vswitch_id_of_jenkins_with_ecs" {
  description = "The vswitch id of jenkins."
  value       = module.market_jenkins_with_ecs.this_vswitch_id
}

// module market_jenkins_with_slb
output "this_url_of_market_jenkins_with_slb" {
  description = "The url of jenkins with creating slb."
  value       = module.market_jenkins_with_slb.this_jenkins_url
}

output "this_instance_id_of_jenkins_with_slb" {
  description = "The instance id of jenkins with creating slb."
  value       = module.market_jenkins_with_slb.this_ecs_instance_id
}

output "this_image_id_of_jenkins_with_slb" {
  description = "The image id of jenkins with creating slb."
  value       = module.market_jenkins_with_slb.this_ecs_instance_image_id
}

output "this_vswitch_id_of_jenkins_with_slb" {
  description = "The vswitch id of jenkins with creating slb."
  value       = module.market_jenkins_with_slb.this_vswitch_id
}

output "this_slb_id_of_jenkins_with_slb" {
  description = "The slb id of jenkins."
  value       = module.market_jenkins_with_slb.this_slb_id
}

output "this_slb_listener_server_group_id_of_jenkins_with_slb" {
  description = "The server group id of jenkins with creating slb."
  value       = module.market_jenkins_with_slb.this_slb_listener_server_group_id
}

// module market_jenkins_with_bind_dns
output "this_url_of_market_jenkins_with_bind_dns" {
  description = "The url of jenkins with binding dns."
  value       = module.market_jenkins_with_bind_dns.this_jenkins_url
}

output "this_instance_id_of_jenkins_with_dns" {
  description = "The instance id of jenkins with binding dns."
  value       = module.market_jenkins_with_bind_dns.this_ecs_instance_id
}

output "this_image_id_of_jenkins_with_dns" {
  description = "The image id of jenkins with binding dns."
  value       = module.market_jenkins_with_bind_dns.this_ecs_instance_image_id
}

output "this_vswitch_id_of_jenkins_with_dns" {
  description = "The vswitch id of jenkins with binding dns."
  value       = module.market_jenkins_with_bind_dns.this_vswitch_id
}

output "this_slb_id_of_jenkins_with_dns" {
  description = "The slb id of jenkins with binding dns."
  value       = module.market_jenkins_with_bind_dns.this_slb_id
}

output "this_slb_listener_server_group_id_of_jenkins_with_dns" {
  description = "The server group id of jenkins with binding dns."
  value       = module.market_jenkins_with_bind_dns.this_slb_listener_server_group_id
}