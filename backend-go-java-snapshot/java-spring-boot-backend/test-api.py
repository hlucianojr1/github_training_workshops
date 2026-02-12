#!/usr/bin/env python3
"""
AI Demo API Test Runner
This script tests all endpoints and displays the results
"""

import sys
import json
import urllib.request
import urllib.error
from typing import Tuple

# Colors for terminal output
class Colors:
    RED = '\033[0;31m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    BLUE = '\033[0;34m'
    NC = '\033[0m'  # No Color

    @staticmethod
    def disable():
        """Disable colors on Windows if needed"""
        Colors.RED = ''
        Colors.GREEN = ''
        Colors.YELLOW = ''
        Colors.BLUE = ''
        Colors.NC = ''

# Enable colors on Windows 10+
if sys.platform == 'win32':
    try:
        import colorama
        colorama.init()
    except ImportError:
        Colors.disable()


BASE_URL = "http://localhost:8080"


def test_endpoint(name: str, url: str, expected_status: int = 200, method: str = "GET", data: dict = None) -> None:
    """Test an API endpoint"""
    print(f"🧪 Testing: {name}")
    print(f"   URL: {url}")

    try:
        headers = {}
        body = None
        
        if data:
            headers['Content-Type'] = 'application/json'
            body = json.dumps(data).encode('utf-8')

        request = urllib.request.Request(url, data=body, headers=headers, method=method)
        
        try:
            with urllib.request.urlopen(request, timeout=10) as response:
                http_status = response.status
                response_body = response.read().decode('utf-8')
        except urllib.error.HTTPError as e:
            http_status = e.code
            response_body = e.read().decode('utf-8')

        if http_status == expected_status:
            print(f"   ✅ Status: {http_status} (Expected: {expected_status})")
            print(f"   📝 Response: {response_body[:200]}")
        else:
            print(f"   ❌ Status: {http_status} (Expected: {expected_status})")
            print(f"   📝 Response: {response_body[:200]}")

    except Exception as e:
        print(f"   ❌ Error: {str(e)}")

    print()


def check_server() -> bool:
    """Check if the server is running"""
    try:
        with urllib.request.urlopen(f"{BASE_URL}/health", timeout=5) as response:
            return response.status == 200
    except:
        return False


def main():
    print(f"{Colors.GREEN}🚀 AI Demo API Test Runner{Colors.NC}")
    print("==================================")
    print()

    # Check if server is running
    print("🔍 Checking if server is running...")
    if check_server():
        print(f"{Colors.GREEN}✅ Server is running at {BASE_URL}{Colors.NC}")
        print()
    else:
        print(f"{Colors.RED}❌ Server is not running or not accessible at {BASE_URL}{Colors.NC}")
        if sys.platform == 'win32':
            print("   Please start the server with: gradlew.bat bootRun")
        else:
            print("   Please start the server with: ./gradlew bootRun")
        sys.exit(1)

    # Run basic API tests
    print(f"{Colors.YELLOW}🧪 Running API Tests...{Colors.NC}")
    print("==================================")
    print()

    test_endpoint("Root Endpoint", f"{BASE_URL}/")
    test_endpoint("Health Check", f"{BASE_URL}/health")
    test_endpoint("Hello Default", f"{BASE_URL}/hello")
    test_endpoint("Hello with Name", f"{BASE_URL}/hello?name=TestRunner")
    test_endpoint("Hello Path Variable", f"{BASE_URL}/hello/APITest")
    test_endpoint("Non-existent Endpoint (404 Expected)", f"{BASE_URL}/nonexistent", 404)

    # Test game score endpoints
    print(f"{Colors.YELLOW}🎮 Testing Game Score Endpoints...{Colors.NC}")
    print("==================================")
    print()

    # Submit a test score
    print("📝 Submitting a test score...")
    test_data = {
        "playerName": "TestPlayer",
        "gameName": "TestGame",
        "score": 12345
    }
    test_endpoint(
        "Submit Score (POST)",
        f"{BASE_URL}/api/scores/submit",
        201,
        "POST",
        test_data
    )

    test_endpoint("Get All Games", f"{BASE_URL}/api/scores/games")
    test_endpoint("Get All Players", f"{BASE_URL}/api/scores/players")
    test_endpoint("Get Top Scores for TestGame", f"{BASE_URL}/api/scores/game/TestGame/top")
    test_endpoint("Get TestPlayer Scores", f"{BASE_URL}/api/scores/player/TestPlayer")

    print()
    print(f"{Colors.GREEN}🎉 API Testing Complete!{Colors.NC}")
    print("==================================")
    print()
    print(f"{Colors.BLUE}💡 Tips:{Colors.NC}")
    print("   - Use the .http files in VS Code for interactive testing")
    print("   - Open game-score-tests.http for comprehensive game score testing")
    print("   - Open api-tests.http or comprehensive-api-tests.http for basic tests")
    print("   - Click 'Send Request' above each HTTP request to execute it")
    print("   - Access H2 database console at: http://localhost:8080/h2-console")
    print("     JDBC URL: jdbc:h2:mem:testdb, Username: sa, Password: (empty)")
    print()


if __name__ == "__main__":
    main()
