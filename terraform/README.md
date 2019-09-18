# Terraform script for simple vpc
## Inputs
### VPC CIDR
Default value: 10.0.0.0/16
- It can be overwritten with `terraform apply -var="VpcCIDR=ami-10.0.0.0/16" -var="PublicSubnetCIDR=10.0.0.0/28"`. 
[visit for more on terraform](https://www.terraform.io/docs/configuration/variables.html)
### Private Subnet CIDR
Default value: 10.0.0.0/28
### Public Subnet CIDR
Default value: 10.0.0.17/28

## Executing
- `terraform plan`
- `terraform validate`
- `terraform apply -var="VpcCIDR=ami-10.0.0.0/16" -var="PublicSubnetCIDR=10.0.0.0/28"`

## Outputs
- VPC ID
- Public Subnet ID
- Private Subnet ID