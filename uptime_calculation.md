# Uptime Calculation

## Service Availability Defintion

For our service, we consider the service available if it returns a 200 response in < 400 ms accurately.

For the purposes of calculation, we assume that at no time will the service exceed 1k requests/second. Practically, we planned for excess capacity.

This system was tested and could handle 1000 requests per second consistently with 20 t2.micro vm's.

If each component of the service is modeled independent of the others, uptime can be modeled as:

1 - p^n

where

p is the probability that a node is down

and

n is the number of nodes.

To achieve 99.99% uptime, that means the service can be down for 8s per day.  We take this as aggregate time over a day to go from sustained capacity to peak capacity. Despite pre-baking the vm's, their time from instance creation to instance ready is still ~180s.  This means the service must be ready at all times to handle peak capacity.

## Conclusion

This would suggest setting the value of [asg_min_size](cloud/common/variables.tf) to 20 in order to achieve 99.99% uptime.

## Caveats

This calculation was only created based on EC2 compute nodes.  

RDS is another single point of failure and its uptime calculation should be approached in the same way.
Postgres can be clustered in a reader/writer fashion across geographic regions and even service providers.

Additionally, this service is dependent on AWS ELB and their upstream DNS as a single point of failure.  Cross cloud and multi region redundancies would improve availability.

Scaling up expected capacity will also result in a required increase to the max number of connections available from postgres.

Web2py specific application performance enhancements are documented at web2py.com and include database connection pooling, database connection load balancing, and response caching.

At an middleware layer, uwsgi and nginx can both be configured further to allow further queuing of requests if necessary.
