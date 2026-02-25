# Understanding MCP (Model Context Protocol) Server

## What is MCP Server?

**MCP (Model Context Protocol)** is an open standard that enables AI assistants and Large Language Models (LLMs) to securely connect with external data sources, tools, and services. Think of MCP as a "universal adapter" that allows AI agents to interact with the outside world in a standardized, secure way.

### The Problem MCP Solves

Before MCP, developers faced significant challenges:
- **Fragmented Integrations**: Each AI tool required custom integrations for every data source
- **Security Concerns**: No standardized way to safely expose tools and data to AI
- **Limited Context**: AI assistants were isolated from real-time, actionable data
- **Duplicated Effort**: Building the same integrations repeatedly across different AI platforms

### How MCP Works

```
┌─────────────────┐     MCP Protocol     ┌─────────────────┐
│   AI Assistant  │ ◄──────────────────► │   MCP Server    │
│   (MCP Client)  │                      │                 │
└─────────────────┘                      └────────┬────────┘
                                                  │
                                         ┌────────┴────────┐
                                         │  External Tools │
                                         │  & Data Sources │
                                         └─────────────────┘
```

**Components:**
1. **MCP Host**: The AI application (e.g., VS Code with GitHub Copilot, Claude Desktop)
2. **MCP Client**: Maintains 1:1 connection with MCP servers
3. **MCP Server**: Exposes tools, resources, and prompts to the AI

---

## How MCP Assists Developers in AI Agentic Development

### 1. **Tool Exposure**
MCP servers expose "tools" that AI agents can invoke. These are functions the AI can call to perform actions:

```json
{
  "name": "read_file",
  "description": "Read contents of a file from the filesystem",
  "parameters": {
    "filePath": "string - absolute path to the file"
  }
}
```

**Benefits:**
- AI agents can interact with databases, APIs, file systems, and cloud services
- Developers define what actions are available and their parameters
- AI makes intelligent decisions about when to use which tool

### 2. **Resource Access**
MCP provides structured access to data resources:
- Database queries
- File contents
- API responses
- Documentation

### 3. **Prompt Templates**
Pre-defined prompt templates help ensure consistent, high-quality interactions.

---

## Practical Examples for Agentic Development

### Example 1: Database Operations MCP Server

```python
# MCP Server exposing database tools
@mcp.tool()
async def query_database(sql: str) -> str:
    """Execute a read-only SQL query against the database"""
    result = await db.execute(sql)
    return json.dumps(result)

@mcp.tool()
async def list_tables() -> list[str]:
    """List all available database tables"""
    return await db.get_table_names()
```

**What the AI Can Now Do:**
- "Show me all customers who signed up last month"
- "Find products with low inventory"
- "Analyze sales trends by region"

### Example 2: Cloud Infrastructure MCP Server

```python
@mcp.tool()
async def list_azure_resources(resource_group: str) -> list:
    """List all Azure resources in a resource group"""
    return await azure_client.list_resources(resource_group)

@mcp.tool()
async def deploy_container(image: str, config: dict) -> str:
    """Deploy a container to Azure Container Apps"""
    return await azure_client.deploy(image, config)
```

**What the AI Can Now Do:**
- "Deploy my application to Azure"
- "Show me the status of all my cloud resources"
- "Scale up my web app to handle more traffic"

### Example 3: Development Workflow MCP Server

```python
@mcp.tool()
async def run_tests(test_path: str) -> TestResult:
    """Run unit tests and return results"""
    return await test_runner.run(test_path)

@mcp.tool()
async def create_pull_request(title: str, body: str, branch: str) -> str:
    """Create a GitHub pull request"""
    return await github.create_pr(title, body, branch)
```

**What the AI Can Now Do:**
- "Run all tests for the user module"
- "Create a PR with my changes"
- "Check if my code passes CI/CD"

---

## Key Benefits for AI Agentic Development

| Benefit | Description |
|---------|-------------|
| **Standardization** | One protocol works across multiple AI platforms and tools |
| **Security** | Controlled access to resources with proper authentication |
| **Composability** | Combine multiple MCP servers for complex workflows |
| **Extensibility** | Easy to add new tools and capabilities |
| **Contextual Awareness** | AI agents have access to real, current data |
| **Reduced Hallucination** | Grounded in actual data rather than training knowledge |

---

## Building Your Own MCP Server

### Basic Structure (Python)

