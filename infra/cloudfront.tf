
locals {
  s3_origin_id = replace("${var.domain_name}.${var.base_domain_name}-origin-id", "/\\W/", "-")
}

resource "aws_cloudfront_origin_access_identity" "app" {
  comment = "${var.domain_name}.${var.base_domain_name}"
}

resource "aws_cloudfront_distribution" "app" {
  origin {
    domain_name = aws_s3_bucket.app.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.app.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.domain_name}-${var.base_domain_name}"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.logs.bucket_domain_name
    prefix          = replace("${var.domain_name}.${var.base_domain_name}-cf", "/\\W/", "-")
  }

  aliases = ["${var.domain_name}.${var.base_domain_name}"]

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "blacklist"
      locations        = ["RU", "CN"]
    }
  }

  tags = {
    Environment = var.environment
    Name        = "${var.domain_name}-${var.base_domain_name}-cf"
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.app.arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2018"
    ssl_support_method             = "sni-only"
  }
}
