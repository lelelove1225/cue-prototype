resource "aws_vpc" "MainVPCTF" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "false"
    tags {
      Name = "MainVPCTF"
    }
}
output "vpc_id" { value = "${aws_vpc.MainVPC.id}" }