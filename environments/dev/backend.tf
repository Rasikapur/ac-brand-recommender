# Uncomment below for remote state with S3 and DynamoDB locking:
# terraform {
#   backend "s3" {
#     bucket         = "ac-brand-recommender-tfstate"
#     key            = "dev/terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     dynamodb_table = "terraform-locks"
#   }
# }
