provider "aws" {
  region = "ap-south-1"
  profile = "leela"
}


resource "aws_s3_bucket" "s3_bucket" {
  bucket = "leela-test-bucket-123"
}
