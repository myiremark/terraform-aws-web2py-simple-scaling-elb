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

# BUILD

## CLOUD

### Outside the "terraform_aws_web2py" container"

```
git clone git@github.com:myiremark/terraform-aws-web2py-simple-scaling-elb.git;

cd terraform-aws-web2py-simple-scaling-elb/cloud;

docker build -t myiremark/terraform_aws_web2py:latest .

docker run --name=terraform_aws_webpy -it myiremark/terraform_aws_web2py:latest
```

### Inside the "terraform_aws_web2py" container"

```
aws configure
```

it will prompt for your AWS access key id and secret key id 

```
cd /terraform-aws-web2py-simple-scaling-elb/cloud/src/;
terraform init;
terraform apply;
```
