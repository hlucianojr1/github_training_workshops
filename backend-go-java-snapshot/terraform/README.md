# High Scores Demo - Terraform Infrastructure

This directory contains Terraform configurations for deploying the High Scores application to Kubernetes, supporting both local development (Rancher Desktop) and cloud deployment (Azure AKS).

## Architecture Overview

```
┌─────────────────────────────────────────────────┐
│                   Ingress                        │
│     (Traefik/Nginx/App Gateway)                 │
└─────────────────┬───────────────────────────────┘
                  │
        ┌─────────┴─────────┐
        │                   │
┌───────▼────────┐  ┌───────▼────────┐
│   Frontend     │  │    Backend     │
│ React + Nginx  │  │  Spring Boot   │
│    (Port 80)   │  │   (Port 8080)  │
└────────────────┘  └────────┬───────┘
                             │
                    ┌────────▼────────┐
                    │   PostgreSQL    │
                    │  (StatefulSet   │
                    │ or Azure Managed)│
                    └─────────────────┘
```

## Directory Structure

```
terraform/
├── modules/                  # Reusable Terraform modules
│   ├── backend/             # Spring Boot deployment
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── frontend/            # React + Nginx deployment
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── database/            # PostgreSQL (StatefulSet or RDS)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── ingress/             # Ingress routing configuration
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── environments/            # Environment-specific configurations
│   ├── local/              # Rancher Desktop setup
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── outputs.tf
│   └── azure/              # Azure AKS + PostgreSQL setup
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars.example
│       └── outputs.tf
└── README.md               # This file
```

## Prerequisites

### Common Requirements
- Terraform >= 1.0
- Docker
- kubectl

