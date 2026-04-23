# Terraform Three Tier Infrastructure

I built this project to go deeper into cloud engineering by provisioning a production-grade three tier AWS architecture using modular Terraform. Everything is automated through a GitHub Actions CI/CD pipeline — no manual deployments.

This is the second project in my cloud infrastructure portfolio, building on top of the foundational VPC and RDS setup from my first project.

---

## Architecture

```


```

---

## What Gets Deployed

| Resource | Details |
|----------|---------|
| VPC | `10.0.0.0/16` with DNS hostnames enabled |
| Public Subnets | `10.0.1.0/24` (us-east-1a), `10.0.3.0/24` (us-east-1b) |
| Private Subnets | `10.0.2.0/24` (us-east-1a), `10.0.4.0/24` (us-east-1b) |
| Internet Gateway | Routes inbound traffic into the VPC |
| NAT Gateways | One per AZ — outbound internet for private subnets |
| Application Load Balancer | Distributes traffic across both AZs |
| EC2 Auto Scaling Group | Min 2, Max 4 — scales based on load |
| RDS MySQL Multi-AZ | db.t3.small, Primary us-east-1a, Standby us-east-1b |

---

## How the Pipeline Works

Every push to `main` triggers the GitHub Actions workflow automatically:

```
git push
    ↓
terraform fmt -check
    ↓
terraform validate
    ↓
terraform plan -input=false
    ↓
terraform apply -auto-approve -input=false
```

Destroy is a separate workflow triggered manually only — to prevent accidental deletion.

---

## Project Structure

```
terraform-three-tier/
├── .github/
│   └── workflows/
│       ├── terraform.yml       # auto deploy on push to main
│       └── destroy.yml         # manual trigger only
├── modules/
│   ├── vpc/                    # VPC, subnets, route tables
│   ├── igw/                    # Internet Gateway
│   ├── nat/                    # NAT Gateways + Elastic IPs
│   ├── alb/                    # Application Load Balancer, Target Group, Listener
│   ├── ec2-asg/                # Launch Template, Auto Scaling Group
│   └── rds/                    # RDS MySQL Multi-AZ, subnet group
├── main.tf                     # wires all modules together
├── variables.tf                # all input variables with defaults
├── outputs.tf                  # exposes resource IDs
├── providers.tf                # AWS provider configuration
├── backend.tf                  # S3 remote state + DynamoDB locking
└── version.tf                  # Terraform version constraint
```

---

## Running Locally

**Requirements:**
- Terraform >= 1.5.0
- AWS CLI configured with valid credentials
- AWS account with permissions for VPC, EC2, RDS, ALB, S3, DynamoDB

```bash
# Clone the repo
git clone https://github.com/Tettano/terraform-three-tier.git
cd terraform-three-tier

# Copy and fill in your variables
cp terraform.tfvars.example terraform.tfvars

# Deploy
terraform init
terraform plan -input=false
terraform apply -input=false
```

---

## GitHub Actions Setup

Add these secrets to your repo under **Settings → Secrets and variables → Actions**:

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS access key |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key |
| `TF_VAR_USERNAME` | RDS database username |
| `TF_VAR_PASSWORD` | RDS database password |

---

## Destroying the Infrastructure

To avoid AWS charges, destroy when done:

```bash
# Locally
terraform destroy -auto-approve -input=false
```

Or go to **GitHub Actions → Terraform Destroy → Run workflow** to trigger from the pipeline.

---

## What I Learned Building This

This project was more complex than my first and hit several real engineering challenges:

- Three tier security — ALB accepts traffic from the internet, EC2 only accepts traffic from ALB, RDS only accepts traffic from EC2. Each layer is isolated from everything it doesn't need.
- NAT Gateway dependency ordering — Terraform doesn't always destroy resources in the right order. Used `depends_on` to explicitly tell it to destroy NAT Gateways before the Internet Gateway, otherwise the IGW detach fails with a dependency violation.
- RDS Multi-AZ requires subnets in at least two availability zones — AWS enforces this at the API level and will reject your subnet group if both subnets are in the same AZ.
- Auto Scaling Groups need a Launch Template, not just an EC2 instance — the template defines the blueprint and the ASG manages the actual instances.
- State lock corruption — a cancelled pipeline left a malformed lock entry in DynamoDB that Terraform couldn't read. Had to manually delete it from the DynamoDB console to recover.

---

## Cost Estimate

| Resource | Cost |
|----------|------|
| NAT Gateway x2 | ~$64/month |
| ALB | ~$16/month |
| EC2 t2.micro x2 | ~$17/month |
| RDS db.t3.small Multi-AZ | ~$48/month |
| **Total** | **~$145/month** |

Always destroy after learning to avoid unexpected charges.

---

## Author

**Shawn Mark Retes**
Philippines 🇵🇭 — transitioning into Cloud and DevOps engineering
GitHub: [@Tettano](https://github.com/Tettano)
