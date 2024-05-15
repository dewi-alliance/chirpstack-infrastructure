data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.this.name
  depends_on = [aws_eks_cluster.this]
}