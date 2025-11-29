# Strapi Headless CMS Deployment with Terraform on AWS

This project demonstrates deploying the Strapi headless CMS on AWS using Terraform and Docker.

## Project Description

- Created an AWS VPC, security group allowing port 22 (SSH) and 1337 (Strapi).
- Deployed an EC2 Ubuntu instance with Terraform.
- Set up a user-data script to install Docker, launch Strapi in a Docker container, managed by systemd service for persistence.
- Exposed port 1337 for Strapi admin and API access.

## Challenges Faced

- Initially, the Strapi container did not start automatically on EC2 instance reboot or Terraform updates.
- Learned that user-data scripts only run on initial launch, so implemented systemd service to run Strapi container continuously.
- Had to configure correct environment variables (`APP_KEYS`, `ADMIN_JWT_SECRET`, etc.) for Strapi Docker image to run properly.
- Dealt with connection refused errors caused by networking issues and ensured the security group and firewall rules were correct.
- Overcame difficulties adding the systemd service entirely from Terraform by scripting it in user-data.

## How to use

1. Clone the repo.
2. Configure your AWS credentials.
3. Run `terraform init`, `terraform plan`, and `terraform apply`.
4. After deployment, visit `http://<EC2_PUBLIC_IP>:1337/admin/auth/register-admin` to access the Strapi admin UI.
