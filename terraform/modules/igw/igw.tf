resource "aws_internet_gateway" "myGW" {
    vpc_id = "${aws_vpc.VPC01.id}"
}