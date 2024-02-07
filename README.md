# AWS terraform test

## Prerequisites

- Terraform installed
- AWS CLI installed and configured
- Any favourite editor

**Tested with**
- terraform v1.3.6
- aws cli aws-cli/2.12.0 Python/3.11.3 Linux/6.6.6-76060606-generic exe/x86_64.pop.22 prompt/off
- Bash shell, v5.1.16
- Ubuntu 22.04 LTS

## Project layout

This describes about the project directory layout

```
.
|-- README.md
|-- examples
|   |-- test1
|   `-- test2
`-- modules
    |-- cloudwatch-dashboard
    |-- ec2
    |-- ec2-bastion
    `-- ec2-provisioner

8 directories, 1 file
```
- **README.md** describes the project, usage, etc
- **examples/** contains tasks come as Terraform modules
- **modules/** contains Terraform modules that can be reused. These includes: `cloudwatch-dashbard`, `ec2`, `ec2-bastion`, `ec2-provisioner`

Please note: this project does not include a root module. Each scenario or task will be placed inside `examples/` directory.

## Usage

There are terraform modules for tasks
- `examples/test1`
- `examples/test2`

Change to each task, and perform the workflow mentioned in `Infrastructure management workflow` section.

For example, to work with `test1`, execute the following commands:
```
# 1. Change module directory
cd examples/test1

# Assume the project name `phoenix`
# 2. Create variable definitions file
cat > terraform.tfvars <<EOF
name = "phoenix"
EOF

# 3. terraform workflow
terraform init
terraform plan
terraform apply -auto-approve

# tear down
terraform destroy
```

## Infrastructure management workflow

### Prepare AWS environment

Setup an AWS profile, see [Configure the AWS CLI document](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) for how to configure settings AWS CLI.

The in the terminal, export the AWS profile name, assumes in this example, the AWS profile named `aws`, with the following command:  

```
export AWS_PROFILE=aws
```

### Initialize terraform

Initialize the project with Terraform initialization with the following command:

```
terraform init
```

### Plan for changes

Reviewing resources creation plan by executing:

```
terraform plan
```

### Apply Terraform to create resources

After reviewing the output from `terraform plan`, confirm the plan by typing `yes` and press Enter to provisioning the infrastructure
```
terraform apply
```

## Clean up

### Tear down the environment

Once completed testing, just tear down the environment with:

```
terraform destroy
```

## Website deployment workflow

This writes steps need to configure a workflow with automated process to deploy changes to the EC2 private instance.

### Setup GiHub Actions secrets

There are secrets required to be configured to allow workflow runs properly.

The secrets are:
 * **HOST** : the private instance IP address
 * **USERNAME** : The private instance username   
 * **SSH_PRIVATE_KEY** : SSH private key of the private instance
 * **PROXY_HOST** : The bastion instance
 * **PROXY_USERNAME** : The bastion instance username
 * **PROXY_SSH_PRIVATE_KEY** : SSH private key of the bastion instance
 * **AWS_ACCESS_KEY_ID** : AWS access key
 * **AWS_SECRET_ACCESS_KEY** : AWS secret key
 * **AWS_REGION** : AWS region
 * **S3_BUCKET** : S3 bucket to deploy website to

where:
* **S3_BUCKET** is the output value of `s3_bucket_name` output in terraform state which can be referenced by the command `terraform output s3_bucket_name`
* **SSH_PRIVATE_KEY** and **PROXY_SSH_PRIVATE_KEY** can be found in AWS SSM Parameter Store with name `/ssh/key_pair/<stack name>/private_key_openssh`, for example, `/ssh/key_pair/skylake-f012302d/private_key_openssh`
* USERNAME - default is `ubuntu`

Create all required secrets in the repository. See the [Creating secrets for a repository](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-a-repository) for more information.

### Create a GitHub workflow

An example of deployment workflow that:
- Push changes to S3 bucket
- Deploy changes to the Docker container
is available at `.github/workflows/deploy.yaml`
