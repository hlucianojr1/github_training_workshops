# High Scores Demo

A full-stack application for tracking game high scores, featuring a Java Spring Boot backend and React frontend. This project demonstrates modern containerization and Kubernetes deployment practices with support for both local development (Rancher Desktop) and cloud deployment (Azure AKS).

## 🚀 Quick Start

### Local Development (No Kubernetes)

**Java Backend:**
```bash
cd java-spring-boot-backend
./gradlew bootRun
# Runs on http://localhost:8080
```

**Go Backend:**
```bash
cd go-backend
go run main.go
# Runs on http://localhost:8081
```

**Frontend (Vite-based):**
```bash
cd frontend
npm install
npm run dev
# Opens in browser at http://localhost:5173
```

### Docker Compose (Recommended for Local Testing)

```bash
# Start all services (Java backend, Go backend, and frontend)
docker-compose up --build

# Access the application
# Frontend: http://localhost:3000
# Java Backend: http://localhost:8080
# Go Backend: http://localhost:8081
```

### Kubernetes Deployment (Local)

```bash
# Ensure Rancher Desktop is running
python deploy-local.py
# Or: python3 deploy-local.py (on some systems)

# Access application
kubectl port-forward -n highscores-local svc/highscores-frontend 3000:80
# Visit: http://localhost:3000
```

### Azure Cloud Deployment

```bash
# Build and push images
# Windows:
set ACR_REGISTRY=myregistry.azurecr.io
# Mac/Linux:
export ACR_REGISTRY="myregistry.azurecr.io"

az acr login --name myregistry
python build-images.py azure v1.0.0
docker push %ACR_REGISTRY%/highscores-backend:v1.0.0  # Windows
docker push $ACR_REGISTRY/highscores-backend:v1.0.0  # Mac/Linux
docker push %ACR_REGISTRY%/highscores-frontend:v1.0.0  # Windows
docker push $ACR_REGISTRY/highscores-frontend:v1.0.0  # Mac/Linux

# Deploy with Terraform
cd terraform/environments/azure
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your Azure configuration
export TF_VAR_database_password="your-secure-password"
terraform init
terraform apply
```

## 📋 Project Structure

```
high-scores-demo/
├── java-spring-boot-backend/    # Spring Boot REST API
│   ├── Dockerfile               # Multi-stage Docker build
│   └── src/                     # Java source code
├── go-backend/                  # Go REST API (alternative backend)
│   ├── Dockerfile               # Go multi-stage build
│   ├── handlers/                # HTTP request handlers
│   ├── service/                 # Business logic layer
│   ├── repository/              # Data access layer
│   ├── models/                  # Domain models
│   └── websocket/               # WebSocket hub and client
├── frontend/                    # Modern React Frontend (Vite-based)
│   ├── Dockerfile               # Multi-stage build with nginx
│   ├── vite.config.ts           # Vite configuration
│   └── src/                     # React + TypeScript source code
│       ├── app/                 # Application components
│       │   ├── api/            # API service layer
│       │   ├── components/     # React components
│       │   └── context/        # Context providers (Game, WebSocket)
│       └── styles/              # CSS and theming
├── terraform/                   # Infrastructure as Code
│   ├── modules/                 # Reusable Terraform modules
│   │   ├── backend/            # Backend deployment
│   │   ├── frontend/           # Frontend deployment
│   │   ├── database/           # PostgreSQL (StatefulSet or Azure)
│   │   └── ingress/            # Ingress configuration
│   └── environments/
│       ├── local/              # Rancher Desktop configuration
│       └── azure/              # Azure AKS configuration
├── docs/                        # Documentation
│   ├── DEPLOYMENT.md           # Deployment guide
│   ├── AZURE_DEPLOYMENT_GUIDE.md # Azure guide
│   └── ROADMAP.md              # Project roadmap
├── docker-compose.yml          # Local multi-container setup
├── build-images.py             # Docker image build automation (cross-platform)
├── build-images.sh             # Docker image build automation (legacy bash)
├── deploy-local.py             # Local deployment automation (cross-platform)
├── deploy-local.sh             # Local deployment automation (legacy bash)
└── README.md                   # This file
```

## 🏗️ Architecture

### Components

1. **Java Backend** - Spring Boot 3.5.6 (Java 21)
   - REST API for high scores management
   - PostgreSQL database integration (H2 for development)
   - Spring Boot Actuator for health checks
   - Port: 8080

