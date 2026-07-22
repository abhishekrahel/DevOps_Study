output "name_of_the_cluster" {
    value = aws_eks_cluster.main
}

output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}