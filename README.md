# DevSecOps Splunk Lab

Homelab DevSecOps environment for deploying and managing **Splunk Enterprise on Kubernetes (K3s)** using **Terraform, Ansible, Helm, Azure DevOps Pipelines, and Nexus Repository**.

The project is designed as a hands-on environment for infrastructure automation, CI/CD, Kubernetes, Splunk administration, observability, and security engineering.

---

## Architecture

```text
                         GitHub
                           |
                           v
                  Azure DevOps Pipelines
                           |
                           v
                 Self-Hosted DevOps Agent
                     Controller VM
                           |
             +-------------+-------------+
             |                           |
             v                           v
         Terraform                    Ansible
             |                           |
             v                           v
          Proxmox ------------------> K3s Cluster
                                         |
                   +---------------------+---------------------+
                   |                     |                     |
                   v                     v                     v
             Splunk Operator          Splunk CRDs           SC4S
                   |                     |
                   |             +-------+-------+
                   |             |               |
                   v             v               v
              Kubernetes   License Manager   Splunk Enterprise

                           K3s Platform
                                |
          +---------------------+----------------------+
          |                     |                      |
          v                     v                      v
        Kong                  Nexus              Monitoring
      Ingress            Docker Registry      Prometheus/Grafana
```

---

## Technology Stack

| Area | Technologies |
|---|---|
| Virtualization | Proxmox VE |
| Infrastructure as Code | Terraform |
| Configuration Management | Ansible |
| Kubernetes | K3s |
| Package Management | Helm |
| CI/CD | Azure DevOps Pipelines |
| Source Control | GitHub |
| Container Registry | Nexus Repository |
| SIEM | Splunk Enterprise |
| Kubernetes Integration | Splunk Operator for Kubernetes |
| Syslog Ingestion | Splunk Connect for Syslog (SC4S) |
| Ingress | Kong |
| Load Balancing | MetalLB |
| Monitoring | Prometheus, Grafana, Alertmanager |
| Automation | Azure DevOps self-hosted agent |
| Workflow Automation | n8n |
| AI / MCP | MCP Server, n8n MCP integration |

---

## Main Features

- Automated K3s cluster deployment.
- Terraform-based VM provisioning on Proxmox.
- Ansible-based Kubernetes and Splunk deployment.
- Splunk Operator deployment using Helm.
- Splunk Enterprise deployment through Kubernetes CRDs.
- Splunk License Manager deployment.
- Splunk Search Head and Indexer deployment workflows.
- SC4S deployment for syslog ingestion.
- Nexus private Docker registry.
- Kong ingress and MetalLB load balancing.
- Prometheus and Grafana monitoring stack.
- Rancher Kubernetes management.
- Cloudflare Tunnel integration.
- Automated n8n deployment with custom MCP community nodes.
- Azure DevOps CI/CD using a self-hosted Linux agent.
- Splunk application deployment and automation.

---

## CI/CD Workflow

```text
Developer
    |
    v
Git Push
    |
    v
GitHub Repository
    |
    v
Azure DevOps Pipeline
    |
    v
Self-Hosted Agent
    |
    +--> Terraform
    |
    +--> Ansible
    |
    +--> Helm / kubectl
    |
    +--> Docker Build
    |
    +--> Nexus Registry
    |
    v
K3s Cluster
```

Azure DevOps pipelines are used to automate infrastructure and application deployments.

Examples include:

- K3s cluster deployment
- Splunk Operator deployment
- Splunk Enterprise deployment
- Splunk License Manager
- Search Heads
- Indexers
- SC4S
- Monitoring stack
- Rancher
- Nexus
- Cloudflare Tunnel
- n8n
- MCP Server
- Splunk application deployment

---

## Repository Structure

