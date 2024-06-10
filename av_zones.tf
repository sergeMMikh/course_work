# e.g., Create subnets in the first two available availability zones

resource "aws_default_subnet" "primary" {
  availability_zone = data.aws_availability_zones.av_zone.names[0]

  tags = {
    Name = "Default subnet primary"
  }
}

resource "aws_default_subnet" "secondary" {
  availability_zone = data.aws_availability_zones.av_zone.names[1]

  tags = {
    Name = "Default subnet secondary"
  }
}
