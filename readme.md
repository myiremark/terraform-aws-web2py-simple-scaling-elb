# Goals

- support 1K requests / second peak capacity
- mean response time < 400ms
- 99.99% success rate @ 1k requests / sec sustained load

# Design Considerations

Separate docker files for:
- terraform management container
- load testing container

Separate directories/states for:
- cloud resources (vpc, db, security groups)
- ec2 instances:
  - migration instance
  - template instance
- elb resources

In order to create the database table structure, this project leverages web2py's automigrations.  This requires us to set up a separate VM which is stateful 
and should only be created/destroyed when changing the db schema, or else the migration files will be inconsistent and require manual intervention.

Long story short: create the migration instance once and access the endpoint to register the migration (yielding a successful response).  Then leave that machine alone.

# BUILD

## CLOUD

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

it will prompt for your AWS access key id and secret key id.  they are stored in ~/.aws/credentials.

don't enter anything for default region name or output format

```
cd /terraform-aws-web2py-simple-scaling-elb/cloud/src/cloud;
terraform init;
terraform apply;

cd /terraform-aws-web2py-simple-scaling-elb/cloud/src/ec2/migration_instance;
terraform init;
terraform apply;

# wait for output of above command and for instance to be healthy.  Hit that endpoint and trigger the migration.  You will get a successful date and time response.  Then you know the db has been migrated successfully.

cd /terraform-aws-web2py-simple-scaling-elb/cloud/src/ec2/template_instance;
terraform init;
terraform apply;

# wait for output of above command and for instance to be healthy.  Hit that endpoint.  You will get a successful date and time response.  Then you know that the template instance is fully ready for cloning.  The instance must be signaled externally ready as the logic in the elb module images the vm at the time its run whether or not the template instance has fully booted.

cd /terraform-aws-web2py-simple-scaling-elb/cloud/src/elb;
terraform init;
terraform apply;

# enjoy ;)
```

## Loadtesting Container

```
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


# RESULTS

burst capacity:
- < 400 ms mean response time @ 3000 requests/sec
- < 100 ms mean response time @ 1000 requests/sec
- < 1% non 200 response rate

sustained capacity:
- > 100 requests/sec
- < 400 ms response time (~200)
- < 1% non 200 response rate (0 @ 100 reqs/sec)

# Safe Teardown

terraform destroy in this order:
- elb
- migration_instance
- template_instance
- cloud
