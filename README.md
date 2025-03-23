# Terraform Advanced Features in Action

In this assignment, I applied Terraform's advanced features such as loops, functions,
expressions, and dynamic infrastructure management to a real-world app scenario.

## Project Structure

```
.
├── network.tf
├── instances.tf
├── load-balancer.tf
├── s3.tf
├── local-variables.tf
├── inputs.tf
├── outputs.tf
├── provider.tf
└── webcontent/
```

## How to use

Use Terraform command

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

## Features

### 1. Advanced Loop Constructs

#### Count-based Resource Creation

```hcl
resource "aws_instance" "nginx" {
  count = 2  # Creates 2 identical instances
  # ... instance configuration
}
```

#### For-each Resource Creation

```hcl
resource "aws_security_group" "groups" {
  for_each = local.security_groups
  # ... security group configuration
}
```

### 2. Built-in Functions

#### String Functions

```hcl
s3_bucket_name = lower("conestoga-prog8830-${random_integer.s3_bucket_suffix.result}")
```

#### Collection Functions

```hcl
subnet_count = length(data.aws_availability_zones.available.names)
```

### 3. Dynamic Resource Creation

#### Dynamic Subnet Configuration

```hcl
resource "aws_subnet" "public" {
  for_each = local.public_subnet_configs
  # ... subnet configuration
}
```

#### Dynamic Security Group Rules

```hcl
resource "aws_security_group" "groups" {
  for_each = local.security_groups
  dynamic "ingress" {
    for_each = each.value.ingress_rules
    content {
      # ... rule configuration
    }
  }
}
```

## Purpose and Functionality of Each Task

### Task 1: Using Terraform Loops

This task demonstrates the practical application of different loop constructs in Terraform:

1. Count-based Resource Creation

   - Purpose: Create multiple identical resources efficiently
   - Functionality: Creates two identical EC2 instances running Nginx
   - Implementation: Uses `count` to create multiple instances with the same configuration

   ```hcl
   resource "aws_instance" "nginx" {
     count = 2
     # ...
   }
   ```

2. For-each Resource Creation
   - Purpose: Create resources with unique configurations
   - Functionality: Creates different security groups with specific rules
   - Implementation: Uses `for_each` to create security groups based on a map of configurations
   ```hcl
   resource "aws_security_group" "groups" {
     for_each = local.security_groups
     # ...
   }
   ```

### Task 2: Applying Functions in Terraform

This task showcases the use of various built-in functions to enhance infrastructure management:

1. String Functions

   - Purpose: Maintain consistent naming conventions
   - Functionality: Creates standardized resource names
   - Implementation: Uses `lower()` for consistent case in S3 bucket names

2. Collection Functions

   - Purpose: Manage multiple resources efficiently
   - Functionality: Counts and manages availability zones
   - Implementation: Uses `length()` to determine subnet count

### Task 3: Enhancing Terraform Configurations

This task focuses on making configurations more modular and dynamic:

1. Dynamic Subnet Creation

   - Purpose: Adapt to available infrastructure
   - Functionality: Creates aws_security_group based on locals variable
   - Implementation: Uses dynamic expressions with `for_each`

2. Modular Design
   - Purpose: Improve maintainability and reusability
   - Functionality: Separates concerns into different files
   - Implementation: User Data Script: `user_data.sh`

### Count vs For-each

- `Count`: Best for identical resources

  ```hcl
  resource "aws_instance" "nginx" {
    count = 2
    # ...
  }
  ```

- `For-each`: Better for unique resources
  ```hcl
  resource "aws_security_group" "groups" {
    for_each = local.security_groups
    # ...
  }
  ```


These help us create infrastructure that maintainable and scalable. Making our code easier to understand, modify, and extend as our needs evolve.
