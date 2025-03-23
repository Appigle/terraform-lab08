# DATA
data "aws_ssm_parameter" "amzn2_linux" {
  name = local.amzn2_linux_ami_name
}

locals {
  # Use min function to ensure we don't exceed available subnets
  instance_count = min(2, length(data.aws_availability_zones.available.names))
  
  # Generate instance names using string functions
  instance_names = [
    for i in range(local.instance_count) : upper("nginx-${i + 1}")
  ]
}

# INSTANCES
resource "aws_instance" "nginx" {
  count = local.instance_count

  ami           = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type = "t3.micro"

  iam_instance_profile   = aws_iam_instance_profile.nginx_profile.name
  subnet_id              = aws_subnet.public["subnet${count.index + 1}"].id
  vpc_security_group_ids = [aws_security_group.groups["public"].id]

  tags = merge(
    var.resource_tags,
    {
      Name = local.instance_names[count.index]
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