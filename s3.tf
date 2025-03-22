resource "aws_s3_bucket" "web_bucket" {
  bucket        = local.s3_bucket_name
  force_destroy = true

  tags = var.resource_tags
}

resource "aws_s3_bucket_versioning" "web_bucket_versioning" {
  bucket = aws_s3_bucket.web_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

locals {
  web_content_files = {
    "index.html" = "/webcontent/index.html"
    "styles.css" = "/webcontent/styles.css"
    "programs.jpg" = "/webcontent/programs.jpg"
    "students.jpg" = "/webcontent/students.jpg"
  }
}

resource "aws_s3_object" "web_content" {
  for_each = local.web_content_files

  bucket = aws_s3_bucket.web_bucket.bucket
  key    = each.value
  source = "./${each.value}"

  tags = var.resource_tags
}

