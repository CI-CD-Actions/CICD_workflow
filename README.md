# CI/CD Pipeline with Terraform, AWS, and GitHub Actions

This project automates the provisioning of AWS infrastructure using **Terraform**, **GitHub Actions**, and **Ansible**. The CI/CD pipeline ensures seamless infrastructure management, including state file storage in **AWS S3**, state locking with **DynamoDB**, and automatic configuration of EC2 instances through Ansible.

## Table of Contents
- [Introduction](#introduction)
- [Pre-requisites](#pre-requisites)
- [Setup](#setup)
- [CI/CD Pipeline Workflow](#cicd-pipeline-workflow)
- [Security Considerations](#security-considerations)
- [License](#license)

## Introduction

This project leverages **Terraform** to manage AWS infrastructure and **GitHub Actions** for CI/CD automation. The solution automates the entire process of provisioning infrastructure, generating dynamic inventories, and configuring EC2 instances using **Ansible**.

Key Features:
- **Terraform** for provisioning AWS resources such as EC2 instances, security groups, and VPCs.
- **GitHub Actions** for automating Terraform and Ansible workflows.
- **S3 and DynamoDB** for secure Terraform state file management and locking.
- **Ansible** for EC2 instance configuration based on dynamic inventories generated through Terraform outputs.

## Pre-requisites

To use this project, you'll need:
- **Terraform** installed (version 1.0 or higher)
- **AWS CLI** installed and configured with access to your AWS account
- **GitHub account** with access to GitHub Actions
- **Ansible** installed for provisioning EC2 instances (optional for further configuration)

## Setup

### 1. Set up AWS S3 and DynamoDB for Terraform State Management

1. **Create an S3 bucket** for storing Terraform state files:
   - Navigate to the AWS S3 console and create a new bucket (e.g., `cicdbucket2903`).

2. **Create a DynamoDB table** for state locking:
   - In the DynamoDB console, create a new table named `terraform-lock`.
   - Set the **Partition key** to `LockID` (String).
   - Leave other settings as default.

### 2. Configure AWS Credentials

Store your AWS credentials (Access Key ID and Secret Access Key) in **GitHub Secrets**:
- Navigate to your GitHub repository.
- Go to **Settings** > **Secrets** and add the following secrets:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`

### 3. Configure the CI/CD Pipeline (GitHub Actions)

The GitHub Actions workflow automates the entire process. It includes three main jobs:
- **CI**: Initializes and applies Terraform.
- **Dynamic Phase**: Generates the Ansible inventory and uploads it as an artifact.
- **CD**: Runs the Ansible playbook on EC2 instances using the generated inventory.

The `.github/workflows/ci_cd_pipeline.yml` file contains the complete CI/CD pipeline.

### 4. Define Your Terraform Configuration

The Terraform files in the `terraformfiles` directory define the infrastructure to be provisioned, including:
- **AWS EC2 instances** using a custom AMI.
- **Security groups**, **VPCs**, and **subnets** for network configuration.

The **backend configuration** stores Terraform's state file in an S3 bucket and uses DynamoDB for state locking.

### 5. Ansible Configuration

The `ansiblefiles` directory contains the playbooks for configuring the provisioned EC2 instances. The playbooks are executed automatically after the Terraform state is updated.

## CI/CD Pipeline Workflow

### Step 1: Terraform Initialization and Apply
- The CI job runs the `terraform init`, `terraform fmt`, `terraform validate`, and `terraform apply` commands to initialize the infrastructure, apply changes, and provision AWS resources.

### Step 2: Upload Terraform Outputs
- After Terraform applies the changes, the `terraform output -json` command generates the infrastructure output and uploads it to an S3 bucket for later use.

### Step 3: Dynamic Phase
- The dynamic-phase job downloads the Terraform output from the S3 bucket, uses a Python script (`generate_inventory.py`) to create an Ansible inventory file, and uploads it as an artifact for the CD job.

### Step 4: Ansible Configuration
- The CD job downloads the generated inventory and runs the Ansible playbook to configure the provisioned EC2 instances.

## Security Considerations

- **AWS Access Keys**: Make sure your AWS credentials are securely stored in GitHub Secrets to prevent exposure.
- **Terraform State**: Store Terraform state files in a secure S3 bucket with proper access controls. Use DynamoDB for state locking to prevent concurrent modifications.
- **Ansible Inventory**: Ensure the generated inventory file is only accessible to authorized personnel and is securely stored.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.

---

Feel free to modify or extend this README based on your project's specific details. This version covers setup, functionality, and security aspects to give your users a clear understanding of how the CI/CD pipeline operates.
