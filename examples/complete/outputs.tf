output "this_url_of_market_jenkins_with_ecs" {
  description = "The url of jenkins."
  value       = module.market_jenkins_with_ecs.this_jenkins_url
}

output "this_url_of_market_jenkins_with_slb" {
  description = "The url of jenkins with creating slb."
  value       = module.market_jenkins_with_slb.this_jenkins_url
}

output "this_url_of_market_jenkins_with_bind_dns" {
  description = "The url of jenkins with binding dns."
  value       = module.market_jenkins_with_bind_dns.this_jenkins_url
}