variable "ebs_volume_size" {
    description = "Size of the EBS Volume"
    type = number
}
variable "instance_type" {
    description = "Type of the Instance"
    type = string
    default = "t2.micro"
}

variable "instance_count" {
    description = "Number of Instances"
    type = number
    default = 1
}

variable "ami_name" {
    description = "Name of the AMI"
    type = string
    default = "ami-0817d428a6fb68645"
}

variable "volume_type" {
    description = "Volume Type"
    type = string
    default = "gp2"
}

variable "volume_size" {
    description = "Volume Size"
    type = number
    default = "8"
}

variable "key_name" {
    description = "Name of the SSH Key"
    type = string
}


variable "std_tags" {
    type = map
    description = "tag values"
}

variable "pipeline_tags" {
    type = map
    description = "Additional Tag values that need to be passed"
    default = null
}