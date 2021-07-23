provider "aws" {
  region = "ap-south-1"
  profile = "ramya"
}


resource "aws_s3_bucket" "s3_bucket" {
  bucket = "leela-test-bucket-123"
}