### Local Development (Rancher Desktop)
- [Rancher Desktop](https://rancherdesktop.io/) installed and running
- Kubernetes enabled in Rancher Desktop
- At least 4GB RAM allocated to Rancher Desktop

### Azure Cloud Deployment
- Azure CLI configured with appropriate credentials
- An existing AKS cluster
- Azure resource group
- Firewall rules configured for PostgreSQL access
- (Optional) Azure Key Vault for secrets
- (Optional) Nginx Ingress Controller or Application Gateway Ingress Controller

## Getting Started

### 1. Build Docker Images

First, build the Docker images for both applications:

```bash
# Navigate to project root
cd /path/to/high-scores-demo

# Build backend image
cd java-spring-boot-backend
docker build -t highscores-backend:latest .

# Build frontend image
cd ../react-frontend
docker build -t highscores-frontend:latest .
```

### 2. Choose Your Environment

#### Option A: Local Development (Rancher Desktop)

1. **Ensure Rancher Desktop is running**
   ```bash
   kubectl config current-context
   # Should show: rancher-desktop
   ```

2. **Navigate to local environment**
   ```bash
   cd terraform/environments/local
   ```

3. **Initialize Terraform**
   ```bash
   terraform init
   ```

4. **Review and customize variables**
   Edit `terraform.tfvars` if needed:
   ```hcl
   database_password = "your-secure-password"
   domain_name = "highscores.local"
   ```

5. **Deploy**
   ```bash
   terraform plan
   terraform apply
   ```

6. **Access the application**
   ```bash
   # Add to /etc/hosts
   echo "127.0.0.1 highscores.local" | sudo tee -a /etc/hosts
   
   # Get access information
   terraform output access_instructions
   
   # If using port-forward:
   kubectl port-forward -n highscores-local svc/highscores-frontend 3000:80
   # Visit: http://localhost:3000
   ```

#### Option B: Azure Cloud Deployment

1. **Set up Azure prerequisites**
   - Create or identify your AKS cluster
   - Create resource group
   - Configure network security
   - (Optional) Configure Azure Key Vault

2. **Configure Azure credentials**
   ```bash
   az login
   # Or use service principal
   export ARM_CLIENT_ID="your-client-id"
   export ARM_CLIENT_SECRET="your-client-secret"
   export ARM_SUBSCRIPTION_ID="your-subscription-id"
   export ARM_TENANT_ID="your-tenant-id"
   ```

3. **Push images to ACR**
   ```bash
   # Login to ACR
   az acr login --name myregistry
   
   # Create repositories (automatically created on first push)
   # Tag and push images
   docker tag highscores-backend:latest \
     myregistry.azurecr.io/highscores-backend:latest
   docker push myregistry.azurecr.io/highscores-backend:latest
   
   docker tag highscores-frontend:latest \
     myregistry.azurecr.io/highscores-frontend:latest
   docker push myregistry.azurecr.io/highscores-frontend:latest
   ```

4. **Configure Terraform**
   ```bash
   cd terraform/environments/azure
   
   # Copy example configuration
   cp terraform.tfvars.example terraform.tfvars
   
   # Edit terraform.tfvars with your values
   vi terraform.tfvars
   ```

5. **Configure remote state (recommended)**
   ```bash
   # Create storage account and container for state
   az group create --name terraform-state-rg --location eastus
   
   az storage account create \
     --name tfstatestore12345 \
     --resource-group terraform-state-rg \
     --location eastus \
     --sku Standard_LRS
   
   az storage container create \
     --name tfstate \
     --account-name tfstatestore12345
   
   # Edit main.tf backend configuration
   ```

6. **Initialize and deploy**
   ```bash
   terraform init
   
   # Set database password via environment variable
   export TF_VAR_database_password="your-secure-password"
   
   # Plan and apply
   terraform plan
   terraform apply
   ```

7. **Configure DNS**
   ```bash
   # Get Load Balancer IP
   kubectl get ingress -n highscores-prod
   
   # Create A record in Azure DNS or your DNS provider
   # Point your domain to the Load Balancer IP
   ```

8. **Access the application**
   ```bash
   # View output instructions
   terraform output access_instructions
   
   # Visit: https://your-domain.com
   ```

## Module Documentation

### Backend Module

Deploys the Spring Boot application with:
- Kubernetes Deployment with configurable replicas
- ClusterIP Service
- ConfigMap for configuration
- Secret for database credentials
- Health probes (liveness, readiness, startup)
- Optional Horizontal Pod Autoscaler
- Resource requests and limits

**Key Variables:**
- `image`: Docker image for backend
- `database_url`: JDBC connection URL
- `replicas`: Number of pod replicas
- `enable_autoscaling`: Enable HPA

### Frontend Module

Deploys the React application with nginx with:
- Kubernetes Deployment
- ClusterIP Service
- Environment variable injection for API URL
- Health probes
- Optional Horizontal Pod Autoscaler
- Resource requests and limits

**Key Variables:**
- `image`: Docker image for frontend
- `backend_url`: Internal backend service URL
- `replicas`: Number of pod replicas

### Database Module

Deploys PostgreSQL with two deployment options:

**Local (StatefulSet):**
- PostgreSQL StatefulSet
- Persistent Volume Claim
- Headless and ClusterIP services
- Kubernetes Secret for credentials

**Cloud (Azure PostgreSQL Flexible Server):**
- Azure Database for PostgreSQL Flexible Server
- Automated backups
- Encryption at rest
- Firewall rules
- High availability options

**Key Variables:**
- `use_statefulset`: Use StatefulSet (local)
- `use_azure_postgres`: Use Azure managed database (cloud)
- `database_name`: Database name
- `postgres_sku_name`: PostgreSQL SKU

### Ingress Module

Configures ingress routing with:
- Path-based routing (`/api` → backend, `/` → frontend)
- Optional TLS/HTTPS
- Configurable ingress class (nginx, traefik, alb)
- Custom annotations support
- Optional Network Policy

**Key Variables:**
- `domain_name`: Application domain
- `ingress_class`: Ingress controller type (nginx, azure/application-gateway)
- `enable_tls`: Enable HTTPS
- `backend_service_name`: Backend service
- `frontend_service_name`: Frontend service

## Environment Variables

### Backend (Spring Boot)
- `SPRING_PROFILES_ACTIVE`: Spring profile (prod/default)
- `DATABASE_URL`: JDBC connection URL
- `DATABASE_USERNAME`: Database username
- `DATABASE_PASSWORD`: Database password
- `PORT`: Server port (default: 8080)

### Frontend (React + Nginx)
- `BACKEND_URL`: Backend service URL (injected by nginx)

## Resource Requirements

### Local Development
- **Backend**: 250m CPU, 512Mi RAM (request) / 1 CPU, 1Gi RAM (limit)
- **Frontend**: 100m CPU, 128Mi RAM (request) / 500m CPU, 256Mi RAM (limit)
- **Database**: 250m CPU, 512Mi RAM (request) / 1 CPU, 1Gi RAM (limit)

### Azure Production
- **Backend**: Configurable via variables, defaults same as local
- **Frontend**: Configurable via variables, defaults same as local
- **Database**: Azure PostgreSQL with B_Standard_B1ms (or configured SKU)

## Scaling

### Manual Scaling
```bash
# Scale backend
kubectl scale deployment highscores-backend -n <namespace> --replicas=3

# Scale frontend
kubectl scale deployment highscores-frontend -n <namespace> --replicas=3
```

### Horizontal Pod Autoscaler (Azure)
Enabled by default in Azure environment:
- **Backend**: 2-10 replicas based on 70% CPU / 80% memory
- **Frontend**: 2-10 replicas based on 70% CPU / 80% memory

Configure via variables:
```hcl
enable_autoscaling = true
backend_autoscaling_min = 2
backend_autoscaling_max = 10
```

## Monitoring and Debugging

### View Pod Status
```bash
kubectl get pods -n <namespace>
kubectl describe pod <pod-name> -n <namespace>
```

### View Logs
```bash
# Backend logs
kubectl logs -n <namespace> -l app=highscores-backend -f

# Frontend logs
kubectl logs -n <namespace> -l app=highscores-frontend -f

# Database logs (StatefulSet only)
kubectl logs -n <namespace> -l app=highscores-postgres -f
```

### Access Database
```bash
# Port forward to database (local)
kubectl port-forward -n <namespace> svc/highscores-postgres 5432:5432

# Connect with psql
psql -h localhost -U postgres -d highscores
```

### Check Health Endpoints
```bash
# Backend health
kubectl port-forward -n <namespace> svc/highscores-backend 8080:8080
curl http://localhost:8080/actuator/health

# Frontend health
kubectl port-forward -n <namespace> svc/highscores-frontend 8080:80
curl http://localhost:8080/health
```

## Troubleshooting

### Pods Not Starting
1. Check events: `kubectl describe pod <pod-name> -n <namespace>`
2. Verify image exists: `docker images | grep highscores`
3. Check resource limits: `kubectl top pods -n <namespace>`

### Database Connection Issues
1. Verify database is running: `kubectl get pods -n <namespace> -l app=highscores-postgres`
2. Check database logs: `kubectl logs -n <namespace> -l app=highscores-postgres`
3. Verify connection string in backend pod
4. For Azure PostgreSQL: Check firewall rules allow traffic from AKS

### Ingress Not Working
1. Verify ingress controller is installed
2. Check ingress status: `kubectl get ingress -n <namespace>`
3. For Rancher Desktop: Ensure traefik is running
4. For Azure: Check Load Balancer is provisioned in Azure Portal

### Images Not Pulling
1. Local: Verify images exist locally
2. Azure: Verify ACR permissions and image exists
3. Check image pull policy: `kubectl describe pod <pod-name> -n <namespace>`

## Cleanup

### Local Environment
```bash
cd terraform/environments/local
terraform destroy
```

### Azure Environment
```bash
cd terraform/environments/azure
export TF_VAR_database_password="your-password"
terraform destroy
```

**Note:** Azure PostgreSQL backups are retained based on `backup_retention_days` configuration.

## Security Considerations

1. **Secrets Management**
   - Use Kubernetes Secrets for sensitive data
   - For production, consider Azure Key Vault or HashiCorp Vault
   - Never commit secrets to version control

2. **Network Security**
   - PostgreSQL firewall rules restrict access
   - Virtual network integration available
   - Network policies can be enabled for pod-to-pod communication

3. **Container Security**
   - Images run as non-root users
   - Security contexts defined for all pods
   - Regular image updates recommended

4. **Database Security**
   - Azure PostgreSQL encryption at rest enabled
   - Automated backups configured
   - Use strong passwords

## CI/CD Integration

### Recommended Pipeline

1. **Build Phase**
   ```bash
   docker build -t highscores-backend:${VERSION} ./java-spring-boot-backend
   docker build -t highscores-frontend:${VERSION} ./react-frontend
   ```

2. **Push Phase**
   ```bash
   docker push ${ACR_REPO}/highscores-backend:${VERSION}
   docker push ${ACR_REPO}/highscores-frontend:${VERSION}
   ```

3. **Deploy Phase**
   ```bash
   cd terraform/environments/azure
   terraform apply \
     -var="backend_image=${ACR_REPO}/highscores-backend:${VERSION}" \
     -var="frontend_image=${ACR_REPO}/highscores-frontend:${VERSION}"
   ```

## Cost Optimization (Azure)

- **Development**: Use `B_Standard_B1ms` for PostgreSQL, 1-2 replicas
- **Staging**: Use `GP_Standard_D2s_v3` for PostgreSQL, 2 replicas
- **Production**: Use appropriate PostgreSQL tier, enable autoscaling

Azure PostgreSQL costs can be reduced by:
- Using reserved capacity for production workloads
- Stopping database during non-business hours (dev/test)
- Right-sizing SKU based on metrics
- Configuring appropriate backup retention

## Support and Contributing

For issues or questions:
1. Check the troubleshooting section
2. Review Kubernetes events and logs
3. Consult Terraform documentation

## License

This infrastructure code is part of the High Scores Demo project.
