#create s3 bucket
resource "aws_s3_bucket" "websitebucket" {
  bucket = var.bucketname
}

resource "aws_s3_bucket_ownership_controls" "websitebucket" {
  bucket = aws_s3_bucket.websitebucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "websitebucket" {
  bucket = aws_s3_bucket.websitebucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "websitebucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.websitebucket,
    aws_s3_bucket_public_access_block.websitebucket,
  ]

  bucket = aws_s3_bucket.websitebucket.id
  acl    = "public-read"
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.websitebucket.id
  key          = "index.html"
  source       = "../html/index.html"
  acl          = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.websitebucket.id
  key          = "error.html"
  source       = "../html/error.html"
  acl          = "public-read"
  content_type = "text/html"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.websitebucket.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
  depends_on = [aws_s3_bucket_acl.websitebucket]
}
