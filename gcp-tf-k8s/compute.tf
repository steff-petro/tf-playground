resource "google_compute_instance" "node_control_plane" {
  name           = "node-control-plane"
  machine_type   = "e2-standard-2"
  desired_status = var.vm_state
  tags           = ["control-plane-node"]

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-jammy-v20251111"
      size  = 60
      type  = "pd-ssd"
    }
    auto_delete = true
  }

  network_interface {
    network    = google_compute_network.vpc_k8s.id
    subnetwork = google_compute_subnetwork.subnet_controlplane.id
  }
}

resource "google_compute_instance" "node_worker" {
  count          = 2
  name           = "worker-${count.index + 1}"
  machine_type   = "e2-standard-2"
  desired_status = var.vm_state
  tags           = ["worker-node"]

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-jammy-v20251111"
      size  = 60
      type  = "pd-ssd"
    }
    auto_delete = true
  }

  network_interface {
    network    = google_compute_network.vpc_k8s.id
    subnetwork = google_compute_subnetwork.subnet_workers.id
  }
}
