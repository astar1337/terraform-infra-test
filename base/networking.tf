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
 
  
  tags = {
    Name = "${var.instance_name}-${count.index + 1}"
  }
}
