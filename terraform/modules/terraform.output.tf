output "public_ip" {
  value = aws_eip.unity_ec2.public_ip
}