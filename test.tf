provider"aws"{
  profile ="default"
  region ="us-west-2"
}

resource "aws-s3-bucket" "tf-course"{
  bucket="tf-course-1234523"
  acl="private"
}

