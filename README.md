# terraform-aws
using terraform with aws
## Archeticture: 
![aws infra soln (1)](https://user-images.githubusercontent.com/68178003/100705202-7d55cb00-33af-11eb-8319-caae70b168ef.png)
## proven steps:
1. cluster created with the required number of nodes listed in terraform.tfvars and the number of healthy check and other specs : 
![Screenshot from 2020-11-21 11-49-05](https://user-images.githubusercontent.com/68178003/100705210-8181e880-33af-11eb-87d6-cb90073090c7.png)
![Screenshot from 2020-11-21 11-50-31](https://user-images.githubusercontent.com/68178003/100705216-847cd900-33af-11eb-83a5-3ace8c9e39e9.png)
2. loadbalancer created listening to port 80 and forwarding to port 80 and connected to the 2 instances with the health checks shown :

![Screenshot from 2020-11-21 11-51-50](https://user-images.githubusercontent.com/68178003/100705234-8a72ba00-33af-11eb-82db-ca0e8efaec7e.png)
![Screenshot from 2020-11-21 11-52-11](https://user-images.githubusercontent.com/68178003/100705244-8e064100-33af-11eb-86b3-dac84fa46df3.png)
![Screenshot from 2020-11-21 11-52-26](https://user-images.githubusercontent.com/68178003/100705260-93fc2200-33af-11eb-8495-b9f45add9d5c.png)

3. app shown accessible through the loadbalancer dns

![Screenshot from 2020-11-21 11-53-09](https://user-images.githubusercontent.com/68178003/100705266-98c0d600-33af-11eb-8ecc-e865aff0ebe0.png)
