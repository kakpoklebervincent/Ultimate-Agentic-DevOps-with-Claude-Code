output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution (used for cache invalidation)."
  value       = aws_cloudfront_distribution.site.id
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name serving the site."
  value       = aws_cloudfront_distribution.site.domain_name
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket holding the site content."
  value       = aws_s3_bucket.site.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket holding the site content."
  value       = aws_s3_bucket.site.arn
}
