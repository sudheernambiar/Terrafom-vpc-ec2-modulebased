#################################################################################
#Data Source
#################################################################################
data "aws_availability_zones" "my_az" {
  state = "available"
}

###################
#the out put we pulls from this is data.aws_availability_zones.my_az.names[0] (0,1,2)
####################