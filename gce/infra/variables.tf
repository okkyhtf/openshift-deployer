variable "project" {
  default = "rht-id-ocp-labs"
}
variable "region" {
  default = "asia-southeast1"
}
variable "zone" {
  default = "asia-southeast1-b"
}
variable "cluster_id" {
  default = "demo10447"
}
variable "subnetwork_cidr" {
  default = "10.240.0.0/24"
}

variable "os_image" {
  default = "rht-id-ocp-labs/demo10447-rhel-image"
}

variable "bastion_machine_size" {
  default = "n1-standard-1"
}

variable "bastion_boot_disk_size" {
  default = "20"
}

variable "bastion_boot_disk_type" {
  default = "pd-standard"
}

variable "master_count" {
  default = 3
}

variable "master_machine_size" {
  default = "n1-standard-1"
}

variable "master_boot_disk_size" {
  default = "20"
}

variable "master_boot_disk_type" {
  default = "pd-standard"
}

variable "master_etcd_disk_type" {
  default = "pd-standard"
}

variable "master_etcd_disk_size" {
  default = "20"
}

variable "master_containers_disk_type" {
  default = "pd-standard"
}

variable "master_containers_disk_size" {
  default = "20"
}

variable "master_local_disk_type" {
  default = "pd-standard"
}

variable "master_local_disk_size" {
  default = "20"
}

variable "infra_count" {
  default = 3
}

variable "infra_machine_size" {
  default = "n1-standard-1"
}

variable "infra_boot_disk_size" {
  default = "20"
}

variable "infra_boot_disk_type" {
  default = "pd-standard"
}

variable "infra_containers_disk_type" {
  default = "pd-standard"
}

variable "infra_containers_disk_size" {
  default = "20"
}

variable "infra_local_disk_type" {
  default = "pd-standard"
}

variable "infra_local_disk_size" {
  default = "20"
}

variable "compute_count" {
  default = 3
}

variable "compute_machine_size" {
  default = "n1-standard-1"
}

variable "compute_boot_disk_size" {
  default = "20"
}

variable "compute_boot_disk_type" {
  default = "pd-standard"
}

variable "compute_containers_disk_type" {
  default = "pd-standard"
}

variable "compute_containers_disk_size" {
  default = "20"
}

variable "compute_local_disk_type" {
  default = "pd-standard"
}

variable "compute_local_disk_size" {
  default = "20"
}
