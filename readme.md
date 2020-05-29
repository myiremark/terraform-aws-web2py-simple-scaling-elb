# Goals

- support 1K requests / second peak capacity
- mean response time < 400ms
- 99.99% success rate @ 1k requests / sec sustained load

# Design Considerations

Separate docker files for:
- terraform management container
- load testing container

Separate directories/states for:
- migration instance
- template instance

# BUILD

## CLOUD

# cloud

git clone git@github.com:myiremark/terraform-aws-web2py-simple-scaling-elb.git;

cd terraform-aws-web2py-simple-scaling-elb/cloud;

docker build -t myiremark/terraform_aws_web2py:latest .

docker run -it myiremark/terraform_aws_web2py:latest /bin/bash --name=terraform_aws_webpy

