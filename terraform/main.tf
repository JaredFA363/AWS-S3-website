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