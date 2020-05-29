FROM ubuntu:18.04

MAINTAINER "Mark Graves <mark@myire.com>"

RUN apt-get update -y && apt-get install -y unzip wget git;

RUN wget https://releases.hashicorp.com/terraform/0.12.25/terraform_0.12.25_linux_amd64.zip;

RUN unzip terraform_0.12.25_linux_amd64.zip;

RUN mv terraform /usr/local/bin/

RUN terraform -install-autocomplete

RUN wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip

RUN unzip awscli-exe-linux-x86_64.zip

RUN ./aws/install

RUN ssh-keygen -t ecdsa -f /root/.ssh/id_ecdsa -q -P "" 0>&-

RUN git clone https://github.com/myiremark/terraform-aws-web2py-simple-scaling-elb.git

