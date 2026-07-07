resource "aws_s3_bucket" "image_landing_zone" {
  bucket        = "${var.environment}-${local.project_code}-image-lz"
  region        = var.aws_region
  force_destroy = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name} Image Landing Zone"
  })
}

resource "aws_s3_bucket_notification" "image_lz_sns_notification" {
  bucket = aws_s3_bucket.image_landing_zone.id
  topic {
    topic_arn = aws_sns_topic.image_upload_topic.arn
    events    = ["s3:ObjectCreated:*"]
  }
  depends_on = [aws_sns_topic.image_upload_topic]
}

resource "aws_s3_bucket_lifecycle_configuration" "image_lz_lifecycle" {
  bucket = aws_s3_bucket.image_landing_zone.id
  rule {
    id     = "ExpireOldImages"
    status = "Enabled"

    expiration {
      days = 4
    }

    filter {
      prefix = ""
    }
  }
}

resource "aws_s3_bucket" "image_gallery" {
  bucket        = "${var.environment}-${local.project_code}-image-gallery"
  region        = var.aws_region
  force_destroy = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name} Image Gallery"
  })
}

resource "aws_s3_bucket_policy" "gallery_s3_bucket_policy" {
  bucket = aws_s3_bucket.image_gallery.id
  policy = data.aws_iam_policy_document.gallery_s3_bucket_policy.json
}

resource "aws_s3_bucket_notification" "gallery_s3_image_upload_sns_notification" {
  bucket = aws_s3_bucket.image_gallery.id

  topic {
    topic_arn     = aws_sns_topic.alert_topic.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "${local.project_code}/Images/"
    filter_suffix = ".jpg"
  }

  topic {
    topic_arn     = aws_sns_topic.alert_topic.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "${local.project_code}/Images/"
    filter_suffix = ".jpeg"
  }

  topic {
    topic_arn     = aws_sns_topic.alert_topic.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "${local.project_code}/"
    filter_suffix = ".html"
  }

  depends_on = [aws_sns_topic.alert_topic]
}

resource "aws_s3_object" "background_image" {
  key           = "${local.project_code}/backgroundimage.jpg"
  bucket        = aws_s3_bucket.image_gallery.id
  source        = "../src/website/backgroundimage.jpg"
  force_destroy = true
  etag          = filemd5("../src/website/backgroundimage.jpg")
  content_type  = "image/jpeg"
  tags = merge(local.common_tags, {
    Name = "${var.project_name} Website Background Image"
  })
}

resource "aws_s3_object" "favicon" {
  key           = "${local.project_code}/favicon.png"
  bucket        = aws_s3_bucket.image_gallery.id
  source        = "../src/website/favicon.png"
  force_destroy = true
  etag          = filemd5("../src/website/favicon.png")
  content_type  = "image/png"
  tags = merge(local.common_tags, {
    Name = "${var.project_name} Website Favourite Icon"
  })
}

resource "aws_s3_object" "website_logo" {
  key           = "${local.project_code}/R&RShutterWorks_Logo.svg"
  bucket        = aws_s3_bucket.image_gallery.id
  source        = "../src/website/R&RShutterWorks_Logo.svg"
  force_destroy = true
  etag          = filemd5("../src/website/R&RShutterWorks_Logo.svg")
  content_type  = "image/svg+xml"
  tags = merge(local.common_tags, {
    Name = "${var.project_name} Website Logo"
  })
}

resource "aws_s3_object" "javascript_file" {
  key           = "${local.project_code}/script.js"
  bucket        = aws_s3_bucket.image_gallery.id
  source        = "../src/website/script.js"
  force_destroy = true
  etag          = filemd5("../src/website/script.js")
  content_type  = "text/javascript"
  tags = merge(local.common_tags, {
    Name = "${var.project_name} Javascript File"
  })
}

resource "aws_s3_object" "css_stylesheet" {
  key           = "${local.project_code}/styles.css"
  bucket        = aws_s3_bucket.image_gallery.id
  source        = "../src/website/styles.css"
  force_destroy = true
  etag          = filemd5("../src/website/styles.css")
  content_type  = "text/css"
  tags = merge(local.common_tags, {
    Name = "${var.project_name} CSS Stylesheet"
  })
}