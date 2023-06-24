# Create a new load balancer
resource "aws_elb" "bar" {
  name               = "terraform-elb"
  availability_zones = ["ap-south-1a", "ap-south-1b"]


  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }


  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = ["${aws_instance.example_instance.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 40

  tags = {
    Name = "terraform-elb"
  }
}