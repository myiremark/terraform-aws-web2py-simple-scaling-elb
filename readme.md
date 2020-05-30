# Goals

[Web2py](https://web2py.com) is a 'Free open source full-stack framework for rapid development of fast, scalable, secure and portable database-driven web-based applications. Written and programmable in Python (version 3 and 2.7).'

[Terraform](https://terraform.io) "uses Infrastructure as Code to provision and manage any cloud, infrastructure, or service".

[AWS](https://aws.amazon.com/) "provides on-demand cloud computing platforms and APIs to individuals, companies, and governments, on a metered pay-as-you-go basis".

This repository is an attempt to create a sample terraform aws web2py application template that can be performant and modified easily by people new to both terraform and web2py.

## Goals - Approachability

This repo is designed as an introduction to the concepts of Infrastructure as Code and python/web2py application deployment and scaling.  It is also designed to stay as much as possible within the free tier of AWS resources.

Note: This repo does not use HTTPS and leaves SSH open as well as direct internet access to multiple instances.  This is not best practice and is NOT safe for a production environment.

## Goals - Performance

- support 1K requests / second peak capacity
- mean response time < 400ms
- 99.99% success rate @ 1k requests / sec sustained load
- [99.99% uptime](uptime_calculation.md)

## RESULTS

burst capacity:
- <400 ms mean response time @ 3000 requests/sec
- <100 ms mean response time @ 1000 requests/sec
- <1% non 200 response rate

sustained capacity:
- >100 requests/sec
- <400 ms response time (~200)
- <1% non 200 response rate (0 @ 100 reqs/sec)

## General Approach

This repo uses terraform to:
- create a private cloud
- create a migration ec2 instance that modifies the schema of a shared Postgres database
- create a modifiable template application instance
- create an elastic load balancer which manages launching clones of that template instance based on defined alarms

## Pre-requirements

In order to test this repo, you need a functioning AWS account.

After signing up, you will need to follow [amazon's instructions about creating an access key and secret key](https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html)

## Code Layout

The repo has two folders containing docker files and source for:
- terraform management container and terraform state files
- load testing container

Inside the [cloud](cloud) directory there are separate folders/states for:
- common files (data resources and variables)
  - variables (allow you to modify the resulting cloud)
  - user_data (allow you to modify the resulting application instances)
- cloud resources
  - vpc
  - db
  - security groups
- ec2 instances
  - migration instance
  - template instance
- elb resources

## NOTE to webapp developers new to web2py

In order to create the database table structure, this project leverages web2py's automigrations.  This requires us to set up a separate VM which is stateful and should only be created/destroyed when changing the db schema, or else the migration files will be inconsistent and require manual intervention.

You could very well manually create the table using any different number of methods and avoid creating the migration instance.  We use it as a shortcut for rapid iteration here.

Long story short: create the migration instance once and access the endpoint to register the migration (yielding a successful response).  Then leave that machine alone.

# BUILD INSTRUCTIONS

## BUILD - Terraform Container

### Outside the "terraform_aws_web2py" container"

```
git clone git@github.com:myiremark/terraform-aws-web2py-simple-scaling-elb.git;

cd terraform-aws-web2py-simple-scaling-elb/cloud;

docker build -t myiremark/terraform_aws_web2py:latest .  --no-cache

# notice the --no-cache above! we're using git in the docker file.

docker run --name=terraform_aws_webpy -it myiremark/terraform_aws_web2py:latest
```

### Inside the "terraform_aws_web2py" container"

```
aws configure
```

After running the above command, you will be prompted for your AWS access key id and secret key id.  They will be stored in ~/.aws/credentials after you type them.

Don't enter anything for default region name or output format.  You can also put us-east-1 as default region name.  If you put something else, you risk creating resources that will be inaccessible or other configuration problems.

```
cd /terraform-aws-web2py-simple-scaling-elb/cloud/src/cloud;
terraform init;
terraform apply;

cd /terraform-aws-web2py-simple-scaling-elb/cloud/src/ec2/migration_instance;
terraform init;
terraform apply;

# Wait for the output of the above command and for the instance to appear healthy with 2/2 status checks passing in the AWS console.  
# Curl'ing to the endpoint outputted to the terminal from the above apply command will trigger the migration.  
# You will get a successful date and time response.  
# This confirms the db has been migrated successfully.

cd /terraform-aws-web2py-simple-scaling-elb/cloud/src/ec2/template_instance;
terraform init;
terraform apply;

# Wait for the output of the above command and for the instance to appear healthy with 2/2 status checks passing in the AWS console.  
# Curl to the endpoint outputted to the terminal from the above apply command.  
# You will get a successful date and time response.  
# This confirms that the template instance is fully ready for cloning.

# The instance must be signaled externally ready as the logic in the elb module images the vm at the time its run whether or not the template instance has fully booted.

cd /terraform-aws-web2py-simple-scaling-elb/cloud/src/elb;
terraform init;
terraform apply;
```

## BUILD - Loadtesting Container

```
git clone git@github.com:myiremark/terraform-aws-web2py-simple-scaling-elb.git;

cd terraform-aws-web2py-simple-scaling-elb/loadtest;

docker build -t myiremark/terraform_aws_web2py_loadtest:latest .

docker run --name=terraform_aws_webpy_loadtest -it myiremark/terraform_aws_web2py_loadtest:latest
```

### Inside the "terraform_aws_web2py_loadtest" container"

```
LB_URL=OUTPUT_FROM_ABOVE_APPLY_IN_ELB_DIR;

TESTING_ENDPOINT_NO_DB=welcome/default/date_time_only;
TESTING_ENDPOINT_WRITE_DB=welcome/default/date_time;
TESTING_ENDPOINT_READ_DB=welcome/default/date_time;

TESTING_ENDPOINT=$TESTING_ENDPOINT_NO_DB;
TESTING_ENDPOINT=$TESTING_ENDPOINT_READ_DB;
TESTING_ENDPOINT=$TESTING_ENDPOINT_WRITE_DB;

ab -n 5000 -c 20 $LB_URL/$TESTING_ENDPOINT;
ab -n 25000 -c 100 $LB_URL/$TESTING_ENDPOINT;
ab -n 40000 -c 200 $LB_URL/$TESTING_ENDPOINT;
ab -n 40000 -c 200 $LB_URL/$TESTING_ENDPOINT; # triggers scale
ab -n 100000 -c 1000 $LB_URL/$TESTING_ENDPOINT; # peak load testing

```

# Safe Teardown

### Inside the "terraform_aws_web2py" container"

```
cd /terraform-aws-web2py-simple-scaling-elb/cloud/src/elb;
terraform destroy;

cd /terraform-aws-web2py-simple-scaling-elb/cloud/src/ec2/migration_instance;
terraform destroy;

cd /terraform-aws-web2py-simple-scaling-elb/cloud/src/ec2/template_instance;
terraform destroy;

cd /terraform-aws-web2py-simple-scaling-elb/cloud/src/cloud;
terraform destroy;
```
