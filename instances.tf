# DATA
data "aws_ssm_parameter" "amzn2_linux" {
  name = local.amzn2_linux_ami_name
}

# INSTANCES
resource "aws_instance" "nginx" {
  count = 2  # Number of instances to create

  ami           = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type = "t3.micro"

  iam_instance_profile   = aws_iam_instance_profile.nginx_profile.name
  subnet_id              = aws_subnet.public["subnet${count.index + 1}"].id
  vpc_security_group_ids = [aws_security_group.groups["public"].id]

  tags = merge(
    var.resource_tags,
    {
      Name = "nginx-${count.index + 1}"
    }
  )

  user_data = templatefile("${path.module}/user_data.sh", {
    BUCKET_ID = aws_s3_bucket.web_bucket.id
  })
}

resource "aws_iam_instance_profile" "nginx_profile" {
  name = "nginx_profile"
  role = "LabRole"
}