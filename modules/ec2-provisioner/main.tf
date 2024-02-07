resource "null_resource" "cloud-init-wait" {

  connection {
    bastion_host        = var.proxy_host
    bastion_user        = var.proxy_user
    bastion_private_key = var.proxy_private_key

    host        = var.host
    user        = var.user
    private_key = var.private_key
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
    ]
  }
}

resource "null_resource" "ec2_provisioner" {

  connection {
    bastion_host        = var.proxy_host
    bastion_user        = var.proxy_user
    bastion_private_key = var.proxy_private_key

    host        = var.host
    user        = var.user
    private_key = var.private_key
  }

  provisioner "remote-exec" {
    inline = [
      "docker run -it -d -p 80:80 --log-driver=awslogs --log-opt awslogs-region=${var.aws_region} --log-opt awslogs-group=${var.cloudwatch_log_group_name} --name web ${var.container_image}",
      "aws s3 sync s3://${var.bucket_name} /tmp/html",
      "docker cp /tmp/html web:/tmp",
      "docker exec -it web /bin/sh -c 'cp -a /tmp/html/* /usr/share/nginx/html'",
    ]
  }

  depends_on = [
    null_resource.cloud-init-wait
  ]
}
