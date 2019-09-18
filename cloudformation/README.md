# Cloudformation script for simple vpc
## Inputs
### VPC CIDR
Default value: 10.0.0.0/16
- It can be overwritten with `--parameters ParameterKey=VpcCIDR,ParameterValue=10.0.0.0/24` likewise through aws cli. 
[visit for more on AWS CLI](https://docs.aws.amazon.com/cli/latest/reference/cloudformation/create-stack.html)
- AWS cloudformation front-end will guide through if simplicity is expected.
### Private Subnet CIDR
Default value: 10.0.0.0/28
### Public Subnet CIDR
Default value: 10.0.0.17/28

## Executing
- `aws cloudformation create-stack --stack-name myteststack --template-body file://vpc.json --parameters ParameterKey=VpcCIDR,ParameterValue=10.0.0.0/24 ParameterKey=PublicSubnetCIDR,ParameterValue=10.0.0.0/28`
- Cloudformation web interface
## Outputs
- VPC ID
- Public Subnet ID
- Private Subnet ID