locals {
  name = var.name
  tags = var.tags
}

################################################################################
# CloudWatch LogGroup
################################################################################

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/ec2/${local.name}-${random_id.this.hex}"
  retention_in_days = 7

  tags = local.tags
}

################################################################################
# CloudWatch Dashboard
################################################################################

resource "aws_cloudwatch_dashboard" "this" {
  dashboard_name = "${local.name}-${random_id.this.hex}-EC2-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 24
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",
              "InstanceId",
              var.instance_id,
            ]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "CPU Utilization: Average"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 8
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "NetworkIn",
              "InstanceId",
              var.instance_id,
              {
                period = 300
                stat   = "Average"
              }
            ],
            [
              "AWS/EC2",
              "NetworkOut",
              "InstanceId",
              var.instance_id,
              {
                period = 300
                stat   = "Average"
              }
            ]
          ]
          legend = {
            position = "bottom"
          }
          region = var.aws_region
          title  = "NetworkIn: Average, NetworkOut: Average"
          view   = "timeSeries"
        }
      },
      {
        type   = "metric"
        x      = 8
        y      = 6
        width  = 8
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "DiskReadBytes",
              "InstanceId",
              var.instance_id,
              {
                period = 300
                stat   = "Average"
              }
            ],
            [
              "AWS/EC2",
              "DiskWriteBytes",
              "InstanceId",
              var.instance_id,
              {
                period = 300
                stat   = "Average"
              }
            ]
          ]
          legend = {
            position = "bottom"
          }
          region = var.aws_region
          title  = "DiskReadBytes: Average, DiskWriteBytes: Average"
          view   = "timeSeries"
        }
      },
      {
        type   = "metric"
        x      = 16
        y      = 6
        width  = 8
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "StatusCheckFailed",
              "InstanceId",
              var.instance_id,
              {
                period = 300
                stat   = "Sum"
              }
            ]
          ]
          region = var.aws_region
          title  = "StatusCheckFailed: Sum"
          view   = "timeSeries"
        }
      },
      {
        type   = "log"
        x      = 0
        y      = 12
        width  = 24
        height = 6

        properties = {
          query   = <<-EOT
            SOURCE '${aws_cloudwatch_log_group.this.name}' | fields @timestamp, @message, @logStream, @log
            | sort @timestamp desc
            | limit 20
          EOT
          view    = "table"
          stacked = false
          region  = var.aws_region
          title   = "Docker container logs"
        }
      }
    ]
  })
}

################################################################################
# Supporting resources
################################################################################

resource "random_id" "this" {
  byte_length = 4
}
