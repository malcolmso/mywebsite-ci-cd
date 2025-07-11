---
layout: post
title: "Setting Up Terraform with Proxmox My Experience"
date: 2025-07-06
categories: AWS
---
When I first started using Terraform to manage Proxmox, I had to go through a few steps to get everything running smoothly. Here’s my setup process to help others who might be doing the same.
Step 1: Create an API Key in Proxmox

To allow Terraform to interact with Proxmox, I needed to create an API key.

    1. Go to Datacenter > Permissions > API Tokens in the Proxmox web UI.
    2. Create a new API token for your user.
    3 Assign the necessary permissions (typically PVEAdmin for full control or PVESysAdmin for system-level access).
    4. Copy the generated token and store it securely.

![CloudFront Invalidation Flowchart](/assets/images/Setting-Up-Terraform-with-Proxmox-My-Experience/1.png)  

![CloudFront Invalidation Flowchart](/assets/images/Setting-Up-Terraform-with-Proxmox-My-Experience/2.png)  

    Step 2: Save the API Key in credentials.auto.tfvars

Next, I configured my Terraform provider to use the API key.

In my credentials.auto.tfvars file, I included:

![CloudFront Invalidation Flowchart](/assets/images/Setting-Up-Terraform-with-Proxmox-My-Experience/3.png)  

![CloudFront Invalidation Flowchart](/assets/images/Setting-Up-Terraform-with-Proxmox-My-Experience/4.png)  

Do not share or expose your API keys to the world! This is just a home lab, Keys have been changed since posting this.

    Step 3: Use My Template Repository

To simplify the setup, I used a predefined template from my GitHub repository: https://github.com/malcolmso/Proxmox-Terraform

This template is used to clone a VM.
You can modify to what you would like to do.

    Clone the repository:

    git clone https://github.com/malcolmso/Proxmox-Terraform.git cd Proxmox-Terraform

2. Update the variables in credentials.auto.tfvars with your Proxmox API credentials and settings.

3. Initialize Terraform:

    terraform init

4. Plan the configuration:

terraform plan -var-file="credentials.auto.tfvars"

5. Apply the configuration with auto approve:

    terraform apply -var-file="credentials.auto.tfvars" -auto-approve

Final Thoughts

This setup helped me automate VM provisioning in Proxmox using Terraform.

By leveraging API keys and a well-structured Terraform configuration, I was able to streamline my workflow.

If you’re setting up Terraform with Proxmox, I highly recommend starting with my template and customizing it to fit your needs.