2. **Go Backend** - Go 1.x with Gin Framework (Alternative Implementation)
   - REST API implementing the same contract as Java backend
   - SQLite database (development) / PostgreSQL (production)
   - WebSocket support for real-time leaderboard updates
   - Lightweight and fast
   - Port: 8081

3. **Frontend** - React 18 with TypeScript & Vite
   - Modern Vite-based build tool for fast development
   - Tailwind CSS 4 styling
   - Radix UI components
   - Game-themed UI (Operation Nightfall)
   - WebSocket client for real-time updates
   - Nginx for production serving and API proxying
   - Port: 5173 (dev) / 80 (prod)

4. **Database** - PostgreSQL 16
   - Local: Kubernetes StatefulSet with persistent storage
   - Azure: Database for PostgreSQL Flexible Server
   - Go backend also supports SQLite for development

### API Contract

Both backends implement the same REST API contract, making them fully interchangeable:

- `POST /api/scores/submit` — Submit a new high score
- `GET /api/scores/game/{name}/top?limit=10` — Get top scores for a game
- `GET /api/scores/game/{name}?page=0&size=10` — Get all scores for a game (paginated)
- `GET /api/scores/player/{name}?page=0&size=10` — Get player's scores (paginated)
- `GET /api/scores/games` — List all available games
- `GET /api/scores/players` — List all players
- `GET /api/scores/game/{game}/player/{player}/high` — Get player's high score in a game
- `GET /health` — Health check endpoint

### Real-time Updates (Go Backend)

The Go backend includes WebSocket support for real-time leaderboard updates:

- **WebSocket Endpoint:** `ws://localhost:8081/ws`
- **Features:** 
  - Live score updates broadcast to all connected clients
  - Automatic leaderboard refresh when new scores are submitted
  - Hub-based architecture for efficient client management
  - Ping/pong heartbeat for connection health

### Deployment Options

- **Local Development:** Run directly with Gradle and npm
- **Local Kubernetes:** Rancher Desktop with Traefik ingress
- **Cloud:** Azure Kubernetes Service (AKS) with Azure PostgreSQL

### Choosing Between Java and Go Backends

This project provides **two fully-functional backend implementations** that are **interchangeable**:

| Feature | Java (Spring Boot) | Go (Gin) |
|---------|-------------------|----------|
| **Performance** | Good | Excellent (lower latency) |
| **Memory Usage** | ~250MB Docker image | ~20MB Docker image |
| **Startup Time** | ~5-10 seconds | <1 second |
| **WebSocket** | Not implemented | ✅ Included |
| **Database** | PostgreSQL + H2 | SQLite + PostgreSQL |
| **Production Ready** | ✅ Enterprise-grade | ✅ Production-ready |
| **Use Case** | Java shops, enterprise | High performance, real-time |

**Docker Compose** runs both backends simultaneously on different ports, allowing you to test and compare them side-by-side.

## 🐳 Containerization

All applications use optimized multi-stage Docker builds:

### Java Backend Docker Image
- Stage 1: Gradle 8 build with Java 21
- Stage 2: Lightweight JRE 21 runtime
- Non-root user for security
- Health checks via Spring Boot Actuator
- Size: ~250MB

### Go Backend Docker Image
- Stage 1: Go build with modules
- Stage 2: Alpine runtime (minimal)
- Non-root user for security
- SQLite embedded database
- Health checks via /health endpoint
- Size: ~20MB

### Frontend Docker Image
- Stage 1: Node 18 build
- Stage 2: Nginx Alpine runtime
- Runtime environment injection
- Custom health endpoint
- Size: ~25MB

## ☸️ Kubernetes Features

- **Health Probes:** Liveness, readiness, and startup checks
- **Autoscaling:** Horizontal Pod Autoscaler (2-10 replicas)
- **Resource Management:** CPU/memory requests and limits
- **Configuration:** ConfigMaps and Secrets
- **Ingress:** Path-based routing with TLS support
- **Persistence:** StatefulSets with Persistent Volume Claims (local)

## 🔧 Technology Stack

**Java Backend:**
- Java 21
- Spring Boot 3.5.6
- Gradle 8
- PostgreSQL JDBC Driver
- H2 Database (development)
- Spring Boot Actuator

**Go Backend:**
- Go 1.x
- Gin Web Framework
- GORM (Go ORM)
- SQLite (development)
- PostgreSQL Driver
- Gorilla WebSocket

**Frontend:**
- React 19.2.0 / React 18 (Vite version)
- TypeScript
- Axios / Fetch API
- Tailwind CSS 4
- Radix UI
- Nginx
- WebSocket Client

