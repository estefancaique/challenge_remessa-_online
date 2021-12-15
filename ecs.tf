/*====
Variables used across all modules
======*/
locals {
  production_availability_zones = ["us-west-1a", "us-west-1c"]
}

/*====
Criando VPC para ECS
======*/
module "networking" {
  source               = "./modules/networking"
  environment          = "Teste"
  vpc_cidr             = "10.0.0.0/16"
  public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidr = ["10.0.10.0/24", "10.0.20.0/24"]
  region               = "us-west-1"
  availability_zones   = "${local.production_availability_zones}"
}

/*====
Criando Cluster para ECS
======*/

resource "aws_ecs_cluster" "teste-remessa" {
  name = "teste-remessa"

}

