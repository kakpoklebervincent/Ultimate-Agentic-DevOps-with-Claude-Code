# Remote state backend (S3)
#
# On the FIRST run, leave this block commented out so Terraform uses local
# state. This lets you create the initial resources — including the S3 bucket
# that will later hold remote state.
#
#   1. terraform init          # local state, no backend
#   2. terraform apply         # create resources (and your state bucket)
#
# Once a dedicated state bucket exists (create it separately — do NOT reuse the
# site content bucket), fill in the values below, uncomment the block, and
# migrate your existing local state into S3:
#
#   3. terraform init -migrate-state
#
# terraform {
#   backend "s3" {
#     bucket       = "REPLACE_WITH_STATE_BUCKET_NAME"
#     key          = "portfolio-site/terraform.tfstate"
#     region       = "ap-south-1"
#     encrypt      = true
#     use_lockfile = true
#   }
# }
