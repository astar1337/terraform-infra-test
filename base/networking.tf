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
# A more robust S3 bucket configuration
resource "aws_s3_bucket" "app_storage" {
  bucket = "my-app-storage-${random_string.bucket_suffix.result}"
  
  # This ensures the bucket can be destroyed even if it contains objects
  # Use carefully - this is like having a master key that can delete everything
  force_destroy = false
}

# Generate a random suffix to ensure bucket name uniqueness
# This solves the problem that S3 bucket names must be globally unique
resource "random_string" "bucket_suffix" {
  length  = 8
  special = true
  upper   = false
}

# Block all public access - this is your security fortress wall
resource "aws_s3_bucket_public_access_block" "app_storage_pab" {
  bucket = aws_s3_bucket.app_storage.id

  # These four settings work together to prevent accidental public exposure
  block_public_acls       = true  # Blocks new public ACLs from being applied
  block_public_policy     = true  # Blocks new public policies from being applied
  ignore_public_acls      = true  # Ignores existing public ACLs
  restrict_public_buckets = true  # Restricts public bucket policies
}

# Enable versioning - like having automatic backup copies of every file change
resource "aws_s3_bucket_versioning" "app_storage_versioning" {
  bucket = aws_s3_bucket.app_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure server-side encryption - your data gets locked with a key
resource "aws_s3_bucket_server_side_encryption_configuration" "app_storage_encryption" {
  bucket = aws_s3_bucket.app_storage.id

  rule {
    apply_server_side_encryption_by_default {
      # AES256 is AWS-managed encryption, KMS gives you more control
      sse_algorithm = "AES256"
    }
    # This ensures that unencrypted uploads are rejected
    bucket_key_enabled = true
  }
}