```python
from mcp.server import Server
from mcp.types import Tool

# Initialize the MCP server
server = Server("my-custom-server")

@server.tool()
async def my_custom_tool(param1: str, param2: int) -> str:
    """
    Description of what this tool does.
    The AI will read this to understand when to use it.
    """
    # Your implementation here
    result = do_something(param1, param2)
    return result

# Run the server
if __name__ == "__main__":
    server.run()
```

### Basic Structure (TypeScript)

```typescript
import { Server } from "@modelcontextprotocol/sdk/server";

const server = new Server({
  name: "my-custom-server",
  version: "1.0.0"
});

server.setRequestHandler("tools/call", async (request) => {
  const { name, arguments: args } = request.params;
  
  if (name === "my_custom_tool") {
    // Implementation
    return { result: "success" };
  }
});

server.connect(transport);
```

---

## MCP in the AI Agentic Ecosystem

```
┌────────────────────────────────────────────────────────────┐
│                    AI AGENT WORKFLOW                        │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  User Request ──► AI Agent ──► MCP Client                  │
│                       │              │                     │
│                       │              ▼                     │
│                       │      ┌───────────────┐             │
│                       │      │  MCP Servers  │             │
│                       │      ├───────────────┤             │
│                       │      │ • File System │             │
│                       │      │ • Database    │             │
│                       │      │ • Git/GitHub  │             │
│                       │      │ • Cloud APIs  │             │
│                       │      │ • Monitoring  │             │
│                       │      │ • Custom Tools│             │
│                       │      └───────┬───────┘             │
│                       │              │                     │
│                       ◄──────────────┘                     │
│                       │                                    │
│                       ▼                                    │
│               Response to User                             │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

---

## Getting Started Checklist

- [ ] **Identify your use case**: What external data/tools does your AI agent need?
- [ ] **Choose your SDK**: Python (`mcp`) or TypeScript (`@modelcontextprotocol/sdk`)
- [ ] **Define your tools**: What actions should the AI be able to perform?
- [ ] **Implement security**: Authentication, rate limiting, input validation
- [ ] **Test thoroughly**: Ensure tools handle edge cases gracefully
- [ ] **Document clearly**: Tool descriptions are crucial for AI understanding

---

## Context7 MCP Server: Real-Time Documentation Access

**Context7** is an MCP server that provides AI agents with up-to-date documentation for any library or framework. Instead of relying on potentially outdated training data, Context7 fetches current documentation in real-time.

### How Context7 Works

```
┌─────────────────┐                    ┌─────────────────┐
│   AI Assistant  │ ◄────────────────► │  Context7 MCP   │
│   asking about  │                    │     Server      │
│   React hooks   │                    └────────┬────────┘
└─────────────────┘                             │
                                                ▼
                                    ┌───────────────────────┐
                                    │  Context7 Knowledge   │
                                    │       Database        │
                                    │  ┌─────────────────┐  │
                                    │  │ React 19 docs   │  │
                                    │  │ Next.js 15 docs │  │
                                    │  │ TypeScript 5.x  │  │
                                    │  │ 1000s more...   │  │
                                    │  └─────────────────┘  │
                                    └───────────────────────┘
```

### Context7 Tools

Context7 exposes two primary tools:

#### 1. `resolve-library-id`
Finds the correct library identifier for documentation lookup:

```
User: "How do I use React Server Components?"

AI calls: resolve-library-id("React")
Returns: "/facebook/react" with metadata about available docs
```

#### 2. `get-library-docs`
Fetches actual documentation content:

```
AI calls: get-library-docs(
  context7CompatibleLibraryID: "/facebook/react",
  topic: "server components"
)
Returns: Current React Server Components documentation
```

### Practical Example: Using Context7 for Development

**Scenario**: Developer asks about Next.js App Router

```
┌────────────────────────────────────────────────────────────┐
│ User: "How do I create a loading state in Next.js 15?"     │
├────────────────────────────────────────────────────────────┤
│                                                            │
│ Step 1: AI calls resolve-library-id("Next.js")             │
│         → Returns: "/vercel/next.js"                       │
│                                                            │
│ Step 2: AI calls get-library-docs(                         │
│           libraryID: "/vercel/next.js",                    │
│           topic: "loading state app router"                │
│         )                                                  │
│         → Returns: Current Next.js 15 loading.js docs      │
│                                                            │
│ Step 3: AI provides accurate, up-to-date answer:           │
│         "Create a loading.js file in your route folder..." │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

### Context7 Configuration

