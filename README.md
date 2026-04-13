# ☁️ Cloud-1 — Automated WordPress Deployment on DigitalOcean

> Deploy a full WordPress stack on a fresh cloud server with a single command. No manual steps. No SSH. No configuration by hand.

---

## 📋 Overview

Cloud-1 is a fully automated cloud infrastructure project built at **42 School**.  
It provisions a DigitalOcean droplet with **Terraform**, then configures and deploys a containerized WordPress stack using **Ansible** and **Docker Compose** — from zero to a running website in one command.

---

## 🏗️ Stack

| Service       | Role                              | Exposure        |
|---------------|-----------------------------------|-----------------|
| **NGINX**     | Reverse proxy + TLS termination   | Port 443 only   |
| **WordPress** | PHP-FPM application server        | Internal (9000) |
| **MariaDB**   | Database                          | Internal (3306) |
| **PHPMyAdmin**| Database management UI            | Internal (9001) |

All services run in isolated Docker containers on a private network. Only NGINX is exposed to the internet.

---

## ⚙️ How It Works

```
terraform apply          # 1. Provision a fresh DigitalOcean droplet
        ↓
ansible-playbook         # 2. Install Docker, configure system
        ↓
docker compose up        # 3. Build and start all containers
        ↓
https://<droplet-ip>     # 4. WordPress is live
```

---

##  Usage

### Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) installed locally
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html) installed locally
- A [DigitalOcean](https://www.digitalocean.com/) account with an API token
- An SSH key registered on DigitalOcean

### 1. Clone the repo

```bash
git clone https://github.com/yamzil/cloud-1.git
cd cloud-1
```

### 2. Configure secrets

```bash
# Terraform credentials
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
# Edit terraform/terraform.tfvars with your DO token and SSH key fingerprint

# App secrets
cp srcs/.env.example srcs/.env
# Edit srcs/.env with your DB credentials and WordPress config
```

### 3. Deploy

```bash
./deploy.sh
```

That's it. The script will:
1. Destroy any existing droplet with the same name
2. Provision a fresh Ubuntu 22.04 droplet
3. Wait for SSH to be available
4. Update the Ansible inventory with the new IP
5. Run the full Ansible playbook
6. Print the URL when done

---

## 📁 Project Structure

```
cloud-1/
├── terraform/               # Infrastructure provisioning (DigitalOcean)
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars     # ← gitignored, create from .example
├── ansible/                 # Server configuration & deployment
│   ├── ansible.cfg
│   ├── inventory.ini
│   ├── playbook.yml
│   └── roles/
│       ├── docker/          # Install Docker + swap
│       ├── deploy/          # Copy files, build & start containers
│       └── tls/             # TLS certificate setup
├── srcs/
│   ├── docker-compose.yml
│   ├── .env                 # ← gitignored, create from .example
│   └── requirements/
│       ├── nginx/           # NGINX + self-signed TLS
│       ├── wordpress/       # PHP-FPM + WP-CLI setup
│       ├── mariadb/         # MariaDB with init script
│       └── phpmyadmin/      # PHPMyAdmin
└── deploy.sh                # One-command full deploy
```

---

## Security

- Only port **443 (HTTPS)** is exposed publicly
- All inter-service communication happens on an **isolated Docker network**
- Database and PHPMyAdmin are **never reachable from outside** the server
- Credentials are managed via **environment variables** (never hardcoded)
- TLS enabled via self-signed certificate (Let's Encrypt optional)

---

## 🛠️ Tech Stack

`Terraform` · `Ansible` · `Docker` · `Docker Compose` · `NGINX` · `WordPress` · `MariaDB` · `PHPMyAdmin` · `DigitalOcean` · `Ubuntu 22.04`

---

## 📚 42 School

This project is part of the 42 School curriculum.  
It builds on concepts from the **Inception** project (Docker/containerization) and extends them to real cloud infrastructure automation.
