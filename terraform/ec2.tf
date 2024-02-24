
# Creating the EC2 instance

resource "aws_instance" "webserver" {

    ami = "ami-008fe2fc65df48dac"
    instance_type = "t2.micro"
    key_name = aws_key_pair.deployer.key_name
    vpc_security_group_ids = [aws_security_group.SG.id]
    iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
    connection {
        type = "ssh"
        host = self.public_ip
        user = "ubuntu"
        private_key = var.private_key
        timeout = "4m"


    }

    tags = {
        "name" = "Vmdeploy"
    }


}


resource "aws_key_pair" "deployer"{
    key_name = var.key_name
    public_key = var.public_key

}


# Creating the Security group

resource "aws_security_group" "SG"{
    egress = [
        {
            cidr_blocks = ["0.0.0.0/0"]
            description = "Allowing outbound traffic"
            from_port = 0
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            protocol = "-1"
            security_groups = []
            self = false
            to_port = 0

        }
    ]

    

    ingress = [
        {

            cidr_blocks = ["0.0.0.0/0"]
            description = "Allowing SSH inbound traffic"
            from_port = 22
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            protocol = "tcp"
            security_groups = []
            self = false
            to_port = 22

            

        },
    
        {
              cidr_blocks = ["0.0.0.0/0"]
            description = "Allowing HTTP inbound traffic"
            from_port = 80
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            protocol = "tcp"
            security_groups = []
            self = false
            to_port = 80
        }
    ]
}

resource "aws_iam_instance_profile" "ec2-profile"{
    name = "ec2-role"
    role = "EC2-ECR-ROLE"

  
}

output "instance"{
    value = aws_instance.webserver.public_ip
    sensitive = true
  
}