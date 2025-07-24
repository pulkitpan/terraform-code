provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}

# Create ebs volume as well snapshot of ebs volume
resource "aws_ebs_volume" "example" {
  availability_zone = "us-east-1a"
  size              = 5

  tags = {
    Name = "cloudstorage"
  }
}

resource "aws_ebs_snapshot" "example_snapshot" {
  volume_id = aws_ebs_volume.example.id

  tags = {
    Name = "cloud_snap"
  }
}
