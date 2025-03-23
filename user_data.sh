#!/bin/bash
BUCKET_ID=$1
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
aws s3 cp s3://${BUCKET_ID}/webcontent/index.html /home/ec2-user/index.html
aws s3 cp s3://${BUCKET_ID}/webcontent/styles.css /home/ec2-user/styles.css
aws s3 cp s3://${BUCKET_ID}/webcontent/campus.jpg /home/ec2-user/campus.jpg
aws s3 cp s3://${BUCKET_ID}/webcontent/programs.jpg /home/ec2-user/programs.jpg
aws s3 cp s3://${BUCKET_ID}/webcontent/students.jpg /home/ec2-user/students.jpg
sudo rm /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/styles.css /usr/share/nginx/html/styles.css
sudo cp /home/ec2-user/campus.jpg /usr/share/nginx/html/campus.jpg
sudo cp /home/ec2-user/programs.jpg /usr/share/nginx/html/programs.jpg
sudo cp /home/ec2-user/students.jpg /usr/share/nginx/html/students.jpg 