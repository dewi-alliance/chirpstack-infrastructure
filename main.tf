# ***************************************
# VPC
# ***************************************
module "vpc" {
  source = "./modules/vpc"

  vpc_name       = "chirpstack_vpc"
  vpc_cidr_block = "10.0.0.0/16"

  availability_zone_1 = "us-east-1a"
  availability_zone_2 = "us-east-1b"

  public_subnet_1   = "10.0.1.0/24"
  public_subnet_2   = "10.0.2.0/24"
  private_subnet_1  = "10.0.101.0/24"
  private_subnet_2  = "10.0.102.0/24"
  database_subnet_1 = "10.0.201.0/24"
  database_subnet_2 = "10.0.202.0/24"

  vpc_public_subnet_tags = {
    "kubernetes.io/cluster/chirpstack_cluster" = "shared"
    "kubernetes.io/role/elb"                   = 1
  }
  vpc_private_subnet_tags = {
    "kubernetes.io/cluster/chirpstack_cluster" = "shared"
    "kubernetes.io/role/internal-elb"          = 1
  }
}

# ***************************************
# VPC
# ***************************************
module "eks" {
  source = "./modules/eks"

  vpc_id                 = module.vpc.vpc_id
  vpc_private_subnet_ids = module.vpc.private_subnets_ids

  eks_cluster_name    = "chirpstack_cluster"
  eks_cluster_version = 1.29

  eks_vpc_cni_addon      = null
  eks_coredns_version    = null
  eks_kube_proxy_version = null

  eks_aws_auth_roles = [{
    rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${tolist(data.aws_iam_roles.admin_role.names)[0]}"
    username = "AWSAdministratorAccess:{{SessionName}}"
    groups = [
      "system:masters",
    ]
  }]
}
