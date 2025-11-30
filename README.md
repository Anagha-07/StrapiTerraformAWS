# Strapi Headless CMS Deployment with Terraform on AWS

This project demonstrates deploying the **Strapi headless CMS** on **AWS** using **Terraform** and **Docker**. The infrastructure is fully automated, and Strapi runs as a container on an EC2 instance with persistent storage.

## Prerequisites

* Terraform >= 1.12
* AWS CLI configured with credentials
* SSH key pair for EC2
* Ubuntu 24.04 instance (EC2) to run Docker
* Git (for version control and pushing to GitHub)

## Project Overview

* **AWS Resources Created**:
  * EC2 Ubuntu instance
  * Security group allowing:
    * **SSH (22)** for remote access
    * **Strapi (1337)** for API and admin UI
* **Automation**:
  * User-data script installs Docker and launches the Strapi container
  * Optional: systemd service to ensure the container persists across reboots
* **Outputs**:
  * Public Strapi URL for admin panel and API

## Architecture Diagram

```
+------------------+         +------------------+
|  AWS EC2         |         |  Security Group  |
|  Ubuntu + Docker | <--->   |  Ports 22 & 1337 |
+------------------+         +------------------+
        |
        v
  Strapi CMS running in Docker
```

## Project Structure

```
strapi-terraform-deployment/
│
├── terraform/
│   ├── main.tf         # AWS resources
│   ├── variables.tf    # configurable parameters
│   ├── outputs.tf      # outputs Strapi URL
│   └── userdata.sh     # installs Docker and runs Strapi
└── README.md
```

## Challenges Faced

- Initially, the Strapi container did not start automatically on EC2 instance reboot or Terraform updates.
- Learned that user-data scripts only run on initial launch, so implemented systemd service to run Strapi container continuously.
- Had to configure correct environment variables (`APP_KEYS`, `ADMIN_JWT_SECRET`, etc.) for Strapi Docker image to run properly.
- Dealt with connection refused errors caused by networking issues and ensured the security group and firewall rules were correct.
- Overcame difficulties adding the systemd service entirely from Terraform by scripting it in user-data.
- Git issues:

  * `.terraform` folder contains large binaries (>700 MB) and must be excluded from Git history.
  * Learned to use `.gitignore` and `git filter-repo` to remove already committed files.
  * Switched from HTTPS to SSH for GitHub pushes since password authentication is no longer supported.

## How to Use

1. Clone the repository:

```bash
git clone https://github.com/<your-username>/strapi-terraform-deployment.git
cd strapi-terraform-deployment/terraform
```

2. Configure your AWS credentials:

```bash
aws configure
```

3. Initialize Terraform:

```bash
terraform init
```

4. Review the plan:

```bash
terraform plan
```

5. Apply the Terraform configuration:

```bash
terraform apply
```

Type **yes** when prompted.

6. After deployment, Terraform will output the public URL:

```
strapi_url = "http://<EC2_PUBLIC_IP>:1337"
```

7. Open the URL in your browser and register an admin account:

```
http://<EC2_PUBLIC_IP>:1337/admin/auth/register-admin
```