Add Context7 to your MCP configuration:

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"]
    }
  }
}
```

### Benefits of Context7 for AI Agents

| Feature | Benefit |
|---------|---------|
| **Real-time docs** | Always current, never outdated |
| **Version-specific** | Get docs for exact library version |
| **Code examples** | Actual working code from official docs |
| **Topic filtering** | Focus on specific concepts |
| **Reduced hallucination** | Grounded in official documentation |

---

## CORE Framework for Context Engineering

The **CORE Framework** is a systematic approach to context engineering that maximizes the effectiveness of AI agents. CORE stands for:

- **C**ontext
- **O**bjective
- **R**ules
- **E**xamples

### Why CORE Matters for MCP Development

When building MCP servers or crafting prompts for AI agents, the CORE framework ensures you provide comprehensive, actionable context that leads to better outcomes.

```
┌────────────────────────────────────────────────────────────┐
│                    CORE FRAMEWORK                          │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  ┌──────────────┐    ┌──────────────┐                     │
│  │   CONTEXT    │    │  OBJECTIVE   │                     │
│  │              │    │              │                     │
│  │ Background   │    │ Clear goal   │                     │
│  │ Environment  │    │ Success      │                     │
│  │ Constraints  │    │ criteria     │                     │
│  └──────────────┘    └──────────────┘                     │
│                                                            │
│  ┌──────────────┐    ┌──────────────┐                     │
│  │    RULES     │    │   EXAMPLES   │                     │
│  │              │    │              │                     │
│  │ Guidelines   │    │ Good/Bad     │                     │
│  │ Boundaries   │    │ patterns     │                     │
│  │ Requirements │    │ Expected     │                     │
│  └──────────────┘    └──────────────┘                     │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

### CORE Framework Breakdown

#### **C - Context**
Provide essential background information:
- What is the current state?
- What environment/tools are available?
- What constraints exist?

```markdown
## Context
- Working in a TypeScript monorepo with pnpm
- Using Next.js 15 with App Router
- Database: PostgreSQL with Prisma ORM
- Authentication: NextAuth.js v5
- Must maintain backward compatibility with v2 API
```

#### **O - Objective**
Define the clear, measurable goal:
- What should be accomplished?
- What does success look like?
- What is the expected output?

```markdown
## Objective
Create an MCP server that exposes our product catalog database to AI agents.

Success Criteria:
- AI can search products by name, category, or price range
- AI can retrieve detailed product information
- All queries must be read-only
- Response time under 500ms
```

#### **R - Rules**
Establish boundaries and requirements:
- What must always happen?
- What must never happen?
- What patterns should be followed?

```markdown
## Rules
- ALWAYS validate input parameters before database queries
- NEVER expose raw SQL to the AI agent
- ALWAYS return structured JSON responses
- NEVER include sensitive pricing or cost data
- ALWAYS log all tool invocations for audit
- Follow RESTful naming conventions for tools
```

#### **E - Examples**
Provide concrete examples:
- Show expected input/output patterns
- Demonstrate good vs. bad approaches
- Include edge cases

```markdown
## Examples

### Good Tool Definition
✅ Clear, specific, actionable:
{
  "name": "search_products",
  "description": "Search products by name, category, or price range. Returns max 50 results.",
  "parameters": {
    "query": "string - search term (min 2 chars)",
    "category": "string - optional category filter",
    "min_price": "number - optional minimum price",
    "max_price": "number - optional maximum price"
  }
}

### Bad Tool Definition
❌ Vague, missing constraints:
{
  "name": "get_stuff",
  "description": "Gets things from the database",
  "parameters": {
    "input": "the input"
  }
}
```

### Applying CORE to MCP Server Development

Here's a complete example of using CORE to design an MCP server:

