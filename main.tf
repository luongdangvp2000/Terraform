# resource "aws_instance" "app_server" {
#   ami           = "ami-0b94777c7d8bfe7e3"
#   instance_type = "t2.micro"

#   tags = {
#     Name = "ExampleAppServerInstance"
#   }
# }
# module "ec2_test" {
#   source = "./test/EC2"

# }

locals {
  tags = {
    project = var.project
  }
}

data "aws_region" "current" {}

# aws_resourcegroups_group: help to manage resources easier
resource "aws_resourcegroups_group" "resourcegroups_group" {
  name = "${var.project}-s3-backend"

  resource_query {
    query = <<-JSON
      {
        "ResourceTypeFilters": [
          "AWS::AllSupported"
        ],
        "TagFilters": [
          {
            "Key": "project",
            "Values": ["${var.project}"]
          }
        ]
      }
    JSON
  }
}


