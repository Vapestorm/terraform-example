variable "do_token" {
  description = "DigitalOcean API token"
  type = string
  sensitive = true
}

variable "ssh_public_key" {
  description = "Fingerprint related to public SSH keys"
  type = list(string)
  sensitive = true
}

variable "droplet_number_of_droplets" {
  description = "Number of droplets to create"
  type = number
  default = 1
}

variable "droplet_os_image" {
  description = "Operating system image to use"
  type = string
  default = "ubuntu-22-04-x64"
}

variable "droplet_country" {
  description = "Country where the droplet will be located"
  type = string
  default = "us"
}

variable "droplet_datacenter" {
  description = "Datacenter where the droplet will be located"
  type = string
  default = "nyc"
}

variable "droplet_project" {
  description = "Name of the project the droplet belongs to. Optional (just for naming, e.g. 'myproject')"
  type = string
  default = "myproject"
}

variable "droplet_environment" {
  description = "Environment associated to the droplet. (dev, stage, prod, etc.)"
  type = string
  default = "dev"
}

variable "droplet_purpose" {
  description = "Purpose of the droplet"
  type = string
  default = "server"
}

variable "droplet_tags" {
  description = "Tags to add to the droplet"
  type = list(string)
  default = []
}

variable "droplet_size" {
  description = "Size of the virtual machine - e.g. s-1vcpu-1gb"
  type = string
  default = "s-1vcpu-1gb"
}

variable "droplet_increase_disk" {
  description = "Resize disk when creating the droplet"
  type = bool
  default = false
}

variable "droplet_enable_monitoring" {
  description = "Enable monitoring for the droplet"
  type = bool
  default = false
}

variable "do_inbound_rules" {
  description = "List of inbound rules to apply to the droplet - e.g. [{from_port = 22, to_port = 22, protocol = \"tcp\", ... etc.}]"
  /*type = list(object({
    from_port = number
    to_port = number
    protocol = string
    cidr_blocks = list(string)
    ipv6_cidr_blocks = list(string)
    prefix_list_ids = list(string)
    security_groups = list(string)
    self = bool
    description = string
  }))*/ # For simple rules, just use a list of strings
  type = list(string)
  default = []
}

# Let's define a variable for the Cloudflare API token

variable "cloudflare_email" {
  description = "The email address associated with your Cloudflare account"
  type = string
  sensitive = true
}

variable "cloudflare_api_key" {
  description = "The API key associated with your Cloudflare account"
  type = string
  sensitive = true
}

variable "cloudflare_tld" {
  description = "The top-level domain to use for the droplet"
  type = string
}
  


# In case you want to use .env files as a source of variables, uncomment the following lines

/*locals {
    envs = {
        for tuple in regexall("(.*)=(.*)", file(".env")) : tuple[0] => sensitive(tuple[1])
    }
}*/