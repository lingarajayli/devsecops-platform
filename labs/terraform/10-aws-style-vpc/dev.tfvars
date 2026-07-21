environment      = "dev"
application_name = "flask-health-api"
vpc_cidr         = "10.0.0.0/16"

public_subnets = {
  public-a = "10.0.1.0/24"
  public-b = "10.0.2.0/24"
}

private_subnets = {
  private-a = "10.0.11.0/24"
  private-b = "10.0.12.0/24"
}