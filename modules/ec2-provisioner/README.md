## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 1.3.6 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.2.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.cloud-init-wait](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.ec2_provisioner](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region where the resources are created. | `string` | `"eu-west-2"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | S3 bucket name to get website from | `string` | n/a | yes |
| <a name="input_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#input\_cloudwatch\_log\_group\_name) | Cloudwatch log group name to send docker container logs to | `string` | n/a | yes |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | Specifies Docker image to deploy | `string` | `"nginx:alpine"` | no |
| <a name="input_host"></a> [host](#input\_host) | EC2 instance IP address to connect to | `string` | n/a | yes |
| <a name="input_private_key"></a> [private\_key](#input\_private\_key) | SSH private key which used to connect to EC2 instance | `string` | n/a | yes |
| <a name="input_proxy_host"></a> [proxy\_host](#input\_proxy\_host) | The proxy host IP address | `string` | `null` | no |
| <a name="input_proxy_private_key"></a> [proxy\_private\_key](#input\_proxy\_private\_key) | SSH private key which used to connect to the proxy host | `string` | `null` | no |
| <a name="input_proxy_user"></a> [proxy\_user](#input\_proxy\_user) | User to authenticate against the proxy host | `string` | `"ubuntu"` | no |
| <a name="input_user"></a> [user](#input\_user) | User to authenticate against the host | `string` | `"ubuntu"` | no |

## Outputs

No outputs.
