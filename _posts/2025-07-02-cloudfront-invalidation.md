---
layout: post
title: "AWS CloudFront invalidation"
date: 2025-07-02
categories: AWS
---

Doing a Cloud Front invalidation tells AWS to remove cached copies of specified files from the CDN Edge locations so that Cloud Front fetches the latest versions from your origin (like S3) on the next request.

This is how you update files on the CDN before their normal TTL expires.

![CloudFront Invalidation Flowchart](/assets/images/AWS-CloudFront-invalidation/1.png)

![CloudFront Invalidation Flowchart](/assets/images/AWS-CloudFront-invalidation/2.png)

![CloudFront Invalidation Flowchart](/assets/images/AWS-CloudFront-invalidation/3.png)

![CloudFront Invalidation Flowchart](/assets/images/AWS-CloudFront-invalidation/4.png)

![CloudFront Invalidation Flowchart](/assets/images/AWS-CloudFront-invalidation/5.png)

To View the TTL, go to Behaviors

![CloudFront Invalidation Flowchart](/assets/images/AWS-CloudFront-invalidation/6.png)

![CloudFront Invalidation Flowchart](/assets/images/AWS-CloudFront-invalidation/7.png)

![CloudFront Invalidation Flowchart](/assets/images/AWS-CloudFront-invalidation/8.png)





