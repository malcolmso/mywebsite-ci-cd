---
layout: post
title: "How to Join Two Proxmox Servers into a Cluster the manual way"
date: 2025-07-05
categories: AWS
---
Proxmox VE makes it easy to manage multiple servers by clustering them together. This guide will show you how to set up a two-node Proxmox cluster step by step.

Prerequisites:

    Two or more Proxmox VE servers with static IP address
    Root privileges

 
![CloudFront Invalidation Flowchart](/assets/images/How-to-Join-Two-Proxmox-Servers-into-a-Cluster-the-manual-way/1.png)  
Click on Datacenter > Cluster > Create Cluster > Give it a name, then click Create

![CloudFront Invalidation Flowchart](/assets/images/How-to-Join-Two-Proxmox-Servers-into-a-Cluster-the-manual-way/2.png)  
It will start to Create the Cluster

![CloudFront Invalidation Flowchart](/assets/images/How-to-Join-Two-Proxmox-Servers-into-a-Cluster-the-manual-way/3.png)  
Click Join Information  

![CloudFront Invalidation Flowchart](/assets/images/How-to-Join-Two-Proxmox-Servers-into-a-Cluster-the-manual-way/4.png)  
Copy the details  

![CloudFront Invalidation Flowchart](/assets/images/How-to-Join-Two-Proxmox-Servers-into-a-Cluster-the-manual-way/5.png)  
On the Second server, click Datacenter> Cluster> Join Cluster, enter the information, then click Join.  

![CloudFront Invalidation Flowchart](/assets/images/How-to-Join-Two-Proxmox-Servers-into-a-Cluster-the-manual-way/6.png)  
The Servers are now in a Cluster, now you can perform HA actions.