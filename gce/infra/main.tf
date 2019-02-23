provider "google" {
  version = "~> 1.20"
  credentials = "${file("~/ocp-sa.json")}"
  project = "${var.project}"
  region = "${var.region}"
  zone = "${var.zone}"
}

provider "local" {
  version ="~> 1.1"
}

resource "google_compute_network" "default" {
  name = "${var.cluster_id}-network"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "default" {
  name = "${var.cluster_id}-subnetwork"
  network = "${google_compute_network.default.name}"
  ip_cidr_range = "${var.subnetwork_cidr}"
}

resource "google_compute_firewall" "external-to-bastion" {
  name = "${var.cluster_id}-external-to-bastion"
  network = "${google_compute_network.default.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["${var.cluster_id}-bastion"]
}

resource "google_compute_firewall" "bastion-to-node" {
  name = "${var.cluster_id}-bastion-to-node"
  network = "${google_compute_network.default.name}"

  allow {
    protocol = "tcp"
  }

  source_tags = ["${var.cluster_id}-bastion"]
  target_tags = ["${var.cluster_id}-node"]
}

resource "google_compute_firewall" "node-to-master" {
  name = "${var.cluster_id}-node-to-master"
  network = "${google_compute_network.default.name}"

  allow {
    protocol = "tcp"
    ports = ["8053"]
  }

  allow {
    protocol = "udp"
    ports = ["8053"]
  }

  source_tags = ["${var.cluster_id}-node"]
  target_tags = ["${var.cluster_id}-master"]
}

resource "google_compute_firewall" "master-to-node" {
  name = "${var.cluster_id}-master-to-node"
  network = "${google_compute_network.default.name}"

  allow {
    protocol = "tcp"
    ports = ["10250"]
  }

  source_tags = ["${var.cluster_id}-master"]
  target_tags = ["${var.cluster_id}-node"]
}

resource "google_compute_firewall" "master-to-master" {
  name = "${var.cluster_id}-master-to-master"
  network = "${google_compute_network.default.name}"

  allow {
    protocol = "tcp"
    ports = ["2379-2380"]
  }

  source_tags = ["${var.cluster_id}-master"]
  target_tags = ["${var.cluster_id}-master"]
}

resource "google_compute_firewall" "any-to-master" {
  name = "${var.cluster_id}-any-to-master"
  network = "${google_compute_network.default.name}"

  allow {
    protocol = "tcp"
    ports = ["443"]
  }

  source_ranges = ["${var.subnetwork_cidr}"]
  target_tags = ["${var.cluster_id}-master"]
}

resource "google_compute_firewall" "infra-to-master" {
  name = "${var.cluster_id}-infra-to-master"
  network = "${google_compute_network.default.name}"

  allow {
    protocol = "tcp"
    ports = ["2379", "8444"]
  }

  source_tags = ["${var.cluster_id}-infra"]
  target_tags = ["${var.cluster_id}-master"]
}

resource "google_compute_firewall" "infra-to-infra" {
  name = "${var.cluster_id}-infra-to-infra"
  network = "${google_compute_network.default.name}"

  allow {
    protocol = "tcp"
    ports = ["9200", "9300"]
  }

  source_tags = ["${var.cluster_id}-infra"]
  target_tags = ["${var.cluster_id}-infra"]
}

resource "google_compute_firewall" "any-to-infra" {
  name = "${var.cluster_id}-any-to-infra"
  network = "${google_compute_network.default.name}"

  allow {
    protocol = "tcp"
    ports = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["${var.cluster_id}-infra"]
}

resource "google_compute_firewall" "node-to-node" {
  name = "${var.cluster_id}-node-to-node"
  network = "${google_compute_network.default.name}"

  allow {
    protocol = "tcp"
    ports = ["4789"]
  }

  source_tags = ["${var.cluster_id}-node"]
  target_tags = ["${var.cluster_id}-node"]
}

resource "google_compute_firewall" "infra-to-node" {
  name = "${var.cluster_id}-infra-to-node"
  network = "${google_compute_network.default.name}"

  allow {
    protocol = "tcp"
    ports = ["9100", "10250"]
  }

  source_tags = ["${var.cluster_id}-infra"]
  target_tags = ["${var.cluster_id}-node"]
}

resource "google_compute_global_address" "master-lb" {
  name = "${var.cluster_id}-master-lb"
  ip_version = "IPV4"
  address_type = "EXTERNAL"
}

resource "google_compute_address" "apps-lb" {
  name = "${var.cluster_id}-apps-lb"
  address_type = "EXTERNAL"
  region = "${var.region}"
}

resource "google_compute_address" "bastion" {
  name = "${var.cluster_id}-bastion"
  address_type = "EXTERNAL"
  region = "${var.region}"
}

resource "google_dns_managed_zone" "default" {
  name = "${var.cluster_id}-rht-labs-xyz"
  dns_name = "${var.cluster_id}.rht-labs.xyz."
  description = "DNS Managed Zone for ${var.cluster_id} OpenShift Cluster"
}

resource "google_dns_record_set" "master" {
  name = "paas.${google_dns_managed_zone.default.dns_name}"
  managed_zone = "${google_dns_managed_zone.default.name}"
  type = "A"
  ttl = 300
  rrdatas = ["${google_compute_global_address.master-lb.address}"]
}

resource "google_dns_record_set" "apps" {
  name = "*.apps.${google_dns_managed_zone.default.dns_name}"
  managed_zone = "${google_dns_managed_zone.default.name}"
  type = "A"
  ttl = 300
  rrdatas = ["${google_compute_address.apps-lb.address}"]
}

resource "google_dns_record_set" "bastion" {
  name = "bastion.${google_dns_managed_zone.default.dns_name}"
  managed_zone = "${google_dns_managed_zone.default.name}"
  type = "A"
  ttl = 300
  rrdatas = ["${google_compute_address.bastion.address}"]
}

resource "google_compute_instance" "bastion" {
  name = "${var.cluster_id}-bastion"
  machine_type = "${var.bastion_machine_size}"
  zone = "${var.zone}"
  allow_stopping_for_update = "true"
  
  scheduling {
    on_host_maintenance = "MIGRATE"
  }

  tags = [
    "${var.cluster_id}-bastion"
  ]

  boot_disk {
    device_name = "${var.cluster_id}-bastion"
    auto_delete = "true"

    initialize_params {
      image = "${var.os_image}"
      size = "${var.bastion_boot_disk_size}"
      type = "${var.bastion_boot_disk_type}"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.default.name}"

    access_config {
      // Ephemeral IP
    }
  }

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_write",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol"
    ]
  }

  metadata {
    ocp-cluster = "${var.cluster_id}"
    ocp-type = "bastion"
  }
}

