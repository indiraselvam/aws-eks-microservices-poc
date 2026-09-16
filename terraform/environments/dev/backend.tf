terraform {
  backend "s3" {
    bucket         = "indiraselvam-tfstate-poc"
    key            = "eks-microservices-poc/dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
