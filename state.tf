terraform{
    backend "s3" {
        bucket = "aws-tf-cicd-timiz"
        encrypt = true
        key = "terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "tf-state-lock"
    }
}

provider "aws" {
    region = "us-east-1"
}
