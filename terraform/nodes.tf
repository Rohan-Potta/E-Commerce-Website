data "aws_iam_policy_document" "cluster_nodes_policy" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    sid = "EksClusterRole"
  }
}

resource "aws_iam_role" "nodes" {
  name               = "devops-nodes-group"
  assume_role_policy = data.aws_iam_policy_document.cluster_nodes_policy.json
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

resource "aws_eks_node_group" "private_nodes" {
  cluster_name    = aws_eks_cluster.devops-ekscluster-veltris.name
  node_group_name = "devops-ekscluster-veltris-node-group"
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids = [
    aws_subnet.devops-privatesubnet-2.id,
    aws_subnet.devops-privatesubnet-4.id,
    aws_subnet.devops-privatesubnet-1.id,
    aws_subnet.devops-privatesubnet-3.id
  ]
  ami_type       = "AL2_x86_64"
  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.large"]
  disk_size      = 100
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  update_config {
    max_unavailable = 1
  }
  labels = {
    role = "general"
  }
  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}
resource "aws_eks_node_group" "public_nodes" {
  cluster_name    = aws_eks_cluster.devops-ekscluster-veltris.name
  node_group_name = "devops-ekscluster-veltris-node-group"
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids = [
      aws_subnet.devops-publicsubnet-1.id,
      aws_subnet.devops-publicsubnet-2.id
  ]
  ami_type       = "AL2_x86_64"
  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.micro"]
  disk_size      = 100
  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  update_config {
    max_unavailable = 1
  }
  labels = {
    role = "general"
  }
  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}

