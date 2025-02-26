data "aws_iam_policy_document" "cluster_policy" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    sid = "EksClusterRole"
  }
}
resource "aws_iam_role" "devops-eks-role-veltris" {
  name               = "devops-ekscluster-veltris"
  assume_role_policy = data.aws_iam_policy_document.cluster_policy.json
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.devops-eks-role-veltris.name
}

resource "aws_eks_cluster" "devops-ekscluster-veltris" {
  name     = "devops-ekscluster-veltris"
  role_arn = aws_iam_role.devops-eks-role-veltris.arn
  version  = "1.27"

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = false
    subnet_ids = [
      aws_subnet.devops-privatesubnet-2.id,
      aws_subnet.devops-privatesubnet-4.id,
      aws_subnet.devops-privatesubnet-1.id,
      aws_subnet.devops-privatesubnet-3.id,
      aws_subnet.devops-publicsubnet-1.id,
      aws_subnet.devops-publicsubnet-2.id
    ]
  }
}