resource "google_compute_disk" "master-etcd" {
  name = "${var.cluster_id}-master-${count.index}-etcd"
  zone = "${var.zone}"
  type = "${var.master_etcd_disk_type}"
  size = "${var.master_etcd_disk_size}"
  count = "${var.master_count}"
}

resource "google_compute_disk" "master-containers" {
  name = "${var.cluster_id}-master-${count.index}-containers"
  zone = "${var.zone}"
  type = "${var.master_containers_disk_type}"
  size = "${var.master_containers_disk_size}"
  count = "${var.master_count}"
}

resource "google_compute_disk" "master-local" {
  name = "${var.cluster_id}-master-${count.index}-local"
  zone = "${var.zone}"
  type = "${var.master_local_disk_type}"
  size = "${var.master_local_disk_size}"
  count = "${var.master_count}"
}

data "local_file" "master-node-init-script" {
  filename = "scripts/init-master-node.sh"
}

resource "google_compute_instance" "master" {
  name = "${var.cluster_id}-master-${count.index}"
  machine_type = "${var.master_machine_size}"
  zone = "${var.zone}"
  allow_stopping_for_update = "true"
  count = "${var.master_count}"

  scheduling {
    on_host_maintenance = "MIGRATE"
  }

  tags = [
    "${var.cluster_id}-master",
    "${var.cluster_id}-node"
  ]

  boot_disk {
    device_name = "${var.cluster_id}-master"
    auto_delete = "true"

    initialize_params {
      image = "${var.os_image}"
      size = "${var.master_boot_disk_size}"
      type = "${var.master_boot_disk_type}"
    }
  }

  attached_disk = {
    source = "${var.cluster_id}-master-${count.index}-etcd"
    device_name = "${var.cluster_id}-master-${count.index}-etcd"
    mode = "READ_WRITE"
  }

  attached_disk = {
    source = "${var.cluster_id}-master-${count.index}-containers"
    device_name = "${var.cluster_id}-master-${count.index}-containers"
    mode = "READ_WRITE"
  }

  attached_disk = {
    source = "${var.cluster_id}-master-${count.index}-local"
    device_name = "${var.cluster_id}-master-${count.index}-local"
    mode = "READ_WRITE"
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.default.name}"

    access_config {
      // Ephemeral IP
    }
  }

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol"
    ]
  }

  metadata {
    ocp-cluster = "${var.cluster_id}"
    ocp-type = "master"
  }

  metadata_startup_script = "${data.local_file.master-node-init-script.content}"

  depends_on = [
    "google_compute_disk.master-etcd",
    "google_compute_disk.master-containers",
    "google_compute_disk.master-local"
  ]
}

