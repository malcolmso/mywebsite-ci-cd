---
layout: post
title: "Hosting a Static Website on AWS S3"
date: 2025-07-04
categories: AWS
---

Hosting a Static Website on AWS S3

Hosting a static website on AWS S3 is a cost-effective and scalable solution. This guide walks you through setting up your own static website using AWS S3.

Step 1: Clone my Git Repo

Start by downloading the required HTML files (index.html and error.html) from your repository:

git clone https://github.com/malcolmso/aws

Step 2: Create an S3 Bucket

    1. Log in to your AWS Management Console.
    2. Navigate to S3 and click Create Bucket.
    3. Provide a unique bucket name.
    4. Choose a region and configure other settings as needed.
    5. Click Create Bucket.

Step 3: Upload HTML Files

    1. Open your newly created S3 bucket.
    2. Click Upload and add the index.html and error.html files.
    3. Click Upload to confirm.

![CloudFront Invalidation Flowchart](/assets/images/Hosting-a-Static-Website-on-AWS-S3/1.png)      

Step 4: Enable Static Website Hosting

    1. Navigate to the Properties tab of your bucket.
    2. Scroll down to Static Website Hosting and click Edit.
    3. Select Enable and enter:

    Index Document: index.html
    Error Document: error.html

4. Click Save.

5. Note the Bucket Website Endpoint
example= http://bucket-name.s3-website-us-east-1.amazonaws.com/

Step 5: Update Bucket Permissions

    1. Go to the Permissions tab of your bucket.
    2. Click Edit under Bucket Policy.
    3. Copy your Bucket ARN (example = arn:aws:s3:::your-bucket-name).
    4. Use the AWS Policy Generator to create a policy:

    Policy Type: S3 Bucket Policy
    Effect: Allow
    Principal: * (public access)
    Actions: s3:GetObject
    ARN: arn:aws:s3:::your-bucket-name/*

Do not forget to put the * at the end !!

5. Click Add Statement and Generate Policy.

6. Copy the generated policy and paste it into the Bucket Policy Editor.

7. Click Save Changes.


Step 6: Test Your Website

Access your static website using the URL provided in the Bucket Website Endpoint.

Your AWS S3 static website is now live! 🎉

![CloudFront Invalidation Flowchart](/assets/images/Hosting-a-Static-Website-on-AWS-S3/2.png)   

![CloudFront Invalidation Flowchart](/assets/images/Hosting-a-Static-Website-on-AWS-S3/3.png)  