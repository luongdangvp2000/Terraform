################# S3 #######################
# aws_s3_bucket: define s3 bucket 
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.project}-s3-backend"
  force_destroy = false

  tags = local.tags
}

# aws_s3_bucket_acl: define Access control list, default: private 
resource "aws_s3_bucket_acl" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

# Resource to avoid error "AccessControlListNotSupported: The bucket does not allow ACLs"
resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

# aws_s3_bucket_versioning: allow different version of objects in bucket  
resource "aws_s3_bucket_versioning" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_kms_key" "kms_key" {
  tags = local.tags
}

# aws_s3_bucket_server_side_encryption_configuratio: enable SSE (Server Side Encryption),  
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.kms_key.arn
    }
  }
}

######################## dynamoDB ################################
resource "aws_dynamodb_table" "dynamodb_table" {
  name = "${var.project}-s3-backend"
  hash_key = "LockID" # UserID / LockID
  billing_mode = "PAY_PER_REQUEST" # PROVISIONED/PAY_PER_REQUEST

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = local.tags
}