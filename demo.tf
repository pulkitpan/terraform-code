provider "aws" {
  region     = "us-east-2"
  access_key = ""
  secret_key = ""
}
# copy snapshot from one region to another within same account

resource "aws_ebs_snapshot_copy" "example_copy" {
  source_snapshot_id = "snap-0d381b4b073852ba2"
  source_region      = "us-east-1"

  tags = {
    Name = "copy_snap"
  }
}
