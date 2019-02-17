# Builds test-service and pushes it into aws_ecr_repository
resource "null_resource" "build_and_push" {
  triggers {
    docker_image_tag = "${var.docker_image_tag}"
  }

  # See build.sh for more details
  provisioner "local-exec" {
    command = "${path.module}/bin/build.sh ${var.build_folder} ${var.dockerfile_folder} ${var.ecr_repository_url}:${var.docker_image_tag} ${var.aws_region}"
  }
}
