output "bucket_regional_domain_name" {
  value = "https://${aws_s3_bucket.front_end_bucket.bucket_regional_domain_name}/index.html"
}