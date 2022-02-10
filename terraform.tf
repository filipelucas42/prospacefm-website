provider "aws" {
  region  = "eu-west-1"
  profile = "personal"
}
resource "aws_s3_bucket" "prospacefm" {
  bucket = "prospacefm"
}

resource "aws_s3_bucket_object" "parts_taxonomy" {

  for_each = fileset("./public/", "**")
  bucket   = aws_s3_bucket.prospacefm.id

  key = each.value

  source       = "./public/${each.value}"
  etag         = filemd5("./public/${each.value}")
  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.value), null)
}

locals {
  mime_types = jsondecode(file("./mime.json"))
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.prospacefm.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.prospacefm.id}/*",
    ]
  }
}