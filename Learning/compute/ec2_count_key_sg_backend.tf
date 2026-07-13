# terraform {
#   backend "s3" {
#     bucket = "rahelbucket"
#     key    = "terraform.tfstate"
#     region = "us-east-1"
#     dynamodb_table = "terraform-state-lock"
#     encrypt = true
#   }
# }



resource "aws_instance" "practice" {
 ami           = "ami-0ec10929233384c7f"
 instance_type = "t3.micro"
 count         = 2
 key_name      = aws_key_pair.deployer.key_name
 vpc_security_group_ids = [aws_security_group.name.id]
 iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
 
#User data is used to bootstrap the instance, install software, and 
#configure the instance at launch time only once, on already running 
#instance it will not run, instnace has to be recreated.

  user_data = <<-EOF
#!/bin/bash
apt update
apt install nginx -y
systemctl enable nginx
systemctl start nginx
EOF

tags = {
  
Name = "practice_ec2-${count.index}"
}
}

resource "aws_key_pair" "deployer" {
 key_name   = "deployer_key"
  #public_key = file("~/.ssh/id_rsa.pub")
  #ssh-keygen -t rsa -b 4096
 public_key = file ("C:/Users/admin/.ssh/id_rsa.pub")
}


# Route tables are associated with subnets, IGW
# Security groups are attached to EC2 instances, firewall ports, inbound
#and outbound rules, CIDR blocks, protocols, ports

#Security group to allow ssh and web access from outside.
resource "aws_security_group" "name" {
  name = "ssh_web_access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow inbound web traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic" 
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]   
  }
}


  # #Create elastic IP and attach to one instance.
  # resource "aws_eip" "eip" {
  #   instance = aws_instance.practice[0].id
  #   domain   = "vpc"
  # }

  # resource "aws_eip_association" "eip_assoc" {
  #   instance_id   = aws_instance.practice[0].id
  #   allocation_id = aws_eip.eip.id
  # }

 # Create EBS volume and attach to one instance.
  # resource "aws_ebs_volume" "ebs_volume" {
  #   availability_zone = aws_instance.practice[0].availability_zone
  #   size              = 10
  #   type              = "gp2"
  # }

  # resource "aws_volume_attachment" "ebs_attachment" {
  #   device_name = "/dev/sdh"
  #   volume_id   = aws_ebs_volume.ebs_volume.id
  #   instance_id = aws_instance.practice[0].id
  # }

  #IAM role with trust policy and then attach policy to role.
  #Create instance profile and attach to EC2 instance.

  # An EC2 instance cannot assume an IAM Role directly. 
  # AWS requires the role to be wrapped inside an IAM Instance Profile. 
  # The EC2 instance attaches the Instance Profile and the profile 
  # contains the IAM Role."

  resource "aws_iam_role" "ec2_role" {
    name = "ec2-role-01"

    assume_role_policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Sid    = ""
          Principal = {
            Service = "ec2.amazonaws.com"
          }
        },
      ]
    })
  }

  resource "aws_iam_role_policy_attachment" "ssm_policy"  {
    role = aws_iam_role.ec2_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  resource "aws_iam_instance_profile" "ec2_instance_profile" {
    name = "ec2_instance_profile"
    role = aws_iam_role.ec2_role.name
  }
