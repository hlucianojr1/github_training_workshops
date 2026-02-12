#!/bin/bash

# AI Demo API Test Runner
# This script tests all endpoints and displays the results

echo "🚀 AI Demo API Test Runner"
echo "=================================="
echo ""

BASE_URL="http://localhost:8080"

# Function to test an endpoint
test_endpoint() {
    local name="$1"
    local url="$2"
    local expected_status="${3:-200}"
    
    echo "🧪 Testing: $name"
    echo "   URL: $url"
    
    # Make the request and capture both response and status
    response=$(curl -s -w "\nHTTP_STATUS:%{http_code}" "$url")
    http_status=$(echo "$response" | grep "HTTP_STATUS:" | cut -d: -f2)
    response_body=$(echo "$response" | sed '/HTTP_STATUS:/d')
    
    if [ "$http_status" = "$expected_status" ]; then
        echo "   ✅ Status: $http_status (Expected: $expected_status)"
        echo "   📝 Response: $response_body"
    else
        echo "   ❌ Status: $http_status (Expected: $expected_status)"
        echo "   📝 Response: $response_body"
    fi
    echo ""
}

# Check if server is running
echo "🔍 Checking if server is running..."
if curl -s --connect-timeout 5 "$BASE_URL/health" > /dev/null; then
    echo "✅ Server is running at $BASE_URL"
    echo ""
else
    echo "❌ Server is not running or not accessible at $BASE_URL"
    echo "   Please start the server with: ./gradlew bootRun"
    exit 1
fi

# Run all tests
echo "🧪 Running API Tests..."
echo "=================================="
echo ""

test_endpoint "Root Endpoint" "$BASE_URL/"
test_endpoint "Health Check" "$BASE_URL/health"
test_endpoint "Hello Default" "$BASE_URL/hello"
test_endpoint "Hello with Name" "$BASE_URL/hello?name=TestRunner"
test_endpoint "Hello Path Variable" "$BASE_URL/hello/APITest"
test_endpoint "Non-existent Endpoint (404 Expected)" "$BASE_URL/nonexistent" "404"

# Test the new game score endpoints
echo "� Testing Game Score Endpoints..."
echo "=================================="
echo ""

# Submit a test score
echo "📝 Submitting a test score..."
response=$(curl -s -X POST "$BASE_URL/api/scores/submit" \
  -H "Content-Type: application/json" \
  -d '{"playerName":"TestPlayer","gameName":"TestGame","score":12345}' \
  -w "\nHTTP_STATUS:%{http_code}")

http_status=$(echo "$response" | grep "HTTP_STATUS:" | cut -d: -f2)
response_body=$(echo "$response" | sed '/HTTP_STATUS:/d')

echo "🧪 Testing: Submit Score (POST)"
echo "   URL: $BASE_URL/api/scores/submit"

if [ "$http_status" = "201" ]; then
    echo "   ✅ Status: $http_status (Expected: 201)"
    echo "   📝 Response: $response_body"
else
    echo "   ❌ Status: $http_status (Expected: 201)"
    echo "   📝 Response: $response_body"
fi
echo ""
test_endpoint "Get All Games" "$BASE_URL/api/scores/games"
test_endpoint "Get All Players" "$BASE_URL/api/scores/players"
test_endpoint "Get Top Scores for TestGame" "$BASE_URL/api/scores/game/TestGame/top"
test_endpoint "Get TestPlayer Scores" "$BASE_URL/api/scores/player/TestPlayer"

echo ""
echo "�🎉 API Testing Complete!"
echo "=================================="
echo ""
echo "💡 Tips:"
echo "   - Use the .http files in VS Code for interactive testing"
echo "   - Open game-score-tests.http for comprehensive game score testing"
echo "   - Open api-tests.http or comprehensive-api-tests.http for basic tests"
echo "   - Click 'Send Request' above each HTTP request to execute it"
echo "   - Access H2 database console at: http://localhost:8080/h2-console"
echo "     JDBC URL: jdbc:h2:mem:testdb, Username: sa, Password: (empty)"
echo ""