resource "google_compute_disk" "infra-containers" {
  name = "${var.cluster_id}-infra-${count.index}-containers"
  zone = "${var.zone}"
  type = "${var.infra_containers_disk_type}"
  size = "${var.infra_containers_disk_size}"
  count = "${var.infra_count}"
}

resource "google_compute_disk" "infra-local" {
  name = "${var.cluster_id}-infra-${count.index}-local"
  zone = "${var.zone}"
  type = "${var.infra_local_disk_type}"
  size = "${var.infra_local_disk_size}"
  count = "${var.infra_count}"
}

data "local_file" "infra-node-init-script" {
  filename = "scripts/init-infra-node.sh"
}

resource "google_compute_instance" "infra" {
  name = "${var.cluster_id}-infra-${count.index}"
  machine_type = "${var.infra_machine_size}"
  zone = "${var.zone}"
  allow_stopping_for_update = "true"
  count = "${var.infra_count}"

  scheduling {
    on_host_maintenance = "MIGRATE"
  }

  tags = [
    "${var.cluster_id}-infra",
    "${var.cluster_id}-node",
    "${var.cluster_id}ocp"
  ]

  boot_disk {
    device_name = "${var.cluster_id}-infra"
    auto_delete = "true"

    initialize_params {
      image = "${var.os_image}"
      size = "${var.infra_boot_disk_size}"
      type = "${var.infra_boot_disk_type}"
    }
  }

  attached_disk = {
    source = "${var.cluster_id}-infra-${count.index}-containers"
    device_name = "${var.cluster_id}-infra-${count.index}-containers"
    mode = "READ_WRITE"
  }

  attached_disk = {
    source = "${var.cluster_id}-infra-${count.index}-local"
    device_name = "${var.cluster_id}-infra-${count.index}-local"
    mode = "READ_WRITE"
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.default.name}"

    access_config {
      // Ephemeral IP
    }
  }

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_write",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol"
    ]
  }

  metadata {
    ocp-cluster = "${var.cluster_id}"
    ocp-type = "infra"
  }

  metadata_startup_script = "${data.local_file.infra-node-init-script.content}"

  depends_on = [
    "google_compute_disk.infra-containers",
    "google_compute_disk.infra-local"
  ]
}

resource "google_compute_disk" "compute-containers" {
  name = "${var.cluster_id}-compute-${count.index}-containers"
  zone = "${var.zone}"
  type = "${var.compute_containers_disk_type}"
  size = "${var.compute_containers_disk_size}"
  count = "${var.compute_count}"
}

resource "google_compute_disk" "compute-local" {
  name = "${var.cluster_id}-compute-${count.index}-local"
  zone = "${var.zone}"
  type = "${var.compute_local_disk_type}"
  size = "${var.compute_local_disk_size}"
  count = "${var.compute_count}"
}

data "local_file" "compute-node-init-script" {
  filename = "scripts/init-compute-node.sh"
}

resource "google_compute_instance" "compute" {
  name = "${var.cluster_id}-compute-${count.index}"
  machine_type = "${var.compute_machine_size}"
  zone = "${var.zone}"
  allow_stopping_for_update = "true"
  count = "${var.compute_count}"

  scheduling {
    on_host_maintenance = "MIGRATE"
  }

  tags = [
    "${var.cluster_id}-node",
    "${var.cluster_id}ocp"
  ]

  boot_disk {
    device_name = "${var.cluster_id}-compute"
    auto_delete = "true"

    initialize_params {
      image = "${var.os_image}"
      size = "${var.compute_boot_disk_size}"
      type = "${var.compute_boot_disk_type}"
    }
  }

  attached_disk = {
    source = "${var.cluster_id}-compute-${count.index}-containers"
    device_name = "${var.cluster_id}-compute-${count.index}-containers"
    mode = "READ_WRITE"
  }

  attached_disk = {
    source = "${var.cluster_id}-compute-${count.index}-local"
    device_name = "${var.cluster_id}-compute-${count.index}-local"
    mode = "READ_WRITE"
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.default.name}"

    access_config {
      // Ephemeral IP
    }
  }

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol"
    ]
  }

  metadata {
    ocp-cluster = "${var.cluster_id}"
    ocp-type = "compute"
  }

  metadata_startup_script = "${data.local_file.compute-node-init-script.content}"

  depends_on = [
    "google_compute_disk.compute-containers",
    "google_compute_disk.compute-local"
  ]
}

