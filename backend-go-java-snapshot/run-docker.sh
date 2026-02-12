#!/bin/bash

# High Scores Demo - Docker Compose Run Script
# This script builds and runs the full stack application using Docker Compose
# Stack: Java Spring Boot Backend + Vite React Frontend

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BACKEND_PORT=8080
FRONTEND_PORT=3000

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Functions
print_header() {
    echo ""
    echo -e "${BLUE}══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}══════════════════════════════════════════════════════════${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check if Docker is running
check_docker() {
    if ! docker info &> /dev/null; then
        print_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
    print_success "Docker is running"
}

# Check if Docker Compose is available
check_docker_compose() {
    if docker compose version &> /dev/null; then
        COMPOSE_CMD="docker compose"
        print_success "Docker Compose (plugin) is available"
    elif command -v docker-compose &> /dev/null; then
        COMPOSE_CMD="docker-compose"
        print_success "Docker Compose (standalone) is available"
    else
        print_error "Docker Compose is not installed. Please install Docker Compose."
        exit 1
    fi
}

# Build images
build_images() {
    print_header "Building Docker Images"
    
    cd "${SCRIPT_DIR}"
    $COMPOSE_CMD build
    
    print_success "All images built successfully"
}

# Start services
start_services() {
    print_header "Starting Services with Docker Compose"
    
    cd "${SCRIPT_DIR}"
    $COMPOSE_CMD up -d
    
    print_success "Services started"
}

# Stop services
stop_services() {
    print_header "Stopping High Scores Demo"
    
    cd "${SCRIPT_DIR}"
    $COMPOSE_CMD down
    
    print_success "Application stopped"
}

# Clean up (stop and remove volumes)
cleanup() {
    print_header "Cleaning up containers and volumes"
    
    cd "${SCRIPT_DIR}"
    $COMPOSE_CMD down -v --remove-orphans
    
    print_success "Cleanup complete"
}

# Wait for services to be healthy
wait_for_services() {
    print_header "Waiting for services to be ready"
    
    local max_attempts=30
    local attempt=1
    
    echo -n "Waiting for backend"
    while [ $attempt -le $max_attempts ]; do
        if curl -s http://localhost:${BACKEND_PORT}/actuator/health > /dev/null 2>&1; then
            echo ""
            print_success "Backend is healthy and ready!"
            break
        fi
        echo -n "."
        sleep 2
        attempt=$((attempt + 1))
    done
    
    if [ $attempt -gt $max_attempts ]; then
        echo ""
        print_warning "Backend health check timed out (may still be starting)"
    fi
    
    # Check frontend health endpoint
    attempt=1
    echo -n "Waiting for frontend"
    while [ $attempt -le $max_attempts ]; do
        if curl -s http://localhost:${FRONTEND_PORT}/health > /dev/null 2>&1; then
            echo ""
            print_success "Frontend is healthy and ready!"
            break
        fi
        echo -n "."
        sleep 1
        attempt=$((attempt + 1))
    done
    
    if [ $attempt -gt $max_attempts ]; then
        echo ""
        print_warning "Frontend health check timed out (may still be starting)"
    fi
}

# Show status
show_status() {
    print_header "Application Status"
    
    cd "${SCRIPT_DIR}"
    echo "Container Status:"
    $COMPOSE_CMD ps
    
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  High Scores Demo is running!                            ║${NC}"
    echo -e "${GREEN}╠══════════════════════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║  Frontend:        http://localhost:${FRONTEND_PORT}                  ║${NC}"
    echo -e "${GREEN}║  Frontend Health: http://localhost:${FRONTEND_PORT}/health          ║${NC}"
    echo -e "${GREEN}║  Backend:         http://localhost:${BACKEND_PORT}                  ║${NC}"
    echo -e "${GREEN}║  Backend Health:  http://localhost:${BACKEND_PORT}/actuator/health  ║${NC}"
    echo -e "${GREEN}║  H2 Console:      http://localhost:${BACKEND_PORT}/h2-console       ║${NC}"
    echo -e "${GREEN}║  API Proxy:       http://localhost:${FRONTEND_PORT}/api             ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Commands:${NC}"
    echo -e "  $0 stop    - Stop the application"
    echo -e "  $0 logs    - View logs"
    echo -e "  $0 restart - Restart services"
    echo ""
}

# Show logs
show_logs() {
    local service=$1
    cd "${SCRIPT_DIR}"
    
    if [ -z "$service" ]; then
        print_info "Showing logs for all services (Ctrl+C to exit)..."
        $COMPOSE_CMD logs -f
    else
        print_info "Showing logs for $service (Ctrl+C to exit)..."
        $COMPOSE_CMD logs -f $service
    fi
}

# Restart services
restart_services() {
    print_header "Restarting High Scores Demo"
    
    cd "${SCRIPT_DIR}"
    $COMPOSE_CMD restart
    
    wait_for_services
    show_status
}

# Rebuild and restart
rebuild() {
    print_header "Rebuilding and Restarting"
    
    cd "${SCRIPT_DIR}"
    $COMPOSE_CMD down
    $COMPOSE_CMD build --no-cache
    $COMPOSE_CMD up -d
    
    wait_for_services
    show_status
}

# Main execution
main() {
    print_header "High Scores Demo - Docker Compose Deployment"
    
    check_docker
    check_docker_compose
    
    cd "${SCRIPT_DIR}"
    
    # Stop any existing services first
    $COMPOSE_CMD down 2>/dev/null || true
    
    build_images
    start_services
    wait_for_services
    show_status
}

# Show help
show_help() {
    echo "High Scores Demo - Docker Run Script"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  (none)     Build and start the application"
    echo "  start      Start services (without rebuilding)"
    echo "  stop       Stop all services"
    echo "  restart    Restart all services"
    echo "  rebuild    Rebuild images and restart"
    echo "  build      Build images only"
    echo "  logs       View logs (optionally: logs backend|frontend)"
    echo "  status     Show service status"
    echo "  clean      Stop and remove all containers/volumes"
    echo "  help       Show this help message"
    echo ""
}

# Parse command line arguments
case "${1:-}" in
    start)
        check_docker
        check_docker_compose
        start_services
        wait_for_services
        show_status
        ;;
    stop)
        check_docker
        check_docker_compose
        stop_services
        ;;
    restart)
        check_docker
        check_docker_compose
        restart_services
        ;;
    rebuild)
        check_docker
        check_docker_compose
        rebuild
        ;;
    build)
        check_docker
        check_docker_compose
        build_images
        ;;
    logs)
        check_docker
        check_docker_compose
        show_logs "${2:-}"
        ;;
    status)
        check_docker
        check_docker_compose
        show_status
        ;;
    clean)
        check_docker
        check_docker_compose
        cleanup
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        main
        ;;
esac
