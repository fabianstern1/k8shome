terraform {
  required_version = ">= 0.12"
  required_providers {

    docker = {
      source  = "kreuzwerker/docker"
      version = ">2.11.0"
    }
  }


}

provider "docker" {}

resource "docker_network" "network" {
  name = "k8s"
  ipam_config {
    subnet = "175.30.0.0/16"
  }
}


resource "docker_image" "ubuntu" {
  name = "ubuntu-k8s"
  build {
    context = "./docker"
    tag     = ["ubuntu-k8s"]
    build_arg = {
      k8s : "true"
    }
    label = {
      author : "me"
    }
  }
}

resource "docker_container" "node" {
  count = 5
  image = "${docker_image.ubuntu.name}"
  name  = "node${count.index + 1}"
  hostname = "node${count.index + 1}"
  ports {
    internal = 22
  }
  networks_advanced {
    name = "${docker_network.network.name}"
    ipv4_address = "175.30.0.${count.index + 2}"
  }

}