```text
devsecops-splunk/
│
├── azure-pipelines/
│   ├── Azure-Pipelines-deploy-k3s-cluster.yml
│   ├── Azure-Pipelines-deploy-Splunk-Operator.yml
│   ├── Azure-Pipelines-deploy-splunk-standalone.yml
│   ├── Azure-Pipelines-deploy-splunk-LM.yml
│   ├── Azure-Pipelines-deploy-splunk-SH.yml
│   ├── Azure-Pipelines-deploy-splunk-IDX.yml
│   ├── Azure-Pipelines-deploy-sc4s.yml
│   ├── Azure-Pipelines-deploy-stack-monitoring.yml
│   ├── Azure-Pipelines-install-nexus.yml
│   ├── Azure-Pipelines-deploy-rancher.yml
│   ├── Azure-Pipelines-n8n-deploy.yml
│   └── Azure-Pipelines-deploy-MCP-server.yml
│
├── infrastructure/
│   │
│   ├── ansible/
│   │   ├── inventories/
│   │   ├── playbooks/
│   │   ├── roles/
│   │   ├── ansible.cfg
│   │   └── requirements.yml
│   │
│   ├── helm/
│   │   └── n8n/
│   │       ├── templates/
│   │       ├── Chart.yaml
│   │       └── values.yaml
│   │
│   └── terraform/
│
├── splunk-apps/
│
└── README.md
```

---

## Deployment Model

The environment uses a dedicated **controller VM** containing:

- Azure DevOps self-hosted agent
- Ansible
- Terraform
- Helm
- kubectl
- Docker
- Kubernetes configuration

The controller executes Azure DevOps pipelines and manages the K3s environment.

Typical deployment flow:

```text
Azure DevOps
     |
     v
Controller VM
     |
     +--> Ansible
     +--> Terraform
     +--> Helm
     +--> kubectl
     |
     v
K3s Cluster
```

---

## Splunk Architecture

Splunk workloads are deployed on Kubernetes using the **Splunk Operator**.

The lab supports multiple Splunk deployment patterns:

```text
Splunk Operator
      |
      +--> License Manager
      |
      +--> Standalone
      |
      +--> Monitoring Console
      |
      +--> Search Heads
      |
      +--> Indexers
```

SC4S provides centralized syslog collection and forwards events to Splunk.

---

## Container Registry

The lab uses **Nexus Repository** as its private Docker registry.

Example:

```text
10.0.0.110:8082
```

Custom container images can be:

```text
Build
  |
  v
Azure DevOps Agent
  |
  v
Nexus Repository
  |
  v
K3s
```

For example, the n8n pipeline builds a customized n8n image containing MCP community nodes, pushes it to Nexus, and deploys it through Ansible and Helm.

---

## Example Commands

Check the Kubernetes cluster:

```bash
kubectl get nodes
```

Check Splunk resources:

```bash
kubectl get pods -n splunk
```

Check Splunk Operator:

```bash
kubectl get pods -n splunk-operator
```

Check SC4S:

```bash
kubectl get pods -n sc4s
```

Check n8n:

```bash
kubectl get pods -n n8n
```

Run an Ansible playbook:

```bash
cd infrastructure/ansible

ansible-playbook playbooks/30-deploy-splunk-operator.yml
```

---

## Security

Sensitive information must not be stored directly in Git.

Secrets are managed through mechanisms such as:

- Azure DevOps variable groups
- Ansible Vault
- Kubernetes Secrets
- Registry credentials
- Environment variables

Files containing credentials, API keys, kubeconfig files, certificates, or private keys must remain excluded through `.gitignore`.

---

## Skills Demonstrated

This project demonstrates practical experience with:

- Splunk Enterprise administration
- Splunk on Kubernetes
- Splunk Operator
- Splunk Connect for Syslog
- Kubernetes administration
- Infrastructure as Code
- Terraform
- Ansible
- Helm
- Docker
- Nexus Repository
- Azure DevOps
- CI/CD pipeline design
- Git
- Linux administration
- Kubernetes networking
- Observability
- DevSecOps automation

---

## Lab Environment

This repository represents a **personal DevSecOps homelab** used for learning, testing, automation, and technical demonstrations.

It is not intended to be deployed directly into a production environment without additional security, availability, backup, and operational controls.

---

## Author

**Hatem Nouairi**

Senior Splunk / DevSecOps Consultant

Technologie SécuriSys Inc.

Specialties:

- Splunk Enterprise & Splunk Cloud
- SIEM Engineering
- Kubernetes
- DevSecOps
- Azure DevOps
- Terraform
- Ansible
- Security Automation

---

## License

This project is licensed under the MIT License.