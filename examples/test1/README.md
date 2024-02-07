## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 1.3.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.34.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.6.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.34.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudwatch_dashboard"></a> [cloudwatch\_dashboard](#module\_cloudwatch\_dashboard) | ../../modules/cloudwatch-dashboard | n/a |
| <a name="module_ec2"></a> [ec2](#module\_ec2) | ../../modules/ec2 | n/a |
| <a name="module_key_pair"></a> [key\_pair](#module\_key\_pair) | terraform-aws-modules/key-pair/aws | >= 2.0.2 |
| <a name="module_provisioner"></a> [provisioner](#module\_provisioner) | ../../modules/ec2-provisioner | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | >= 3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_object.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [random_id.main](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region where the resources are created. | `string` | `"eu-west-2"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | S3 bucket name to be created. | `string` | `null` | no |
| <a name="input_enable_nat_gw"></a> [enable\_nat\_gw](#input\_enable\_nat\_gw) | Specifies whether to create Nat gateway or not | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | The prefix or project name which will be included in the name of most resources. | `string` | n/a | yes |
| <a name="input_number_of_subnets"></a> [number\_of\_subnets](#input\_number\_of\_subnets) | Specifies the number of subnets to be created | `number` | `2` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Specifies the subnet id to place EC2 instance to | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The address space used by VPC. | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Specifies the id of an existing VPC | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ec2_public_ip"></a> [ec2\_public\_ip](#output\_ec2\_public\_ip) | Private IP address of the EC2 instance |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | S3 bucket name |
