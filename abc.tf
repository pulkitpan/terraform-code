#Create an ami from snapshot of an instance volume

provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}

resource "aws_ami" "example" {
  name                = "linuximage"
  virtualization_type = "hvm"
  root_device_name    = "/dev/xvda"
  imds_support        = "v2.0" # Enforce usage of IMDSv2. You can safely remove this line if your application explicitly doesn't support it.
  ebs_block_device {
    device_name = "/dev/xvda"
    snapshot_id = "snap-0d11b45d0ec9e919b"
    volume_size = 8
  }
}

# create an ami from an instance

provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}

resource "aws_ami_from_instance" "example" {
  name               = "instanceami"
  source_instance_id = "i-03e99e04d1c501fc4"
}


# Copy ami image from one region to another
provider "aws" {
  region     = "us-east-2"
  access_key = ""
  secret_key = ""
}

resource "aws_ami_copy" "example" {
  name              = "copyimage"
  source_ami_id     = "ami-0688e99893940c1ab"
  source_ami_region = "us-east-1"

  tags = {
    Name = "copyimage"
  }
}
