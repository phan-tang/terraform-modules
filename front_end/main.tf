resource "aws_s3_bucket" "front_end_bucket" {
  bucket = "${var.bucket_name}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "front_end_bucket" {
  bucket = aws_s3_bucket.front_end_bucket.id 
  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false  
}

data "aws_iam_policy_document" "front_end_bucket" {
  statement{

    principals {
      type = "AWS"
      identifiers = ["*"]
    }    

    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.front_end_bucket.arn,
      "${aws_s3_bucket.front_end_bucket.arn}/*"
    ]
  }

}

resource "aws_s3_bucket_policy" "front_end_bucket" {
  bucket = aws_s3_bucket.front_end_bucket.id 
  policy = data.aws_iam_policy_document.front_end_bucket.json
}

resource "null_resource" "s3_deployment" {
  triggers = {
    always_run   = timestamp()
  }
  
  provisioner "local-exec" {
    command = <<EOT
      cd ${var.code_folder_name}
      npm run build
      aws s3 sync ./build s3://${var.bucket_name}
    EOT
  }
}

resource "aws_s3_bucket_website_configuration" "front_end_bucket" {
  bucket = aws_s3_bucket.front_end_bucket.id 
  index_document {
    suffix = "index.html"    
  }
}