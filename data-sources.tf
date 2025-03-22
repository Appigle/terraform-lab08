# DATA
data "aws_ssm_parameter" "amzn2_linux" {
  name = local.amzn2_linux_ami_name
}

# List of supported availability zones in your region
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_iam_role" "existing_role" {
  name = "LabRole"
}

# data "aws_iam_role_policy" "existing_aws_iam_role_policy" {
#    name = "AmazonS3FullAccess"
# }