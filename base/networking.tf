resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24" # A subset of the VPC CIDR block
  availability_zone       = "eu-central-1a" # Choose your desired AZ
  map_public_ip_on_launch = true          # This automatically assigns public IPs to instances

  tags = {
    Name = "public-subnet"
  }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"                 # All traffic
    gateway_id = aws_internet_gateway.igw.id # Send to internet gateway
  }

  tags = {
    Name = "public-route-table"
  }
}
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}
resource "aws_instance" "web_servers" {
  count         = 1
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id

  
  tags = {
    Name = "${var.instance_name}-${count.index + 1}"
  }
  
}
resource "aws_security_group" "web_sg" {
  name_prefix = "web-server-"
  vpc_id      = aws_vpc.main.id

  # Allow SSH for EC2 Instance Connect
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-server-sg"
  } 
}
variable "key_pair_name" {
  description = "Name of the AWS key pair for SSH access"
  type        = string
}
