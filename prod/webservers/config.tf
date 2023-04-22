terraform {
    backend "s3" {
        bucket = "abhiyan-assignment1"
        key = "prod/webserver/terraform.tfstate"
        region = "us-east-1"
    }
}