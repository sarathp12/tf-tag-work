ebs_volume_size = 8

instance_count = 2

ami_name = "ami-0817d428a6fb68645"

volume_size = 8

key_name = "mongo-latest-test"

std_tags =  {
    cost_center = "v156784"
    env = "dev"
}

/*
pipeline_tags = {
    domain = "electrode"
    tier_value = "tiera"
}
*/

#terraform apply -var 'pipeline_tags={domain="electrode", tier_value="tiera"}'