**Infrastructure:**
- Docker & Docker Compose
- Kubernetes
- Terraform
- Azure (AKS, ACR, PostgreSQL)

## 📖 Documentation

- **[docs/DEPLOYMENT.md](docs/DEPLOYMENT.md)** - Comprehensive deployment guide covering both local and Azure deployments
- **[docs/AZURE_DEPLOYMENT_GUIDE.md](docs/AZURE_DEPLOYMENT_GUIDE.md)** - Step-by-step Azure deployment instructions with troubleshooting
- **[terraform/README.md](terraform/README.md)** - Detailed Terraform module documentation
- **[java-spring-boot-backend/README.md](java-spring-boot-backend/README.md)** - Backend API documentation
- **[frontend/README.md](frontend/README.md)** - Game Frontend (Vite) development guide

## 🚢 Deployment Examples

### Build Docker Images

```bash
# Local development images
python build-images.py local latest

# Azure images with version tag
# Windows: set ACR_REGISTRY=myregistry.azurecr.io
# Mac/Linux: export ACR_REGISTRY="myregistry.azurecr.io"
python build-images.py azure v1.0.0
```

### Local Kubernetes (Rancher Desktop)

```bash
# Automated deployment (works on Windows, Mac, and Linux)
python deploy-local.py

# Manual deployment
cd terraform/environments/local
terraform init
terraform apply
```

### Azure Kubernetes Service

```bash
# Navigate to Azure environment
cd terraform/environments/azure

# Configure variables (copy from example)
cp terraform.tfvars.example terraform.tfvars
vi terraform.tfvars

# Deploy
export TF_VAR_database_password="secure-password"
terraform init
terraform apply

# Get access information
terraform output access_instructions
```

## 🔍 Monitoring & Debugging

```bash
# Check pod status
kubectl get pods -n <namespace>

# View logs
kubectl logs -n <namespace> -l app=highscores-backend -f
kubectl logs -n <namespace> -l app=highscores-frontend -f

# Port forward services
kubectl port-forward -n <namespace> svc/highscores-backend 8080:8080
kubectl port-forward -n <namespace> svc/highscores-frontend 3000:80

# Check health endpoints
curl http://localhost:8080/actuator/health  # Backend
curl http://localhost:3000/health           # Frontend
```

## 🔐 Security Features

1. **Container Security:**
   - Multi-stage builds minimize attack surface
   - Non-root users in containers
   - Security contexts configured

2. **Kubernetes Security:**
   - Secrets for sensitive data
   - Resource limits enforced
   - Network policies (optional)

3. **Azure Security:**
   - PostgreSQL firewall rules
   - Managed identities
   - Encryption at rest
   - Virtual network integration

## 🧪 Testing

### Java Backend Tests
```bash
cd java-spring-boot-backend
./gradlew test
```

### Go Backend Tests
```bash
cd go-backend
go test ./...
```

### Frontend Tests
```bash
cd react-frontend
npm test
```

### API Testing

Automated API testing script:
```bash
cd java-spring-boot-backend
python test-api.py
```

HTTP test files for VS Code included:
- `api-tests.http`
- `comprehensive-api-tests.http`
- `game-score-tests.http`

## 🧹 Cleanup

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

## 📝 Configuration

### Java Backend Environment Variables
- `SPRING_PROFILES_ACTIVE`: `prod` (PostgreSQL) or `default` (H2)
- `DATABASE_URL`: JDBC connection URL
- `DATABASE_USERNAME`: Database username
- `DATABASE_PASSWORD`: Database password

### Go Backend Environment Variables
- `PORT`: Server port (default: 8081)
- `DB_PATH`: SQLite database file path (default: highscores.db)
- `GIN_MODE`: `release` for production, `debug` for development
- `DATABASE_URL`: PostgreSQL connection string (for production)

### Frontend Environment Variables
- `REACT_APP_API_BASE_URL`: Backend API URL (configured at runtime)
- `VITE_API_URL`: Backend API URL for Vite frontend

## 🤝 Contributing

This project is part of the APS GitHub Copilot Enablement initiative. To contribute:

1. Create a feature branch
2. Make changes
3. Test locally with `deploy-local.sh`
4. Submit a pull request

## 📄 License

Part of the APS GitHub Copilot Enablement project.

## 🆘 Support

For issues or questions:
1. Review the documentation in `DEPLOYMENT.md` and `AZURE_DEPLOYMENT_GUIDE.md`
2. Check the troubleshooting sections
3. Review Kubernetes events and logs
4. Consult the Terraform README 