```python
"""
MCP Server: Product Catalog API

CONTEXT:
- E-commerce platform with 50,000+ products
- PostgreSQL database with Prisma
- AI agents need read-only access for customer support

OBJECTIVE:
- Enable AI to answer product questions accurately
- Support search, filtering, and detail retrieval
- Maintain sub-500ms response times

RULES:
- All operations must be read-only
- Maximum 50 results per query
- Sanitize all inputs
- Log all requests

EXAMPLES:
- "Find blue running shoes under $100" → search_products(query="running shoes", color="blue", max_price=100)
- "Tell me about product SKU-12345" → get_product_details(sku="SKU-12345")
"""

from mcp.server import Server
import asyncio

server = Server("product-catalog")

@server.tool()
async def search_products(
    query: str,
    category: str = None,
    min_price: float = None,
    max_price: float = None,
    limit: int = 20
) -> dict:
    """
    Search products in the catalog.
    
    Context: Searches across product names, descriptions, and tags.
    Objective: Return relevant products matching the search criteria.
    Rules: 
      - Query must be at least 2 characters
      - Maximum 50 results (default 20)
      - Results sorted by relevance
    
    Examples:
      - search_products("laptop") → laptops sorted by relevance
      - search_products("nike", category="shoes", max_price=150) → Nike shoes under $150
    """
    # Validate inputs (RULES)
    if len(query) < 2:
        return {"error": "Query must be at least 2 characters"}
    
    limit = min(limit, 50)  # Enforce max limit
    
    # Execute search
    results = await db.search(
        query=query,
        category=category,
        price_range=(min_price, max_price),
        limit=limit
    )
    
    return {
        "count": len(results),
        "products": results
    }

@server.tool()
async def get_product_details(sku: str) -> dict:
    """
    Get detailed information about a specific product.
    
    Context: Retrieves full product data including specs, reviews, and availability.
    Objective: Provide comprehensive product information for customer inquiries.
    Rules:
      - SKU must be valid format (alphanumeric with dashes)
      - Returns 404-style error if product not found
    
    Examples:
      - get_product_details("SKU-12345") → Full product object
      - get_product_details("invalid") → {"error": "Product not found"}
    """
    # Validate SKU format
    if not is_valid_sku(sku):
        return {"error": "Invalid SKU format"}
    
    product = await db.get_product(sku)
    
    if not product:
        return {"error": "Product not found", "sku": sku}
    
    return product
```

### CORE + Context7: Powerful Combination

Combine CORE framework with Context7 for maximum effectiveness:

```
┌────────────────────────────────────────────────────────────┐
│          CORE + Context7 Development Workflow              │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  1. CONTEXT: Define your environment                       │
│     └─► Use Context7 to fetch current library docs         │
│                                                            │
│  2. OBJECTIVE: Set clear goals                             │
│     └─► What should the MCP server accomplish?             │
│                                                            │
│  3. RULES: Establish boundaries                            │
│     └─► Use Context7 for best practices & patterns         │
│                                                            │
│  4. EXAMPLES: Provide concrete patterns                    │
│     └─► Use Context7 for official code examples            │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

**Example Workflow**:

```markdown
## Building a Prisma MCP Server with CORE + Context7

### Step 1: Gather Context with Context7
AI calls: get-library-docs("/prisma/prisma", topic="CRUD operations")
→ Gets current Prisma syntax and patterns

### Step 2: Apply CORE Framework

**Context**: 
- Prisma 5.x with PostgreSQL
- User management domain
- [Context7 docs on Prisma Client API]

**Objective**:
- CRUD operations for users via MCP
- Support filtering, pagination, relations

**Rules**:
- [Context7 docs on Prisma best practices]
- Always use transactions for multi-step ops
- Validate email format before queries

**Examples**:
- [Context7 code samples for findMany, create, update]
```

### CORE Framework Checklist

Use this checklist when designing MCP servers or AI agent interactions:

- [ ] **Context**: Have I provided sufficient background?
  - [ ] Environment details (language, framework, versions)
  - [ ] Available resources and constraints
  - [ ] Current state and relevant history

- [ ] **Objective**: Is the goal crystal clear?
  - [ ] Specific, measurable outcome defined
  - [ ] Success criteria established
  - [ ] Expected output format specified

- [ ] **Rules**: Are boundaries well-defined?
  - [ ] Must-do requirements listed
  - [ ] Must-not-do prohibitions stated
  - [ ] Edge case handling defined

- [ ] **Examples**: Have I shown the pattern?
  - [ ] Good examples provided
  - [ ] Bad examples (anti-patterns) shown
  - [ ] Edge cases demonstrated

---

## Summary

MCP Server is the bridge between AI intelligence and real-world action. It transforms AI assistants from passive responders into active agents that can:

- **Read** data from any source
- **Write** changes to systems
- **Execute** complex workflows
- **Integrate** with existing infrastructure

For developers building AI-powered applications, MCP provides the standardized, secure, and extensible framework needed to create truly agentic AI systems that can take meaningful action in the world.

---

*MCP is an open protocol originally developed by Anthropic and now supported across the AI ecosystem including GitHub Copilot, Claude, and many other AI platforms.*