#resource "google_compute_instance_template" "master" {
#  name = "${var.cluster_id}-master-template"
#  machine_type = "${var.master_machine_size}"
#  region = "${var.region}"
#
#  network_interface {
#    subnetwork = "${google_compute_subnetwork.default.name}"
#
#    access_config {
#      // Ephemeral IP
#    }
#  }
#
#  // boot disk
#  disk {
#    boot = "true"
#    source_image = "debian-cloud/debian-9"
#  }
#}

#resource "google_compute_instance_group_manager" "master" {
#  name               = "${var.cluster_id}-master-manager"
#  instance_template  = "${google_compute_instance_template.master.self_link}"
#  base_instance_name = "${var.cluster_id}-master"
#  zone               = "${var.zone}"
#  target_size        = "3"
#}

resource "google_compute_health_check" "master-lb-healthcheck" {
  name = "${var.cluster_id}-master-lb-healthcheck"
  timeout_sec = 10
  check_interval_sec = 10
  healthy_threshold = 3
  unhealthy_threshold = 3

  https_health_check {
    port = "443"
    request_path = "/healthz"
 }
}

resource "google_compute_instance_group" "masters-group" {
  name = "${var.cluster_id}-masters-${var.zone}"
  description = "Masters instance group"
  zone = "${var.zone}"

  instances = [
    "${google_compute_instance.master.0.self_link}",
    "${google_compute_instance.master.1.self_link}",
    "${google_compute_instance.master.2.self_link}"
  ]

  named_port {
    name = "ocp-api"
    port = "443"
  }
}

resource "google_compute_backend_service" "master-lb-backend" {
  name = "${var.cluster_id}-master-lb-backend"
  description = "TCP backend service with client IP affinity."
  port_name = "ocp-api"
  protocol = "TCP"
  session_affinity = "CLIENT_IP"

  health_checks = [
    "${google_compute_health_check.master-lb-healthcheck.self_link}"
  ]
}

resource "google_compute_target_tcp_proxy" "master-lb-target-proxy" {
  name = "${var.cluster_id}-master-lb-target-proxy"
  description = "Disabling proxy headers."
  backend_service = "${google_compute_backend_service.master-lb-backend.self_link}"
  proxy_header = "NONE"
}

resource "google_compute_global_forwarding_rule" "master-lb-forwarding-rule" {
  name = "${var.cluster_id}-master-lb-forwarding-rule"
  ip_address = "${google_compute_global_address.master-lb.address}"
  target = "${google_compute_target_tcp_proxy.master-lb-target-proxy.self_link}"
  port_range = "443"
}

resource "google_compute_firewall" "healthcheck-to-lb" {
  name = "${var.cluster_id}-healthcheck-to-lb"
  network = "${google_compute_network.default.name}"
  direction = "INGRESS"
  priority = "1000"

  allow {
    protocol = "tcp"
    ports = ["443"]
  }

  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16"
  ]

  target_tags = [
    "${var.cluster_id}-master"
  ]
}

resource "google_compute_http_health_check" "infra-lb-healthcheck" {
  name = "${var.cluster_id}-infra-lb-healthcheck"
  timeout_sec = 10
  check_interval_sec = 10
  healthy_threshold = 3
  unhealthy_threshold = 3
  port = "1936"
  request_path = "/healthz"
}

resource "google_compute_target_pool" "infra-pool" {
  name = "${var.cluster_id}-infra-pool"

  instances = [
    "${var.zone}/${var.cluster_id}-infra-0",
    "${var.zone}/${var.cluster_id}-infra-1",
    "${var.zone}/${var.cluster_id}-infra-2"
  ]

  health_checks = [
    "${google_compute_http_health_check.infra-lb-healthcheck.self_link}",
  ]
}

resource "google_compute_forwarding_rule" "infra-http" {
  name = "${var.cluster_id}-infra-http"
  ip_address = "${google_compute_address.apps-lb.address}"
  region = "${var.region}"
  target = "${google_compute_target_pool.infra-pool.self_link}"
  port_range = "80"
}

resource "google_compute_forwarding_rule" "infra-https" {
  name = "${var.cluster_id}-infra-https"
  ip_address = "${google_compute_address.apps-lb.address}"
  region = "${var.region}"
  target = "${google_compute_target_pool.infra-pool.self_link}"
  port_range = "443"
}

resource "google_storage_bucket" "registry" {
  name = "${var.cluster_id}-registry"
  storage_class = "REGIONAL"
  location = "${var.region}"
  force_destroy = "true"

  labels = {
    ocp-cluster = "${var.cluster_id}"
  }
}
