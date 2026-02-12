#!/bin/bash

# High Scores Demo - Docker Build Script
# This script builds Docker images for both backend and frontend applications

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="$PROJECT_ROOT/java-spring-boot-backend"
FRONTEND_DIR="$PROJECT_ROOT/react-frontend"

# Default values
ENVIRONMENT=${1:-local}
VERSION=${2:-latest}
REGISTRY=${ACR_REGISTRY:-}

echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     High Scores Demo - Docker Image Builder             ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Environment:${NC} $ENVIRONMENT"
echo -e "${YELLOW}Version:${NC} $VERSION"
echo ""

# Build backend
echo -e "${GREEN}[1/2] Building backend (Spring Boot)...${NC}"
cd "$BACKEND_DIR"
if [ "$ENVIRONMENT" = "local" ]; then
    docker build -t highscores-backend:$VERSION .
    echo -e "${GREEN}✓ Backend image built: highscores-backend:$VERSION${NC}"
else
    if [ -z "$REGISTRY" ]; then
        echo -e "${RED}Error: ACR_REGISTRY environment variable not set${NC}"
        echo "Example: export ACR_REGISTRY=myregistry.azurecr.io"
        exit 1
    fi
    docker build -t $REGISTRY/highscores-backend:$VERSION .
    echo -e "${GREEN}✓ Backend image built: $REGISTRY/highscores-backend:$VERSION${NC}"
fi

# Build frontend
echo ""
echo -e "${GREEN}[2/2] Building frontend (React + Nginx)...${NC}"
cd "$FRONTEND_DIR"
if [ "$ENVIRONMENT" = "local" ]; then
    docker build -t highscores-frontend:$VERSION .
    echo -e "${GREEN}✓ Frontend image built: highscores-frontend:$VERSION${NC}"
else
    docker build -t $REGISTRY/highscores-frontend:$VERSION .
    echo -e "${GREEN}✓ Frontend image built: $REGISTRY/highscores-frontend:$VERSION${NC}"
fi

echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Build completed successfully!${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════${NC}"

# Show next steps
echo ""
if [ "$ENVIRONMENT" = "local" ]; then
    echo -e "${YELLOW}Next steps for local deployment:${NC}"
    echo "  1. Ensure Rancher Desktop is running"
    echo "  2. cd terraform/environments/local"
    echo "  3. terraform init"
    echo "  4. terraform apply"
else
    echo -e "${YELLOW}Next steps for Azure deployment:${NC}"
    echo "  1. Login to ACR:"
    echo "     az acr login --name <registry-name>"
    echo "  2. Push images:"
    echo "     docker push $REGISTRY/highscores-backend:$VERSION"
    echo "     docker push $REGISTRY/highscores-frontend:$VERSION"
    echo "  3. Deploy with Terraform:"
    echo "     cd terraform/environments/azure"
    echo "     terraform apply -var=\"backend_image=$REGISTRY/highscores-backend:$VERSION\" -var=\"frontend_image=$REGISTRY/highscores-frontend:$VERSION\""
fi
echo ""
