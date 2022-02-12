resource "aws_s3_bucket" "codepipeline_artifacts" {
  bucket = "tf-artifacts-timiz"
  #acl    = "private"
}
