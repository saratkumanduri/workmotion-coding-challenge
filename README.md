# workmotion-challenge

## Assumption
- I'm creating a VPC endpoint and because of that we need a VPC to exist or you can create using the code provided, the steps are below.
- Private API access, please add your cidrs in application/vars/test.tfvars `vpc_endpoint_access_cidrs`
- No data store in Lambda, its runtime
- I considered a test environment, which is why all backend configurations and vars configurations are named with test like "test.tfvars". If you want to use the same infrastructure in a different environment, just create files with "{environment}.tfvars" in the backend and vars directory.


## code structure
infra/terraform/{cloud_provider}

e.g.
infra/terraform/aws

## Modular construction
All aws resources are created in the module for reusability

It currently has two modules
- vpc
- show-vpc

Separate configuration/state based on the criticality of the cloud resources
3 folders/state
- initialization
- core
- application

The initialization folder is used to initialize s3 Bucket and Dynamodb for terraform state management.


The core has(will have) all the networks (VPC, subnet, peering, etc.), RDS, etc.


The application folder is used for the deployment of Demorestapi Lambda and Gateway
`

# How to run
## 2 Scenario
#### First Scenario :
If you need terraform's remote state management, first run the initialization folder that creates s3 + dynamoDB.

      Step 1: Go to folder initialization
      Step 2: terraform init
      Step 3: terraform plan
      Step 4: terraform apply this step will create s3 + DynamoDB

- if you need to create vpc go to core directory and follow below steps.

      Step 5: terraform init -backend-config=backend/test.tfvars
      Step 6: change variables values as per your requirement in core/vars/test.tfvars
      Step 7: terraform plan -var-file=vars/test.tfvars
      Step 8: terraform apply -var-file=vars/test.tfvars this will create vpc
      Step 9: Go to folder application
      Step 10: change variables values as per your requirement in application/vars/test.tfvars
      Step 11: terraform init -backend-config=backend/test.tfvars
      Step 12: terraform plan -var-file=vars/test.tfvars
      Step 13: terraform apply -var-file=vars/test.tfvars this step will deploy lambda and gateway and returns two important pieces of information: 1. restapi_id is needed to build the API url, See the Lambda section below for more details 2. lambda_execution_iam_role_arn this is required for GitHub Action.
      Note: you can skip plan and directly apply.


- if you have existing vpc and you don't need one more vpc go directly go to application directory and run

      Step 5: change variables values as per your requirement in application/vars/test.tfvars specially variable vpc_tags so that the module(show-vpc) can find the exsisting vpc.
      Step 6: terraform init -backend-config=backend/test.tfvars
      Step 7: terraform plan -var-file=vars/test.tfvars
      Step 8: terraform apply -var-file=vars/test.tfvars this step will deploy lambda and gateway and returns two important pieces of information: 1. restapi_id is needed to build the API url, See the Lambda section below for more details 2. lambda_execution_iam_role_arn this is required for GitHub Action
      Note: you can skip plan and directly apply.


#### Second Scenario:
If you do not need terraform remote state management.

- if you need to create vpc go to core directory and run

      Step 1: terraform init -backend-config=backend/test.tfvars
      Step 2: change variables values as per your requirement in core/vars/test.tfvars
      Step 3: terraform plan -var-file=vars/test.tfvars
      Step 4: terraform apply -var-file=vars/test.tfvars this will create vpc
      Step 5: Go to folder application
      Step 6: change variables values as per your requirement in application/vars/test.tfvars
      Step 7: terraform init -backend-config=backend/test.tfvars
      Step 8: terraform plan -var-file=vars/test.tfvars
      Step 9: terraform apply -var-file=vars/test.tfvars this step will deploy lambda and gateway and returns two important pieces of information: 1. restapi_id is needed to build the API url, See the Lambda section below for more details 2. lambda_execution_iam_role_arn this is required for GitHub Action
      Note: you can skip plan and directly apply.


- if you have existing vpc and you don't need one more vpc go directly go to application directory and run

      Step 1: change variables values as per your requirement in application/vars/test.tfvars specially variable vpc_tags so that the module(show-vpc) can find the exsisting vpc.
      Step 2: terraform init -backend-config=backend/test.tfvars
      Step 3: terraform plan -var-file=vars/test.tfvars
      Step 4: terraform apply -var-file=vars/test.tfvars this step will deploy lambda and gateway and returns two important pieces of information: 1. restapi_id is needed to build the API url, See the Lambda section below for more details 2. lambda_execution_iam_role_arn this is required for GitHub Action
      Note: you can skip plan and directly apply.


# DemoRestApi Lambda function

### Technical Requirement
- python 3.8

###### The REST API is provided by the AWS API Gateway using the vpc endpoint and is private
Supported HTTP Method
- GET
- POST

How to test:

Build the rest api end point`like this,
Get the restapi_id from terraform output
https://{restapi_id}.execute-api.{your_aws_region}.amazonaws.com/test/demorestapi


Use curl or another tool to validate the results

# Github Actions
- Contains a simple Github action workflow that deployes the lambda zip file when there is push in the repository

#### To Use
To successfully run the workflow, need an AWS user
- Please create 4 secrets in the repository.
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_REGION
- AWS_LAMBDA_EXECUTION_ROLE (you can get this info from terraform output)

---------Testing---------
