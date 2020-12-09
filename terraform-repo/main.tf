provider "aws" {
    region = "us-east-1"
}

locals {
    availability_zone_subnets = {
        for s in data.aws_subnet.this : s.availability_zone => s.id...
    }

    ordered_subnets = flatten(values(local.availability_zone_subnets))

    std_value = "${var.std_tags}"
    additional_value = {
        exists = "${var.pipeline_tags}"
        not_exists = {}
    }

    tags = merge(
        "${local.std_value}",
        "${local.additional_value[var.pipeline_tags != null ? "exists" : "not_exists"]}"
    )
    
}

data "aws_vpc" "default" {}


data "aws_subnet_ids" "available" {
    vpc_id = data.aws_vpc.default.id

    filter {
        name = "tag:Name"
        values = ["Public Subnet"]
    }
}

data "aws_subnet" "this" {
    for_each = data.aws_subnet_ids.available.ids
    id = each.value
}

output "subnet_data" {
    value = data.aws_subnet_ids.available.ids
}

resource "aws_security_group" "mongo-sec" {
    name = "test-sg"
    vpc_id = data.aws_vpc.default.id
    description = "Test SG"
}

resource "aws_security_group_rule" "mongos_allow_all" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["10.0.0.0/16"]
    security_group_id = aws_security_group.mongo-sec.id
}

resource "aws_security_group_rule" "mongo_ssh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    security_group_id = aws_security_group.mongo-sec.id
}



resource "aws_instance" "instant" {
    instance_type = var.instance_type
    count = var.instance_count
    ami = var.ami_name
    root_block_device {
        volume_type = var.volume_type
        volume_size = var.volume_size
    }
    key_name = var.key_name
    vpc_security_group_ids = ["${aws_security_group.mongo-sec.id}"]
    subnet_id = element(local.ordered_subnets, count.index)
    #subnet_id = element(tolist(values(local.availability_zone_subnets)), count.index)
   #subnet_id = lookup(local.availability_zone_subnets, value[count.index])
    #subnet_id = values(local.availability_zone_subnets) [count.index]
    #subnet_id = element((tolist(data.aws_subnet_ids.available.ids)), count.index)
    #subnet_id = data.aws_subnet_ids.available.ids[count.index]

    tags = local.tags
    
}

