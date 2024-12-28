#create s3 bucket
resource "aws_s3_bucket" "websitebucket" {
  bucket = var.bucketname
}