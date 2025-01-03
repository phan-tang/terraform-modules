output "rest_api_invoke_urls" {
  value = values(module.api_gateway)[*].rest_api_invoke_url
}

output "bucket_regional_domain_name" {
  value = "${module.front_end.bucket_regional_domain_name}"
}