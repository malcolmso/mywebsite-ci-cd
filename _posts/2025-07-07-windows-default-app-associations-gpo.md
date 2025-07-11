---
layout: post
title: "Windows Default app associations GPO"
date: 2025-07-07
categories: AWS
---
Windows Default app associations GPO

Grab the defaults app associations on a windows computer you want to be the standard.

Run the command below in CMD (as admin) to grab the AppAssociations.xml file

Dism /Online /Export-DefaultAppAssociations:”C:\AppAssociations.xml”

Place this file on a Server Share.

In the DC:
1. Open the Group Policy editor and go to the Computer Configuration\Administrative Templates\Windows Components\File Explorer.
2. Select Set a default associations configuration file.
3. Click policy setting, and then click Enabled.
4. Under Options:, type the location to your default associations configuration file.
5. Click OK to save the policy settings.

As test, i changed the default app associations to random apps, run gpupdate /force, log off/in and the Apps associations changed to what I selected

ref:
https://lnkd.in/gN3ZH_FN

Ref:
https://lnkd.in/giFhrsvn

![CloudFront Invalidation Flowchart](/assets/images/Windows-Default-app-associations-GPO/1.png)  

![CloudFront Invalidation Flowchart](/assets/images/Windows-Default-app-associations-GPO/2.png) 

![CloudFront Invalidation Flowchart](/assets/images/Windows-Default-app-associations-GPO/3.png) 