
set region=us-east-1
set instance_type=t2.micro


aws ec2 run-instances ^
  --image-id ami-0f403e3180720dd7e ^
  --instance-type %instance_type% ^
  --region %region%

