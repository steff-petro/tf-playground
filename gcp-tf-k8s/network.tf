resource "google_compute_network" "vpc_k8s" {
  name                    = "vpc-k8s"
  mtu                     = 1450
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet_controlplane" {
  name                     = "subnet-controlplane"
  ip_cidr_range            = var.cidr_controlplane_subnet
  network                  = google_compute_network.vpc_k8s.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "subnet_workers" {
  name                     = "subnet-workers"
  ip_cidr_range            = var.cidr_workers_subnet
  network                  = google_compute_network.vpc_k8s.id
  private_ip_google_access = true
}

resource "google_compute_firewall" "firewall_k8s" {
  name      = "firewall-k8s"
  network   = google_compute_network.vpc_k8s.id
  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = [22]
  }

  source_ranges = ["35.235.240.0/20"]

}

resource "google_compute_firewall" "firewall_k8s_control_plane" {
  name        = "firewall-k8s-control-plane"
  network     = google_compute_network.vpc_k8s.id
  direction   = "INGRESS"
  target_tags = ["control-plane-node"]

  allow {
    protocol = "tcp"
    ports    = ["6443"]
  }
  allow {
    protocol = "udp"
    ports    = ["8472"]
  }

  allow {
    protocol = "tcp"
    ports    = ["2379-2380"]
  }

  allow {
    protocol = "tcp"
    ports    = ["10250"]
  }

  allow {
    protocol = "tcp"
    ports    = ["10259"]
  }

  allow {
    protocol = "tcp"
    ports    = ["10257"]
  }

  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }

  allow {
    protocol = "udp"
    ports    = ["30000-32767"]
  }
  allow {
    protocol = "tcp"
    ports    = ["4240"]
  }
  allow {
    protocol = "icmp"
  }

  source_ranges = [
    var.cidr_workers_subnet,
    var.cidr_controlplane_subnet
  ]
}

resource "google_compute_firewall" "k8s_worker_internal" {
  name        = "firewall-k8s-worker-internal"
  network     = google_compute_network.vpc_k8s.id
  direction   = "INGRESS"
  target_tags = ["worker-node"]

  allow {
    protocol = "udp"
    ports    = ["8472"]
  }

  allow {
    protocol = "tcp"
    ports    = ["10250"]
  }

  allow {
    protocol = "tcp"
    ports    = ["10256"]
  }
  allow {
    protocol = "tcp"
    ports    = ["4240"]
  }
  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }

  allow {
    protocol = "udp"
    ports    = ["30000-32767"]
  }
  allow {
    protocol = "icmp"
  }
  source_ranges = [
    var.cidr_workers_subnet,
    var.cidr_controlplane_subnet
  ]
}



resource "google_compute_router" "router" {
  name    = "router"
  network = google_compute_network.vpc_k8s.id
  bgp {
    asn = 64514
  }
}


resource "google_compute_router_nat" "nat" {
  name                               = "nat"
  router                             = google_compute_router.router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
