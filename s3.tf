

resource "random_string" "random" {
  count   = var.s3_count["${var.region}.${var.environment}"]
  length  = 4
  special = true
  lower   = true
  numeric = false
  upper   = false

}

resource "aws_s3_bucket" "fs_s3_bucket" {
  count  = var.s3_count["${var.region}.${var.environment}"]
  bucket = "fs-s3-bucket-${var.environment}-${random_string.random[count.index].result}"
  tags = {
    Name        = "fs-s3-bucket-${var.environment}"
    Environment = var.environment
  }
}


resource "aws_s3_bucket_website_configuration" "fs_s3_bucket_web_conf" {
  count  = var.s3_count["${var.region}.${var.environment}"]
  bucket = aws_s3_bucket.fs_s3_bucket[count.index].id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_versioning" "fs_s3_bucket_versioning" {
  count  = var.s3_count["${var.region}.${var.environment}"]
  bucket = aws_s3_bucket.fs_s3_bucket[count.index].id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_ownership_controls" "fs_s3_bucket_ownership" {
  count  = var.s3_count["${var.region}.${var.environment}"]
  bucket = aws_s3_bucket.fs_s3_bucket[count.index].id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "fs_s3_bucket_acl" {
  count = var.s3_count["${var.region}.${var.environment}"]
  depends_on = [aws_s3_bucket_ownership_controls.fs_s3_bucket_ownership,
    aws_s3_bucket_public_access_block.fs_s3_bucket_public-blk
  ]

  bucket = aws_s3_bucket.fs_s3_bucket[count.index].id
  acl    = "public-read"
}


resource "aws_s3_bucket_public_access_block" "fs_s3_bucket_public-blk" {
  count  = var.s3_count["${var.region}.${var.environment}"]
  bucket = aws_s3_bucket.fs_s3_bucket[count.index].id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}