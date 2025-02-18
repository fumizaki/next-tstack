# Terraform for AWS

This repository contains Terraform code to create AWS resources.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)


## Usage

### Create AWS Resources

```bash

cd iac/aws/terraform/environments/dev

# Initialize the code
terraform init

# Validate the code
terraform validate

# Plan the resources
terraform plan

# Create the resources
terraform apply -auto-approve

# login to AWS
aws ecr get-login-password --region <AWS_REGION> | docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.<AWS_REGION>.amazonaws.com

# Build and push the docker image
# cd to the root of the project
docker build -t next-tstack-dev -f docker/webview/Dockerfile .
docker tag next-tstack-dev:latest <AWS_ACCOUNT_ID>.dkr.ecr.<AWS_REGION>.amazonaws.com/next-tstack-dev:latest
docker push <AWS_ACCOUNT_ID>.dkr.ecr.<AWS_REGION>.amazonaws.com/next-tstack-dev:latest

# Update the ECS service
aws ecs update-service --cluster next-tstack-dev-webview-cluster --service next-tstack-dev-webview --force-new-deployment
```


### Destroy AWS Resources

```bash
cd iac/aws/terraform/environments/dev

# Destroy the resources
terraform destroy -auto-approve
```
