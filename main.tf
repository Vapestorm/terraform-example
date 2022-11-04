terraform {
    required_providers {
        digitalocean = {
            source = "digitalocean/digitalocean"
            version = "~> 2.0"
        }
        cloudflare = {
            source = "cloudflare/cloudflare"
            version = "~> 3.0"
        }
    }
    required_version = "~> 1.3"
}

resource "digitalocean_ssh_key" "sshkey" {
    name = "terraform"
    public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "digitalocean_droplet" "droplet" {
    count = var.droplet_number_of_droplets
    image = var.droplet_os_image
    name = "${var.droplet_country}-${var.droplet_datacenter}-${var.droplet_project}-${var.droplet_environment}-${var.droplet_purpose}-${format("%03d", count.index + 1)}.${var.cloudflare_tld}"
    region = var.droplet_datacenter
    tags = concat(
        var.droplet_tags,
        tolist(["terraform"]),
        tolist([var.droplet_country]),
        tolist([var.droplet_datacenter]),
        tolist([var.droplet_project]),
        tolist([var.droplet_environment]),
        tolist([var.droplet_purpose]),
    )
    size = var.droplet_size
    resize_disk = var.droplet_increase_disk
    ipv6 = true
    monitoring = var.droplet_enable_monitoring
    ssh_keys = ["${digitalocean_ssh_key.sshkey.fingerprint}"]
}

resource "digitalocean_domain" "domain" {
    name = var.cloudflare_tld
    ip_address = digitalocean_droplet.droplet[0].ipv4_address
}

resource "digitalocean_record" "www" {
    domain = "${digitalocean_domain.domain.name}"
    type = "A"
    name = "${var.droplet_project}"
    ttl = "10"
    value = "${digitalocean_droplet.droplet[0].ipv4_address}"
}

data "cloudflare_zones" "domain" {
    filter {
        name = var.cloudflare_tld
    }
}

resource "cloudflare_record" "droplet-a" {
    count = var.droplet_number_of_droplets
    zone_id = data.cloudflare_zones.domain.zones[0].id
    name = "${var.droplet_country}-${var.droplet_datacenter}-${var.droplet_project}-${var.droplet_environment}-${var.droplet_purpose}-${format("%03d", count.index + 1)}.${var.cloudflare_tld}"
    value = element(digitalocean_droplet.droplet.*.ipv4_address, count.index)
    type = "A"
    proxied = "false"
    ttl = 3600
}

resource "cloudflare_record" "droplet-aaaa" {
    count = var.droplet_number_of_droplets
    zone_id = data.cloudflare_zones.domain.zones[0].id
    name = "${var.droplet_country}-${var.droplet_datacenter}-${var.droplet_project}-${var.droplet_environment}-${var.droplet_purpose}-${format("%03d", count.index + 1)}.${var.cloudflare_tld}"
    value = element(digitalocean_droplet.droplet.*.ipv6_address, count.index)
    type = "AAAA"
    proxied = "false"
    ttl = 3600
}






