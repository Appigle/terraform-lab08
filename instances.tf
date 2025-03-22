# DATA
data "aws_ssm_parameter" "amzn2_linux" {
  name = local.amzn2_linux_ami_name
}

# INSTANCES
resource "aws_instance" "nginx1" {
  ami           = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type = "t3.micro"

  iam_instance_profile   = aws_iam_instance_profile.nginx_profile.name
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.public_security_group.id]

  tags = var.resource_tags


  user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/webcontent/index.html /home/ec2-user/index.html
aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/webcontent/styles.css /home/ec2-user/styles.css
aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/webcontent/campus.jpg /home/ec2-user/campus.jpg
aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/webcontent/programs.jpg /home/ec2-user/programs.jpg
aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/webcontent/students.jpg /home/ec2-user/students.jpg
sudo rm /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/styles.css /usr/share/nginx/html/styles.css
sudo cp /home/ec2-user/campus.jpg /usr/share/nginx/html/campus.jpg
sudo cp /home/ec2-user/programs.jpg /usr/share/nginx/html/programs.jpg
sudo cp /home/ec2-user/students.jpg /usr/share/nginx/html/students.jpg
EOF
}

resource "aws_instance" "nginx2" {
  ami           = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type = "t3.micro"

  iam_instance_profile   = aws_iam_instance_profile.nginx_profile.name
  subnet_id              = aws_subnet.public_subnet2.id
  vpc_security_group_ids = [aws_security_group.public_security_group.id]

  tags = var.resource_tags

  user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/webcontent/index.html /home/ec2-user/index.html
aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/webcontent/styles.css /home/ec2-user/styles.css
aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/webcontent/campus.jpg /home/ec2-user/campus.jpg
aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/webcontent/programs.jpg /home/ec2-user/programs.jpg
aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/webcontent/students.jpg /home/ec2-user/students.jpg
sudo rm /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/styles.css /usr/share/nginx/html/styles.css
sudo cp /home/ec2-user/campus.jpg /usr/share/nginx/html/campus.jpg
sudo cp /home/ec2-user/programs.jpg /usr/share/nginx/html/programs.jpg
sudo cp /home/ec2-user/students.jpg /usr/share/nginx/html/students.jpg
EOF
}

resource "aws_iam_instance_profile" "nginx_profile" {
  name = "nginx_profile"
  role = "LabRole"
}