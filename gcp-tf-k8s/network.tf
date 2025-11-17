resource "google_compute_network" "vpc_k8s" {
  name                    = "vpc-k8s"
  mtu                     = 1450
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet_controlplane" {
  name                     = "subnet-controlplane"
  ip_cidr_range            = "10.10.1.0/24"
  network                  = google_compute_network.vpc_k8s.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "subnet_workers" {
  name                     = "subnet-workers"
  ip_cidr_range            = "10.10.2.0/24"
  network                  = google_compute_network.vpc_k8s.id
  private_ip_google_access = true
}

resource "google_compute_firewall" "firewall_k8s" {
  name    = "firewall-k8s"
  network = google_compute_network.vpc_k8s.id

  allow {
    protocol = "tcp"
    ports    = [22]
  }

  source_ranges = ["35.235.240.0/20"]

  direction = "INGRESS"
  priority  = 1000
}
