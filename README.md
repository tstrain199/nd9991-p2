# Cloud DevOps ND Project 2

## Multiple Files

To keep the project organized logically the code is split between two files. **iacp2-network.yml** contains the networking structure.  **iacp2-server.yml** contains the autoscaling group, hosts, and supporting resources.

## To build the Resources

1. aws cloudformation create-stack --stack-name iacp2-net --template-body file://iacp2-network.yml --parameters file://iacp2-network.json --region=us-west-2 --capabilities CAPABILITY_IAM
2. aws cloudformation create-stack --stack-name iacp2-serv --template-body file://iacp2-server.yml --parameters file://iacp2-server.json --region=us-west-2


