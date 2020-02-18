output "this_ecs_instance_public_ip" {
  description = "The ecs instance public ip."
  value       = module.market-jenkins.this_ecs_instance_public_ip
}

output "this_slb_public_address" {
  description = "The slb public address."
  value       = module.market-jenkins.this_slb_public_address
}

output "this_wordpress_url" {
  description = "The url of wordpress."
  value       = module.market-jenkins.this_wordpress_url
}
