# Assessment Solution

[![Build Status](https://travis-ci.org/abybhamra/TechTestApp.svg?branch=master)](https://travis-ci.org/abybhamra/TechTestApp)

## Explanation and Deliverable

Here are the Key deliverables:

The public DNS entries for the EC2 instances:
nginx  - [ec2-3-235-19-91.compute-1.amazonaws.com]
apache - [ec2-54-152-145-137.compute-1.amazonaws.com]

The public URL to the web page via the ELB:
alb    - assignment-alb-870621497.us-east-1.elb.amazonaws.com

Some of the considerations that I have taken for the solution

* For the configuration of both the servers like partioning, mounting a volume at boot times and changing the document root
  I have created two ami's for both the servers and those ami's are being used to launch instances. Currently I have not included autoscaling
  but it will help in scaling activites as it provides lower boot time.
* Instead of using default vpc, I have created custom vpc with two public subnets(vpc.tf).
* Both Apache and Nginx servers can't be accessed dircetly. Traffic is allowed only through application load balancer.
  Security groups for both servers have load balancer's security group as a source.
* Cloudfront with s3 as Orgin is being used and access to the image endpoints is restricted through Origin Access Identity (check policy.json).
* Endpoint urls are being passed to the instances through user data (user_data_nginx.tpl, user_data_apache.tpl)

## Potential Improvements

1. Using WAF to harden the security at edge like using AWS managed rules to take care of OWASP top 10 vulnerabilities/attacks and whitelisting/blacklisting IP's etc.
2. Using ACM to generate ssl certificates and using https. ALB will perform the ssl offloading.
3. Creating launch templates and using autosacling.
4. It is a simple html. It can be improved a lot.

## Second Solution

The other approach for doing this challenge is:

1. Creating a custom vpc with two public and two private subnets.
2. Have the webservers launched in the private subnet and the load balancer in the public subnets.
3. Security grp of load balancer will have http port 80 allowed from anywhere and security groups of webservers will have lb security group as source of incoming traffic.
4. Create a role for ec2 with s3 read access. It can be attached to the instances at launch time or after they are launced.
5. Bucket policy will restrict the access to images with principal as ec2 role you just created.

