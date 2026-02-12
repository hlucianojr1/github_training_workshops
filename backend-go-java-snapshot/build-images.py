#!/usr/bin/env python3
"""
High Scores Demo - Docker Build Script
This script builds Docker images for both backend and frontend applications
"""

import os
import sys
import subprocess
from pathlib import Path

# Colors for terminal output
class Colors:
    RED = '\033[0;31m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    NC = '\033[0m'  # No Color

    @staticmethod
    def disable():
        """Disable colors on Windows if needed"""
        Colors.RED = ''
        Colors.GREEN = ''
        Colors.YELLOW = ''
        Colors.NC = ''

# Enable colors on Windows 10+
if sys.platform == 'win32':
    try:
        import colorama
        colorama.init()
    except ImportError:
        Colors.disable()


def run_command(cmd, cwd=None):
    """Run a shell command and exit on failure"""
    try:
        result = subprocess.run(
            cmd,
            shell=True,
            cwd=cwd,
            check=True,
            text=True,
            capture_output=False
        )
        return result.returncode
    except subprocess.CalledProcessError as e:
        print(f"{Colors.RED}Error: Command failed with exit code {e.returncode}{Colors.NC}")
        sys.exit(1)


def main():
    # Configuration
    project_root = Path(__file__).parent.resolve()
    backend_dir = project_root / "java-spring-boot-backend"
    frontend_dir = project_root / "react-frontend"

    # Parse arguments
    environment = sys.argv[1] if len(sys.argv) > 1 else "local"
    version = sys.argv[2] if len(sys.argv) > 2 else "latest"
    registry = os.environ.get('ACR_REGISTRY', '')

    # Header
    print(f"{Colors.GREEN}╔══════════════════════════════════════════════════════════╗{Colors.NC}")
    print(f"{Colors.GREEN}║     High Scores Demo - Docker Image Builder             ║{Colors.NC}")
    print(f"{Colors.GREEN}╚══════════════════════════════════════════════════════════╝{Colors.NC}")
    print()
    print(f"{Colors.YELLOW}Environment:{Colors.NC} {environment}")
    print(f"{Colors.YELLOW}Version:{Colors.NC} {version}")
    print()

    # Determine image tags
    if environment == "local":
        backend_tag = f"highscores-backend:{version}"
        frontend_tag = f"highscores-frontend:{version}"
    else:
        if not registry:
            print(f"{Colors.RED}Error: ACR_REGISTRY environment variable not set{Colors.NC}")
            print("Example: set ACR_REGISTRY=myregistry.azurecr.io (Windows)")
            print("Example: export ACR_REGISTRY=myregistry.azurecr.io (Mac/Linux)")
            sys.exit(1)
        backend_tag = f"{registry}/highscores-backend:{version}"
        frontend_tag = f"{registry}/highscores-frontend:{version}"

    # Build backend
    print(f"{Colors.GREEN}[1/2] Building backend (Spring Boot)...{Colors.NC}")
    run_command(f"docker build -t {backend_tag} .", cwd=backend_dir)
    print(f"{Colors.GREEN}✓ Backend image built: {backend_tag}{Colors.NC}")
    print()

    # Build frontend
    print(f"{Colors.GREEN}[2/2] Building frontend (React + Nginx)...{Colors.NC}")
    run_command(f"docker build -t {frontend_tag} .", cwd=frontend_dir)
    print(f"{Colors.GREEN}✓ Frontend image built: {frontend_tag}{Colors.NC}")
    print()

    # Success message
    print(f"{Colors.GREEN}════════════════════════════════════════════════════════{Colors.NC}")
    print(f"{Colors.GREEN}Build completed successfully!{Colors.NC}")
    print(f"{Colors.GREEN}════════════════════════════════════════════════════════{Colors.NC}")
    print()

    # Show next steps
    if environment == "local":
        print(f"{Colors.YELLOW}Next steps for local deployment:{Colors.NC}")
        print("  1. Ensure Rancher Desktop is running")
        print("  2. cd terraform/environments/local")
        print("  3. terraform init")
        print("  4. terraform apply")
    else:
        print(f"{Colors.YELLOW}Next steps for Azure deployment:{Colors.NC}")
        print("  1. Login to ACR:")
        print("     az acr login --name <registry-name>")
        print("  2. Push images:")
        print(f"     docker push {backend_tag}")
        print(f"     docker push {frontend_tag}")
        print("  3. Deploy with Terraform:")
        print("     cd terraform/environments/azure")
        print(f"     terraform apply -var=\"backend_image={backend_tag}\" -var=\"frontend_image={frontend_tag}\"")
    print()


if __name__ == "__main__":
    main()
