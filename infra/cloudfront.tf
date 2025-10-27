resource "aws_cloudfront_origin_access_control" "s3_gallery_oac" {
  name                              = "${var.environment}-${var.project_code}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "image_gallery_distribution" {
  origin {
    domain_name              = aws_s3_bucket.image_gallery.bucket_regional_domain_name
    origin_id                = "S3-${aws_s3_bucket.image_gallery.id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_gallery_oac.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront Distribution for ${var.project_name} Image Gallery"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "S3-${aws_s3_bucket.image_gallery.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name} Image Gallery Distribution"
  })
}