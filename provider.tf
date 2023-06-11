provider "aws" {
    region = "us-east-2"
    profile = "sejiro-temp"
}

terraform{
    backend "s3" {
        bucket = "tcit-terraform-state"
        encrypt = true
        key = "codepipeline/terraform.tfstate"
        dynamodb_table = "terraform-state-lock"
        region = "us-east-2"
        profile = "sejiro-temp"
    }
}

# resource "aws_s3_bucket" "terraform_state" {
#   bucket = "tcit-terraform-state"
# } 
# resource "aws_s3_bucket_versioning" "terraform_state" {
#   bucket = aws_s3_bucket.terraform_state.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }
# resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
#   bucket = aws_s3_bucket.terraform_state.id
#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm     = "AES256"
#     }
#   }
# }

# resource "aws_dynamodb_table" "terraform-state-lock" {
#   name = "terraform-state-lock"
#   hash_key = "LockID"
#   read_capacity = 20
#   write_capacity = 20
 
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }
