# Tree of Thought (ToT) for Visual Studio 2026 Tools Development

**Date**: February 10, 2026  
**Context**: Visual Studio 2026 Extension & Tools Development with GitHub Copilot  
**Framework**: CORE (Context, Objective, Requirements, Examples)

---

## What is Tree of Thought?

Tree of Thought (ToT) is a prompting technique where you explore **multiple reasoning branches in parallel**, evaluate each branch against criteria, prune weak options, and converge on the best solution. Unlike Chain of Thought (linear step-by-step), ToT builds a **branching decision tree**.

**Think of it like a debugger** — you don't just step through one execution path. You consider multiple breakpoints, evaluate variable states at each, then focus on the path that leads to the root cause:

```
          [Current Problem]
         /        |         \
   Approach A  Approach B  Approach C
      /   \      |         /   \
   A1     A2    B1       C1    C2
   ✗      ✓     ✓        ✗     ✓
         Best → B1 (strongest after evaluation)
```

### CoT vs ToT at a Glance

| | Chain of Thought | Tree of Thought |
|---|---|---|
| **Structure** | Linear (Step 1 → 2 → 3) | Branching (explore → evaluate → prune) |
| **When to use** | Problem has one clear path | Problem has competing valid approaches |
| **Risk** | May lock into a suboptimal path early | More upfront work, but avoids dead ends |
| **Analogy** | Stepping through code | Debugging with multiple hypotheses |

---

## The CORE Framework for Prompts

Every prompt in this guide follows the **CORE** framework — a structured approach recommended by Microsoft and GitHub for effective Copilot interactions:

| Component | Description | Example |
|-----------|-------------|---------|
| **C**ontext | Background information, project type, constraints | "I'm building a VS2026 extension using VSIX..." |
| **O**bjective | What you want to achieve | "Create a custom tool window that displays..." |
| **R**equirements | Specific criteria, constraints, standards | "Must follow MVVM, support async loading..." |
| **E**xamples | Input/output examples, expected behavior | "When user clicks X, the tool should Y..." |

### CORE + ToT Integration

When combining CORE with Tree of Thought, structure your prompts like this:

```markdown
**Context**: [Project background, VS2026 environment, existing code]
**Objective**: [What you want to accomplish]
**Requirements**: [Evaluation criteria for branches]

**Use Tree of Thought reasoning:**
1. Generate 3 candidate approaches
2. Evaluate each against: [Requirement 1], [Requirement 2], [Requirement 3]
3. Prune the weakest branch and explain why
4. Produce final implementation

**Examples**: [Expected behavior, edge cases]
```

---

## Visual Studio 2026 Copilot Features

Visual Studio 2026 introduces several Copilot enhancements relevant to ToT prompting:

### Supported Features

| Feature | Description | ToT Application |
|---------|-------------|-----------------|
| **Copilot Chat in IDE** | Inline chat with workspace context | Primary interface for ToT prompts |
| **@workspace** | References entire solution context | Use for architecture decisions |
| **@terminal** | Access to terminal output | Evaluate build/test results per branch |
| **Multi-file editing** | Copilot Edits across files | Implement winning branch across solution |
| **Agent Mode** | Autonomous task completion | Execute ToT-selected implementation |
| **MCP Integration** | Model Context Protocol tools | Extend Copilot with custom tools |

### VS2026 Copilot Chat Commands

```
/explain     - Understand existing tool code
/fix         - Repair tool implementation issues  
/tests       - Generate tests for tool classes
/doc         - Document tool APIs
```

### Triggering ToT in VS2026 Copilot Chat

Start your prompt with explicit ToT instructions. VS2026 Copilot responds best to structured requests:

```markdown
@workspace Use Tree of Thought reasoning to solve this problem:
[Your CORE-formatted prompt here]
```

---

## Example 1: Custom Tool Window Architecture

### Scenario

You need to create a custom tool window in VS2026 that displays real-time diagnostic information from your solution's build process.

### ❌ Without Tree of Thought (Single Path)

**Prompt:**
> Create a tool window that shows build diagnostics.

**Problem with this approach:**
- Gets a generic implementation without evaluating alternatives
- May not consider async patterns, MVVM, or VS2026-specific APIs
- Misses opportunities for better architecture

### ✅ With Tree of Thought (CORE Framework)

**Prompt:**

```markdown
**Context**: 
I'm developing a Visual Studio 2026 extension (VSIX) that needs a custom tool window.
The extension targets VS2026 SDK and uses .NET 8. The tool window must display 
real-time build diagnostics including errors, warnings, and build duration.
Existing code uses Community.VisualStudio.Toolkit for simplified VS API access.

**Objective**: 
Design the architecture for a BuildDiagnosticsToolWindow that updates in real-time
during solution builds.

**Requirements**:
- Follow MVVM pattern (VS2026 extension best practice)
- Support async/await for all VS API calls (IAsyncServiceProvider)
- Handle multiple concurrent builds (batch builds)
- Integrate with VS2026 Output Window API for data source
- Must not block UI thread during build events

**Use Tree of Thought reasoning:**
1. Generate 3 architectural approaches:
   - A: Event-based with IBuildEvents subscription
   - B: Polling-based with IVsOutputWindow queries
   - C: MSBuild Logger integration with custom ILogger
2. Evaluate each against: real-time updates, thread safety, VS API compliance, testability
3. Lookahead: What happens with 50+ project solutions? With parallel builds?
4. Prune the weakest branch and explain why
5. Produce the final class structure with interface definitions

**Examples**:
- When build starts: Window shows "Building..." with progress indicator
- When error occurs: Error appears within 100ms in the diagnostics list
- When build completes: Summary row shows "Build succeeded: 2m 34s"
```

#### Step 1: Generate Candidate Branches

```
         [BuildDiagnosticsToolWindow Architecture]
         /                |                    \
    Branch A          Branch B              Branch C
   "IBuildEvents     "IVsOutputWindow      "MSBuild ILogger
    Subscription"     Polling"              Integration"
```

**Branch A — IBuildEvents Subscription**
```csharp
// Subscribe to VS build events via IVsBuildEvents
public class BuildDiagnosticsViewModel : IVsUpdateSolutionEvents2
{
    private IVsSolutionBuildManager2 _buildManager;
    
    public int UpdateSolution_Begin(ref int pfCancelUpdate) { /* capture start */ }
    public int UpdateSolution_Done(int fSucceeded, int fModified, int fCancelCommand) { /* capture end */ }
}
```
- Uses native VS SDK interfaces
- Event-driven, no polling overhead
- Requires COM interop knowledge

**Branch B — IVsOutputWindow Polling**
```csharp
// Poll the Output Window pane for new content
public class OutputWindowPoller
{
    private Timer _pollTimer;
    private IVsOutputWindowPane _buildPane;
    
    private void PollForNewContent() { /* read pane text, diff, extract errors */ }
}
```
- Simple to implement
- Text parsing is fragile
- Polling introduces latency

**Branch C — MSBuild ILogger Integration**
```csharp
// Custom MSBuild logger that forwards events
public class DiagnosticForwarderLogger : ILogger
{
    public void Initialize(IEventSource eventSource)
    {
        eventSource.ErrorRaised += OnErrorRaised;
        eventSource.WarningRaised += OnWarningRaised;
    }
}
```
- Rich structured data (not text parsing)
- Requires MSBuild host integration
- Works for command-line builds too

#### Step 2: Evaluate with Lookahead

| Criteria | A (IBuildEvents) | B (Polling) | C (MSBuild Logger) |
|----------|------------------|-------------|---------------------|
| **Real-time updates** | ✅ Event-driven, immediate | ❌ 100-500ms polling delay | ✅ Event-driven, immediate |
| **Thread safety** | ⚠️ Events fire on build thread | ✅ Timer controls thread | ⚠️ Logger callbacks on MSBuild threads |
| **VS API compliance** | ✅ Standard VS SDK pattern | ✅ Uses public APIs | ⚠️ Requires logger registration hack |
| **Testability** | ⚠️ Needs VS host mocks | ✅ Easy to mock timer | ✅ ILogger is easily mockable |
| **Lookahead: 50+ projects** | ✅ Events scale naturally | ❌ Polling becomes expensive | ✅ Per-project events scale |
| **Lookahead: Parallel builds** | ✅ Events include project context | ❌ Text output is interleaved | ✅ Structured events have project ID |
| **Implementation cost** | Medium (COM interop) | Low (simple timer) | High (logger registration) |

#### Step 3: Prune and Decide

```
         [BuildDiagnosticsToolWindow Architecture]
         /                |                    \
    Branch A          Branch B              Branch C
    ⭐ Best           ✗ Pruned              ⚠️ Complex
```

- **Branch B pruned** — Polling introduces latency, text parsing is fragile, doesn't scale to parallel builds where output interleaves
- **Branch C is powerful** but requires modifying MSBuild logger registration, which is invasive
- **Branch A selected** — Native VS SDK pattern, event-driven, handles parallel builds with project context

#### Step 4: Final Architecture (Branch A)

```csharp
// ViewModel - subscribes to build events, manages UI state
public class BuildDiagnosticsViewModel : ObservableObject, IVsUpdateSolutionEvents2, IVsUpdateSolutionEvents4
{
    private readonly IVsSolutionBuildManager5 _buildManager;
    private readonly ObservableCollection<DiagnosticItem> _diagnostics;
    private readonly object _syncLock = new();
    
    // Thread-safe update from build events to UI
    private void AddDiagnostic(DiagnosticItem item)
    {
        ThreadHelper.JoinableTaskFactory.RunAsync(async () =>
        {
            await ThreadHelper.JoinableTaskFactory.SwitchToMainThreadAsync();
            lock (_syncLock)
            {
                _diagnostics.Add(item);
            }
        });
    }
    
    // IVsUpdateSolutionEvents4 for VS2026 parallel build support
    public int UpdateProjectCfg_Begin(IVsHierarchy hierarchy, IVsCfg cfgProj, int fCancel)
    {
        // Track per-project build start
    }
}

// ToolWindow - MVVM host
[Guid("YOUR-GUID-HERE")]
public class BuildDiagnosticsToolWindow : ToolWindowPane
{
    public BuildDiagnosticsToolWindow() : base(null)
    {
        Caption = "Build Diagnostics";
        Content = new BuildDiagnosticsControl();
    }
}

// Package registration
[ProvideToolWindow(typeof(BuildDiagnosticsToolWindow), Style = VsDockStyle.Tabbed, Window = "DocumentWell")]
public sealed class BuildDiagnosticsPackage : AsyncPackage { }
```

#### Step 5: Verify Against Requirements

- [x] MVVM pattern (ViewModel + ToolWindowPane + UserControl)
- [x] Async/await for VS API calls (JoinableTaskFactory)
- [x] Handles concurrent builds (IVsUpdateSolutionEvents4)
- [x] Real-time updates (event-driven, no polling)
- [x] UI thread safe (SwitchToMainThreadAsync)

---

## Example 2: Code Analyzer Tool Implementation

### Scenario

You need to implement a Roslyn-based code analyzer that runs as a VS2026 extension and provides real-time feedback.

### ✅ With Tree of Thought (CORE Framework)

**Prompt:**

```markdown
**Context**:
Building a VS2026 extension that includes a custom Roslyn analyzer for detecting
insecure deserialization patterns. The analyzer must integrate with VS2026's 
Error List and provide code fixes. Current project uses .NET 8 and targets
the VS2026 extensibility SDK.

**Objective**:
Design the analyzer architecture that balances analysis depth vs. IDE responsiveness.

**Requirements**:
- Must not cause noticeable IDE lag during typing
- Detect BinaryFormatter usage across the solution
- Provide quick-fix to replace with System.Text.Json
- Support incremental analysis (don't re-analyze unchanged files)
- Follow Microsoft.CodeAnalysis.Analyzers best practices

**Use Tree of Thought reasoning:**
1. Generate 3 approaches for analysis timing:
   - A: Syntax-only analyzer (fast, runs on every keystroke)
   - B: Semantic analyzer (accurate, runs after compilation)
   - C: Hybrid (syntax for detection, semantic for confirmation)
2. Evaluate each against: accuracy, performance, false positive rate
3. Lookahead: What happens with 1000+ file solutions? During active debugging?
4. Prune and select the winner
5. Produce the analyzer class structure with registration attributes

**Examples**:
- Input: `var formatter = new BinaryFormatter();`
- Output: Warning INSEC001 at line, with code fix offering JsonSerializer replacement
```

#### Step 1: Generate Candidate Branches

```
         [Insecure Deserialization Analyzer]
         /              |                \
    Branch A        Branch B          Branch C
   "Syntax-Only"   "Semantic"        "Hybrid"
```

**Branch A — Syntax-Only Analyzer**
```csharp
[DiagnosticAnalyzer(LanguageNames.CSharp)]
public class SyntaxOnlyAnalyzer : DiagnosticAnalyzer
{
    public override void Initialize(AnalysisContext context)
    {
        context.RegisterSyntaxNodeAction(AnalyzeObjectCreation, 
            SyntaxKind.ObjectCreationExpression);
    }
    
    private void AnalyzeObjectCreation(SyntaxNodeAnalysisContext ctx)
    {
        // Check if identifier text == "BinaryFormatter"
        // Fast but may have false positives (custom class named BinaryFormatter)
    }
}
```

**Branch B — Semantic Analyzer**
```csharp
[DiagnosticAnalyzer(LanguageNames.CSharp)]
public class SemanticAnalyzer : DiagnosticAnalyzer
{
    public override void Initialize(AnalysisContext context)
    {
        context.RegisterOperationAction(AnalyzeObjectCreation,
            OperationKind.ObjectCreation);
    }
    
    private void AnalyzeObjectCreation(OperationAnalysisContext ctx)
    {
        var creation = (IObjectCreationOperation)ctx.Operation;
        var typeSymbol = creation.Type;
        // Check full type name: System.Runtime.Serialization.Formatters.Binary.BinaryFormatter
        // Accurate but requires semantic model (slower)
    }
}
```

**Branch C — Hybrid Analyzer**
```csharp
[DiagnosticAnalyzer(LanguageNames.CSharp)]
public class HybridAnalyzer : DiagnosticAnalyzer
{
    public override void Initialize(AnalysisContext context)
    {
        // Phase 1: Fast syntax check for candidates
        context.RegisterSyntaxNodeAction(QuickSyntaxCheck, 
            SyntaxKind.ObjectCreationExpression);
            
        // Phase 2: Semantic confirmation only for candidates
        context.RegisterSemanticModelAction(ConfirmWithSemantics);
    }
}
```

#### Step 2: Evaluate with Lookahead

| Criteria | A (Syntax-Only) | B (Semantic) | C (Hybrid) |
|----------|-----------------|--------------|------------|
| **Accuracy** | ❌ False positives on same-name classes | ✅ 100% accurate | ✅ 100% accurate |
| **Performance (typing)** | ✅ ~1ms per check | ⚠️ ~50ms requires semantic model | ✅ ~1ms syntax, deferred semantic |
| **False positive rate** | ❌ High in large codebases | ✅ Zero | ✅ Zero |
| **Lookahead: 1000+ files** | ✅ Scales linearly | ❌ Semantic model per file is slow | ✅ Syntax filters, semantic confirms |
| **Lookahead: During debugging** | ✅ No impact | ⚠️ May compete with debugger | ✅ Deferred analysis minimizes impact |
| **Implementation complexity** | ✅ Simple | ✅ Simple | ⚠️ Medium (two-phase coordination) |
| **Roslyn best practice** | ⚠️ Not recommended for type checks | ✅ Standard pattern | ✅ Documented optimization pattern |

#### Step 3: Prune and Decide

```
         [Insecure Deserialization Analyzer]
         /              |                \
    Branch A        Branch B          Branch C
    ✗ Pruned        ⭐ Selected       ⚠️ Overkill
```

- **Branch A pruned** — False positives unacceptable for security analyzer
- **Branch C overkill** — Hybrid adds complexity, semantic analysis is fast enough for this use case
- **Branch B selected** — Roslyn best practice, accurate, semantic overhead acceptable for security analyzer

**Rationale**: Security analyzers require zero false positives. The ~50ms semantic check is acceptable because:
1. Analyzers run incrementally (only changed files)
2. BinaryFormatter usage is rare (few checks triggered)
3. Accuracy is more important than speed for security findings

#### Step 4: Final Implementation (Branch B)

```csharp
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.Diagnostics;
using Microsoft.CodeAnalysis.Operations;
using System.Collections.Immutable;

[DiagnosticAnalyzer(LanguageNames.CSharp)]
public sealed class InsecureDeserializationAnalyzer : DiagnosticAnalyzer
{
    public const string DiagnosticId = "INSEC001";
    
    private static readonly LocalizableString Title = 
        "Insecure deserialization detected";
    private static readonly LocalizableString MessageFormat = 
        "'{0}' is vulnerable to deserialization attacks. Use System.Text.Json instead.";
    private static readonly LocalizableString Description = 
        "BinaryFormatter is insecure and should not be used for deserialization.";
    
    private static readonly DiagnosticDescriptor Rule = new(
        DiagnosticId,
        Title,
        MessageFormat,
        "Security",
        DiagnosticSeverity.Warning,
        isEnabledByDefault: true,
        description: Description,
        helpLinkUri: "https://aka.ms/binaryformatter-obsoletion");

    // Known insecure deserializers
    private static readonly ImmutableHashSet<string> InsecureTypes = ImmutableHashSet.Create(
        "System.Runtime.Serialization.Formatters.Binary.BinaryFormatter",
        "System.Runtime.Serialization.NetDataContractSerializer",
        "System.Web.UI.ObjectStateFormatter"
    );

    public override ImmutableArray<DiagnosticDescriptor> SupportedDiagnostics => 
        ImmutableArray.Create(Rule);

    public override void Initialize(AnalysisContext context)
    {
        context.ConfigureGeneratedCodeAnalysis(GeneratedCodeAnalysisFlags.None);
        context.EnableConcurrentExecution();
        
        context.RegisterOperationAction(AnalyzeObjectCreation, 
            OperationKind.ObjectCreation);
    }

    private void AnalyzeObjectCreation(OperationAnalysisContext context)
    {
        var creation = (IObjectCreationOperation)context.Operation;
        
        if (creation.Type is not INamedTypeSymbol typeSymbol)
            return;
            
        var fullName = typeSymbol.ToDisplayString();
        
        if (InsecureTypes.Contains(fullName))
        {
            var diagnostic = Diagnostic.Create(
                Rule,
                creation.Syntax.GetLocation(),
                typeSymbol.Name);
                
            context.ReportDiagnostic(diagnostic);
        }
    }
}
```

**Code Fix Provider:**

```csharp
[ExportCodeFixProvider(LanguageNames.CSharp, Name = nameof(InsecureDeserializationCodeFixProvider))]
[Shared]
public sealed class InsecureDeserializationCodeFixProvider : CodeFixProvider
{
    public override ImmutableArray<string> FixableDiagnosticIds => 
        ImmutableArray.Create(InsecureDeserializationAnalyzer.DiagnosticId);

    public override async Task RegisterCodeFixesAsync(CodeFixContext context)
    {
        var root = await context.Document.GetSyntaxRootAsync(context.CancellationToken);
        var diagnostic = context.Diagnostics.First();
        var diagnosticSpan = diagnostic.Location.SourceSpan;
        
        var declaration = root?.FindToken(diagnosticSpan.Start)
            .Parent?.AncestorsAndSelf()
            .OfType<ObjectCreationExpressionSyntax>()
            .First();

        if (declaration is null) return;

        context.RegisterCodeFix(
            CodeAction.Create(
                title: "Replace with JsonSerializer pattern",
                createChangedDocument: c => ReplaceWithJsonSerializer(context.Document, declaration, c),
                equivalenceKey: "ReplaceWithJsonSerializer"),
            diagnostic);
    }
    
    private async Task<Document> ReplaceWithJsonSerializer(
        Document document, 
        ObjectCreationExpressionSyntax oldNode,
        CancellationToken cancellationToken)
    {
        // Implementation: Replace BinaryFormatter instantiation with JsonSerializer usage pattern
        // Add using directive for System.Text.Json if not present
        // ...
    }
}
```

#### Step 5: Verify Against Requirements

- [x] No IDE lag (semantic analysis is incremental, concurrent execution enabled)
- [x] Detects BinaryFormatter (and other insecure deserializers)
- [x] Provides code fix (JsonSerializer replacement)
- [x] Incremental analysis (Roslyn handles this via operation registration)
- [x] Follows Microsoft.CodeAnalysis.Analyzers best practices

---

## Example 3: MCP Tool Server Implementation

### Scenario

You want to extend VS2026 Copilot with a custom MCP (Model Context Protocol) tool that queries your internal API documentation.

### ✅ With Tree of Thought (CORE Framework)

**Prompt:**

```markdown
**Context**:
VS2026 supports MCP (Model Context Protocol) for extending Copilot with custom tools.
I need to create an MCP server that allows Copilot to query our internal API 
documentation stored in a local SQLite database. The tool should be invocable
via Copilot Chat with prompts like "What are the parameters for CreateUser API?"

**Objective**:
Design an MCP tool server that provides API documentation lookup capabilities
to VS2026 Copilot.

**Requirements**:
- Must implement MCP protocol (JSON-RPC over stdio)
- Response time under 500ms for typical queries
- Support fuzzy matching on API names
- Return structured data (parameters, return types, examples)
- Run as a local process managed by VS2026

**Use Tree of Thought reasoning:**
1. Generate 3 implementation approaches:
   - A: Node.js MCP server (official SDK available)
   - B: C# MCP server (native to VS ecosystem)
   - C: Python MCP server (prototyping speed)
2. Evaluate each against: VS2026 integration, performance, maintainability, team skills
3. Lookahead: What if we need to add authentication? What about debugging the server?
4. Prune and select the winner
5. Produce the server structure with tool registration

**Examples**:
- User prompt: "@api-docs What parameters does CreateUser accept?"
- Tool input: { "query": "CreateUser parameters" }
- Tool output: { "endpoint": "/api/users", "method": "POST", "parameters": [...] }
```

#### Step 1: Generate Candidate Branches

```
         [MCP Tool Server for API Docs]
         /            |              \
    Branch A      Branch B        Branch C
   "Node.js"     "C# .NET 8"     "Python"
```

**Branch A — Node.js MCP Server**
```javascript
// Uses official @modelcontextprotocol/sdk
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';

const server = new Server({ name: 'api-docs', version: '1.0.0' }, {
    capabilities: { tools: {} }
});

server.setRequestHandler(ListToolsRequestSchema, async () => ({
    tools: [{ name: 'search_api', description: 'Search API documentation' }]
}));
```

**Branch B — C# .NET 8 MCP Server**
```csharp
// Custom MCP implementation using System.Text.Json
public class McpServer
{
    private readonly JsonRpcHandler _handler;
    
    public async Task RunAsync(Stream input, Stream output)
    {
        // Read JSON-RPC requests from stdin, write responses to stdout
        while (await ReadRequestAsync(input) is { } request)
        {
            var response = await HandleRequestAsync(request);
            await WriteResponseAsync(output, response);
        }
    }
}
```

**Branch C — Python MCP Server**
```python
# Uses mcp package
from mcp.server import Server
from mcp.server.stdio import stdio_server

app = Server("api-docs")

@app.tool()
async def search_api(query: str) -> str:
    # Query SQLite database
    return json.dumps(results)
```

#### Step 2: Evaluate with Lookahead

| Criteria | A (Node.js) | B (C# .NET 8) | C (Python) |
|----------|-------------|---------------|------------|
| **Official SDK** | ✅ Official MCP SDK | ❌ Must implement protocol | ✅ Official mcp package |
| **VS2026 integration** | ✅ VS2026 manages Node processes | ✅ Native .NET, best integration | ⚠️ Requires Python runtime |
| **Performance** | ✅ ~50ms cold start | ✅ ~100ms cold start, faster warm | ⚠️ ~500ms cold start |
| **SQLite access** | ⚠️ Needs better-sqlite3 native module | ✅ Microsoft.Data.Sqlite built-in | ✅ sqlite3 built-in |
| **Team skills** | ⚠️ Team is C#-focused | ✅ Team expertise | ❌ No Python expertise |
| **Lookahead: Auth** | ✅ Easy with node libraries | ✅ Easy with .NET auth | ✅ Easy with Python |
| **Lookahead: Debugging** | ⚠️ Node debugging in VS is limited | ✅ Full VS debugger support | ❌ Separate Python debugger |
| **Maintainability** | ⚠️ Separate ecosystem | ✅ Same ecosystem as extension | ❌ Different language |

#### Step 3: Prune and Decide

```
         [MCP Tool Server for API Docs]
         /            |              \
    Branch A      Branch B        Branch C
    ⚠️ Viable     ⭐ Selected     ✗ Pruned
```

- **Branch C pruned** — Team lacks Python expertise, cold start too slow, separate debugging workflow
- **Branch A is viable** but adds Node.js dependency to a C# team's workflow
- **Branch B selected** — Native VS2026 debugging, same ecosystem, team expertise matches

**Note**: Branch B requires implementing MCP protocol since no official C# SDK exists. This is acceptable because:
1. MCP protocol is simple (JSON-RPC over stdio)
2. One-time implementation cost, reusable across tools
3. Full debugging support outweighs SDK convenience

#### Step 4: Final Implementation (Branch B)

```csharp
// McpServer.cs - Core MCP protocol handler
using System.Text.Json;
using System.Text.Json.Serialization;

public class McpServer
{
    private readonly Dictionary<string, Func<JsonElement, Task<object>>> _tools = new();
    
    public void RegisterTool(string name, string description, Func<JsonElement, Task<object>> handler)
    {
        _tools[name] = handler;
    }
    
    public async Task RunAsync(CancellationToken cancellationToken = default)
    {
        using var stdin = Console.OpenStandardInput();
        using var stdout = Console.OpenStandardOutput();
        using var reader = new StreamReader(stdin);
        using var writer = new StreamWriter(stdout) { AutoFlush = true };
        
        while (!cancellationToken.IsCancellationRequested)
        {
            var line = await reader.ReadLineAsync(cancellationToken);
            if (line is null) break;
            
            var request = JsonSerializer.Deserialize<JsonRpcRequest>(line);
            var response = await HandleRequestAsync(request);
            await writer.WriteLineAsync(JsonSerializer.Serialize(response));
        }
    }
    
    private async Task<JsonRpcResponse> HandleRequestAsync(JsonRpcRequest request)
    {
        return request.Method switch
        {
            "initialize" => HandleInitialize(request),
            "tools/list" => HandleListTools(request),
            "tools/call" => await HandleToolCall(request),
            _ => CreateErrorResponse(request.Id, -32601, "Method not found")
        };
    }
    
    private async Task<JsonRpcResponse> HandleToolCall(JsonRpcRequest request)
    {
        var toolName = request.Params.GetProperty("name").GetString();
        var arguments = request.Params.GetProperty("arguments");
        
        if (_tools.TryGetValue(toolName, out var handler))
        {
            var result = await handler(arguments);
            return new JsonRpcResponse { Id = request.Id, Result = result };
        }
        
        return CreateErrorResponse(request.Id, -32602, $"Unknown tool: {toolName}");
    }
}

// ApiDocsToolServer.cs - API documentation tool implementation
public class ApiDocsToolServer
{
    private readonly McpServer _server;
    private readonly ApiDocumentationDb _db;
    
    public ApiDocsToolServer(string dbPath)
    {
        _server = new McpServer();
        _db = new ApiDocumentationDb(dbPath);
        
        _server.RegisterTool(
            name: "search_api",
            description: "Search internal API documentation by endpoint name or description",
            handler: SearchApiAsync);
            
        _server.RegisterTool(
            name: "get_api_details",
            description: "Get full details for a specific API endpoint",
            handler: GetApiDetailsAsync);
    }
    
    private async Task<object> SearchApiAsync(JsonElement arguments)
    {
        var query = arguments.GetProperty("query").GetString();
        var results = await _db.FuzzySearchAsync(query, limit: 10);
        
        return new
        {
            results = results.Select(r => new
            {
                endpoint = r.Endpoint,
                method = r.HttpMethod,
                summary = r.Summary,
                relevance = r.Score
            })
        };
    }
    
    private async Task<object> GetApiDetailsAsync(JsonElement arguments)
    {
        var endpoint = arguments.GetProperty("endpoint").GetString();
        var details = await _db.GetDetailsAsync(endpoint);
        
        return new
        {
            endpoint = details.Endpoint,
            method = details.HttpMethod,
            description = details.Description,
            parameters = details.Parameters,
            requestBody = details.RequestBodySchema,
            responses = details.Responses,
            examples = details.Examples
        };
    }
    
    public Task RunAsync(CancellationToken cancellationToken = default) 
        => _server.RunAsync(cancellationToken);
}

// Program.cs - Entry point
public class Program
{
    public static async Task Main(string[] args)
    {
        var dbPath = args.Length > 0 ? args[0] : "api-docs.db";
        var server = new ApiDocsToolServer(dbPath);
        await server.RunAsync();
    }
}
```

**VS2026 MCP Configuration (mcp.json):**

```json
{
  "servers": {
    "api-docs": {
      "type": "stdio",
      "command": "dotnet",
      "args": ["run", "--project", "${workspaceFolder}/tools/ApiDocsMcp"],
      "env": {
        "API_DOCS_DB": "${workspaceFolder}/data/api-docs.db"
      }
    }
  }
}
```

#### Step 5: Verify Against Requirements

- [x] MCP protocol (JSON-RPC over stdio implemented)
- [x] Response time < 500ms (SQLite with proper indexes, .NET performance)
- [x] Fuzzy matching (FuzzySearchAsync implementation)
- [x] Structured data (parameters, return types, examples in response)
- [x] Local process (managed via mcp.json configuration)

---

## Example 4: VS Extension Command Architecture

### Scenario

You need to implement a VS2026 extension with multiple commands that share common functionality (logging, error handling, telemetry).

### ✅ With Tree of Thought (CORE Framework)

**Prompt:**

```markdown
**Context**:
Building a VS2026 productivity extension with 15+ commands (format code, generate tests,
analyze dependencies, etc.). Commands share common concerns: logging to Output Window,
error handling with user-friendly dialogs, telemetry for usage analytics.
Currently using Community.VisualStudio.Toolkit for simplified command registration.

**Objective**:
Design a command architecture that maximizes code reuse and testability while 
following VS2026 extension best practices.

**Requirements**:
- All commands must log execution start/end to Output Window
- All commands must catch exceptions and show consistent error dialogs
- All commands must send telemetry events (command name, duration, success/failure)
- Commands should be testable without VS host
- Must support async commands with cancellation
- Follow AsyncPackage best practices for VS2026

**Use Tree of Thought reasoning:**
1. Generate 3 architectural patterns:
   - A: Base class inheritance (abstract BaseCommand)
   - B: Decorator pattern (wrap handlers with cross-cutting concerns)
   - C: Middleware pipeline (like ASP.NET Core)
2. Evaluate each against: code reuse, testability, extensibility, VS SDK compliance
3. Lookahead: What if we add 10 more cross-cutting concerns? What about command dependencies?
4. Prune and select the winner
5. Produce the base infrastructure code with one example command

**Examples**:
- Command executes successfully: Logs start/end, sends success telemetry
- Command throws exception: Catches, logs error, shows dialog, sends failure telemetry
- Command cancelled by user: Logs cancellation, sends cancelled telemetry
```

#### Step 1: Generate Candidate Branches

```
         [Command Architecture]
         /          |            \
    Branch A    Branch B      Branch C
   "Base Class" "Decorator"  "Middleware
    Inheritance" Pattern"     Pipeline"
```

**Branch A — Base Class Inheritance**
```csharp
public abstract class BaseCommand<TCommand> : BaseCommand where TCommand : class, new()
{
    protected abstract Task ExecuteCoreAsync(CancellationToken cancellationToken);
    
    protected override async Task ExecuteAsync(OleMenuCmdEventArgs e)
    {
        using var _ = _logger.BeginScope(GetType().Name);
        var sw = Stopwatch.StartNew();
        try
        {
            _logger.LogInformation("Command started");
            await ExecuteCoreAsync(DisposalToken);
            _telemetry.TrackSuccess(GetType().Name, sw.Elapsed);
        }
        catch (OperationCanceledException)
        {
            _telemetry.TrackCancelled(GetType().Name, sw.Elapsed);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Command failed");
            await ShowErrorDialogAsync(ex);
            _telemetry.TrackFailure(GetType().Name, sw.Elapsed, ex);
        }
    }
}
```

**Branch B — Decorator Pattern**
```csharp
public interface ICommandHandler
{
    Task ExecuteAsync(CommandContext context, CancellationToken ct);
}

public class LoggingDecorator : ICommandHandler
{
    private readonly ICommandHandler _inner;
    public async Task ExecuteAsync(CommandContext ctx, CancellationToken ct)
    {
        _logger.LogInformation($"Starting {ctx.CommandName}");
        await _inner.ExecuteAsync(ctx, ct);
        _logger.LogInformation($"Completed {ctx.CommandName}");
    }
}

public class TelemetryDecorator : ICommandHandler { /* wrap with telemetry */ }
public class ErrorHandlingDecorator : ICommandHandler { /* wrap with try/catch */ }
```

**Branch C — Middleware Pipeline**
```csharp
public class CommandPipeline
{
    private readonly List<Func<CommandDelegate, CommandDelegate>> _middleware = new();
    
    public CommandPipeline Use(Func<CommandDelegate, CommandDelegate> middleware)
    {
        _middleware.Add(middleware);
        return this;
    }
    
    public CommandDelegate Build(CommandDelegate handler)
    {
        return _middleware.Reverse().Aggregate(handler, (next, mw) => mw(next));
    }
}

// Usage
var pipeline = new CommandPipeline()
    .Use(LoggingMiddleware)
    .Use(TelemetryMiddleware)
    .Use(ErrorHandlingMiddleware);
```

#### Step 2: Evaluate with Lookahead

| Criteria | A (Base Class) | B (Decorator) | C (Middleware) |
|----------|----------------|---------------|----------------|
| **Code reuse** | ✅ All logic in base | ✅ Decorators reusable | ✅ Middleware reusable |
| **Testability** | ⚠️ Need to test through base | ✅ Each decorator testable | ✅ Each middleware testable |
| **VS SDK compliance** | ✅ Matches Toolkit patterns | ⚠️ Custom abstraction layer | ⚠️ Custom abstraction layer |
| **Complexity** | ✅ Simple, familiar | ⚠️ Wrapping order matters | ⚠️ Pipeline setup overhead |
| **Lookahead: 10 more concerns** | ❌ Base class becomes bloated | ✅ Add more decorators | ✅ Add more middleware |
| **Lookahead: Command dependencies** | ⚠️ Hard to inject per-command | ✅ Context bag pattern | ✅ Context flows through |
| **Team familiarity** | ✅ Standard OOP | ⚠️ Less common pattern | ✅ Familiar from ASP.NET |
| **Debuggability** | ✅ Single stack frame | ⚠️ Deep call stack | ⚠️ Pipeline indirection |

#### Step 3: Prune and Decide

```
         [Command Architecture]
         /          |            \
    Branch A    Branch B      Branch C
    ⭐ Selected  ⚠️ Overkill   ✗ Pruned
```

- **Branch C pruned** — Middleware pipeline is powerful but overkill for 15 commands; adds abstraction without proportional benefit
- **Branch B viable** for larger systems but decorator wrapping adds complexity
- **Branch A selected** — Matches VS Toolkit patterns, simple to understand, base class won't bloat with 3-5 cross-cutting concerns

**Enhancement**: Combine A with composition — base class handles common concerns, but delegates to injectable services for flexibility:

```csharp
// Base class uses injected services, not hardcoded logic
protected override async Task ExecuteAsync(OleMenuCmdEventArgs e)
{
    await _commandExecutor.ExecuteWithCrossCuttingAsync(
        commandName: GetType().Name,
        handler: ExecuteCoreAsync,
        cancellationToken: DisposalToken);
}
```

#### Step 4: Final Implementation (Branch A with Composition)

```csharp
// ICommandExecutor.cs - Abstracts cross-cutting concerns
public interface ICommandExecutor
{
    Task ExecuteWithCrossCuttingAsync(
        string commandName,
        Func<CancellationToken, Task> handler,
        CancellationToken cancellationToken);
}

// CommandExecutor.cs - Implements cross-cutting concerns
public class CommandExecutor : ICommandExecutor
{
    private readonly IOutputWindowLogger _logger;
    private readonly ITelemetryService _telemetry;
    private readonly IErrorDialogService _errorDialog;
    
    public CommandExecutor(
        IOutputWindowLogger logger,
        ITelemetryService telemetry,
        IErrorDialogService errorDialog)
    {
        _logger = logger;
        _telemetry = telemetry;
        _errorDialog = errorDialog;
    }
    
    public async Task ExecuteWithCrossCuttingAsync(
        string commandName,
        Func<CancellationToken, Task> handler,
        CancellationToken cancellationToken)
    {
        var sw = Stopwatch.StartNew();
        
        try
        {
            await _logger.LogAsync($"[{commandName}] Starting...");
            await handler(cancellationToken);
            await _logger.LogAsync($"[{commandName}] Completed in {sw.ElapsedMilliseconds}ms");
            _telemetry.TrackCommand(commandName, sw.Elapsed, CommandResult.Success);
        }
        catch (OperationCanceledException)
        {
            await _logger.LogAsync($"[{commandName}] Cancelled after {sw.ElapsedMilliseconds}ms");
            _telemetry.TrackCommand(commandName, sw.Elapsed, CommandResult.Cancelled);
        }
        catch (Exception ex)
        {
            await _logger.LogErrorAsync($"[{commandName}] Failed: {ex.Message}");
            await _errorDialog.ShowAsync(commandName, ex);
            _telemetry.TrackCommand(commandName, sw.Elapsed, CommandResult.Failure, ex);
            throw; // Re-throw for VS error handling
        }
    }
}

// BaseProductivityCommand.cs - Abstract base for all commands
public abstract class BaseProductivityCommand<T> : BaseCommand<T> where T : class, new()
{
    protected ICommandExecutor CommandExecutor { get; private set; }
    
    protected abstract Task ExecuteCoreAsync(CancellationToken cancellationToken);
    
    protected override async Task InitializeCompletedAsync()
    {
        CommandExecutor = await Package.GetServiceAsync<ICommandExecutor>();
    }
    
    protected override async Task ExecuteAsync(OleMenuCmdEventArgs e)
    {
        await CommandExecutor.ExecuteWithCrossCuttingAsync(
            commandName: GetType().Name,
            handler: ExecuteCoreAsync,
            cancellationToken: DisposalToken);
    }
}

// FormatCodeCommand.cs - Example command implementation
[Command(PackageIds.FormatCodeCommand)]
public class FormatCodeCommand : BaseProductivityCommand<FormatCodeCommand>
{
    protected override async Task ExecuteCoreAsync(CancellationToken cancellationToken)
    {
        var docView = await VS.Documents.GetActiveDocumentViewAsync();
        if (docView?.TextBuffer is null) return;
        
        var formatter = await Package.GetServiceAsync<ICodeFormatterService>();
        await formatter.FormatDocumentAsync(docView.TextBuffer, cancellationToken);
    }
}

// GenerateTestsCommand.cs - Another example command
[Command(PackageIds.GenerateTestsCommand)]
public class GenerateTestsCommand : BaseProductivityCommand<GenerateTestsCommand>
{
    protected override async Task ExecuteCoreAsync(CancellationToken cancellationToken)
    {
        var selection = await VS.Editor.GetSelectedTextAsync();
        if (string.IsNullOrEmpty(selection)) return;
        
        var generator = await Package.GetServiceAsync<ITestGeneratorService>();
        var tests = await generator.GenerateAsync(selection, cancellationToken);
        
        await VS.Documents.CreateNewDocumentAsync("GeneratedTests.cs", tests);
    }
}
```

**Package Registration:**

```csharp
[ProvideService(typeof(ICommandExecutor), ServiceName = "CommandExecutor")]
[ProvideService(typeof(IOutputWindowLogger), ServiceName = "OutputWindowLogger")]
[ProvideService(typeof(ITelemetryService), ServiceName = "TelemetryService")]
public sealed class ProductivityPackage : ToolkitPackage
{
    protected override async Task InitializeAsync(CancellationToken cancellationToken, IProgress<ServiceProgressData> progress)
    {
        // Register services
        AddService(typeof(IOutputWindowLogger), (_, _, _) => 
            Task.FromResult<object>(new OutputWindowLogger(this)));
        AddService(typeof(ITelemetryService), (_, _, _) => 
            Task.FromResult<object>(new TelemetryService()));
        AddService(typeof(ICommandExecutor), async (container, _, _) =>
        {
            var logger = await container.GetServiceAsync(typeof(IOutputWindowLogger)) as IOutputWindowLogger;
            var telemetry = await container.GetServiceAsync(typeof(ITelemetryService)) as ITelemetryService;
            return new CommandExecutor(logger, telemetry, new ErrorDialogService());
        });
        
        await this.RegisterCommandsAsync();
    }
}
```

#### Step 5: Verify Against Requirements

- [x] Logging to Output Window (IOutputWindowLogger in CommandExecutor)
- [x] Consistent error dialogs (IErrorDialogService with standard UI)
- [x] Telemetry events (ITelemetryService tracks name, duration, result)
- [x] Testable without VS host (ICommandExecutor can be mocked)
- [x] Async with cancellation (CancellationToken flows through)
- [x] AsyncPackage best practices (ToolkitPackage base, service registration)

---

## Example 5: Build Task Integration

### Scenario

You need to create a custom build task that integrates with VS2026's build system and provides progress reporting.

### ✅ With Tree of Thought (CORE Framework)

**Prompt:**

```markdown
**Context**:
Creating a VS2026 extension that adds a custom pre-build task. The task validates
configuration files against a schema before the build starts. The extension targets
VS2026 SDK and needs to integrate with Solution Explorer context menus and the Build menu.

**Objective**:
Design a build task that validates config files, reports progress, and can fail the 
build with meaningful error messages.

**Requirements**:
- Integrate with VS2026 build pipeline (run before compilation)
- Report progress in Build Output window
- Fail build with Error List entries on validation failure
- Support cancellation (when user cancels build)
- Work with both single-project and solution-wide builds

**Use Tree of Thought reasoning:**
1. Generate 3 integration approaches:
   - A: IVsBuildableProjectCfg implementation (deep VS integration)
   - B: MSBuild custom target in .targets file (standard MSBuild)
   - C: Pre-build event command (simple, uses existing hook)
2. Evaluate each against: VS2026 integration, error reporting, cancellation support, deployment complexity
3. Lookahead: What if validation takes 30 seconds? What about incremental builds?
4. Prune and select the winner
5. Produce the implementation with registration

**Examples**:
- Valid config: Build proceeds normally, "Config validation passed" in Output
- Invalid config: Build fails, Error List shows "Invalid schema at line 42"
- Build cancelled: Validation stops, no partial errors reported
```

#### Step 1: Generate Candidate Branches

```
         [Build Task Integration]
         /            |               \
    Branch A      Branch B          Branch C
   "IVsBuild*"   "MSBuild Target"  "Pre-build
    Interface"                       Event"
```

**Branch A — IVsBuildableProjectCfg**
```csharp
public class ConfigValidationBuildTask : IVsBuildableProjectCfg2
{
    public int StartBuild(IVsOutputWindowPane pane, uint dwOptions)
    {
        // Direct integration with VS build system
        // Full control over build pipeline
    }
}
```

**Branch B — MSBuild Custom Target**
```xml
<!-- ConfigValidation.targets -->
<Target Name="ValidateConfigs" BeforeTargets="BeforeBuild">
  <ValidateConfigTask ConfigFiles="@(ConfigFiles)" SchemaPath="$(SchemaPath)" />
</Target>
```
```csharp
public class ValidateConfigTask : Microsoft.Build.Utilities.Task
{
    public override bool Execute()
    {
        // Standard MSBuild task
        // Works in VS, CLI, CI/CD
    }
}
```

**Branch C — Pre-build Event**
```xml
<PropertyGroup>
  <PreBuildEvent>dotnet tool run config-validator $(ProjectDir)</PreBuildEvent>
</PropertyGroup>
```

#### Step 2: Evaluate with Lookahead

| Criteria | A (IVsBuild*) | B (MSBuild Target) | C (Pre-build Event) |
|----------|---------------|--------------------|--------------------|
| **VS2026 integration** | ✅ Deep, full control | ✅ Standard, well-supported | ⚠️ Basic, text output only |
| **Error reporting** | ✅ IVsOutputWindowPane | ✅ MSBuild errors → Error List | ❌ Console text only |
| **Cancellation** | ✅ IVsBuildStatusCallback | ✅ CancellationToken | ❌ Process kill |
| **Progress reporting** | ✅ Rich VS progress APIs | ⚠️ Log.LogMessage only | ❌ None |
| **CLI/CI compatibility** | ❌ VS-only | ✅ Works everywhere | ✅ Works everywhere |
| **Lookahead: 30s validation** | ✅ Async, non-blocking | ⚠️ Blocks MSBuild thread | ❌ Blocks, no feedback |
| **Lookahead: Incremental** | ⚠️ Must implement caching | ✅ MSBuild inputs/outputs | ❌ Always runs |
| **Deployment complexity** | ❌ VSIX required | ✅ NuGet package distributes targets | ✅ Simple |

#### Step 3: Prune and Decide

```
         [Build Task Integration]
         /            |               \
    Branch A      Branch B          Branch C
    ⚠️ Overkill   ⭐ Selected       ✗ Pruned
```

- **Branch C pruned** — No progress, no Error List integration, no cancellation
- **Branch A is powerful** but VS-only; validation should work in CI/CD
- **Branch B selected** — Standard MSBuild, Error List integration, works in VS + CLI + CI/CD

#### Step 4: Final Implementation (Branch B)

```csharp
// ValidateConfigTask.cs - MSBuild custom task
using Microsoft.Build.Framework;
using Microsoft.Build.Utilities;
using System.Text.Json;

public class ValidateConfigTask : Task, ICancelableTask
{
    private CancellationTokenSource _cts = new();
    
    [Required]
    public ITaskItem[] ConfigFiles { get; set; }
    
    [Required]
    public string SchemaPath { get; set; }
    
    [Output]
    public int ValidatedCount { get; set; }
    
    public override bool Execute()
    {
        var schema = LoadSchema(SchemaPath);
        var hasErrors = false;
        ValidatedCount = 0;
        
        foreach (var configFile in ConfigFiles)
        {
            if (_cts.Token.IsCancellationRequested)
            {
                Log.LogMessage(MessageImportance.High, "Config validation cancelled.");
                return false;
            }
            
            var filePath = configFile.GetMetadata("FullPath");
            Log.LogMessage(MessageImportance.Normal, $"Validating: {filePath}");
            
            var errors = ValidateFile(filePath, schema);
            
            foreach (var error in errors)
            {
                // MSBuild error format → appears in Error List
                Log.LogError(
                    subcategory: "ConfigValidation",
                    errorCode: "CFG001",
                    helpKeyword: null,
                    file: filePath,
                    lineNumber: error.Line,
                    columnNumber: error.Column,
                    endLineNumber: error.Line,
                    endColumnNumber: error.Column + error.Length,
                    message: error.Message);
                hasErrors = true;
            }
            
            if (!errors.Any())
            {
                ValidatedCount++;
            }
        }
        
        if (!hasErrors)
        {
            Log.LogMessage(MessageImportance.High, 
                $"Config validation passed: {ValidatedCount} files validated.");
        }
        
        return !hasErrors;
    }
    
    public void Cancel()
    {
        _cts.Cancel();
    }
    
    private JsonDocument LoadSchema(string path)
    {
        var json = File.ReadAllText(path);
        return JsonDocument.Parse(json);
    }
    
    private IEnumerable<ValidationError> ValidateFile(string filePath, JsonDocument schema)
    {
        // Implementation: JSON Schema validation
        // Returns line/column positions for each error
        yield break; // Placeholder
    }
}

public record ValidationError(int Line, int Column, int Length, string Message);
```

**ConfigValidation.targets:**

```xml
<?xml version="1.0" encoding="utf-8"?>
<Project xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  
  <!-- Define item group for config files -->
  <ItemGroup>
    <ConfigFiles Include="**/*.config.json" />
  </ItemGroup>
  
  <!-- Import the task -->
  <UsingTask 
    TaskName="ValidateConfigTask" 
    AssemblyFile="$(MSBuildThisFileDirectory)..\lib\net8.0\ConfigValidation.dll" />
  
  <!-- Run before build, with incremental support -->
  <Target Name="ValidateConfigs" 
          BeforeTargets="BeforeBuild"
          Inputs="@(ConfigFiles);$(SchemaPath)"
          Outputs="$(IntermediateOutputPath)config-validation.marker">
    
    <ValidateConfigTask 
      ConfigFiles="@(ConfigFiles)" 
      SchemaPath="$(MSBuildProjectDirectory)\config.schema.json">
      <Output TaskParameter="ValidatedCount" PropertyName="ValidatedConfigCount" />
    </ValidateConfigTask>
    
    <!-- Touch marker file for incremental builds -->
    <Touch Files="$(IntermediateOutputPath)config-validation.marker" AlwaysCreate="true" />
    
    <Message Text="Validated $(ValidatedConfigCount) config files." Importance="high" />
  </Target>
  
</Project>
```

**NuGet Package Structure:**

```
ConfigValidation.nupkg/
├── build/
│   └── ConfigValidation.targets    # Auto-imported by NuGet
├── lib/
│   └── net8.0/
│       └── ConfigValidation.dll    # Task implementation
└── ConfigValidation.nuspec
```

#### Step 5: Verify Against Requirements

- [x] VS2026 build pipeline integration (BeforeTargets="BeforeBuild")
- [x] Progress in Build Output (Log.LogMessage)
- [x] Error List entries (Log.LogError with file/line/column)
- [x] Cancellation support (ICancelableTask)
- [x] Solution-wide builds (MSBuild handles multi-project)
- [x] Incremental builds (Inputs/Outputs on Target)

---

## Example 6: GitHub SDK Integration in WPF Model Studio

### Scenario

The Model Studio WPF application needs GitHub integration so developers can browse remote model repositories, download assets directly from GitHub releases, and manage model import issues — all from within the desktop tool. You need to decide how to integrate the GitHub SDK into the existing WPF + MVVM + DI architecture.

### Context: Model Studio Architecture

Model Studio is a .NET 8 WPF application (`net8.0-windows`) using:
- **MVVM** via CommunityToolkit.Mvvm source generators
- **DI** via Microsoft.Extensions.DependencyInjection
- **AvalonDock** docking layout with 5 ViewModels
- **Core library** (`ModelStudio.Core`, `net8.0`) — must remain WPF-free
- **BlenderBridge** (`ModelStudio.BlenderBridge`, `net8.0`) — Blender CLI integration

### ❌ Without Tree of Thought (Single Path)

**Prompt:**
> Add the GitHub SDK to Model Studio so we can download models from GitHub.

**Problem with this approach:**
- Doesn't evaluate which GitHub SDK package is best for a WPF desktop app
- May violate the architecture rule that `ModelStudio.Core` must never reference WPF
- Skips authentication strategy (PAT vs OAuth Device Flow vs GitHub App)
- Ignores the existing DI registration pattern in `App.xaml.cs`

### ✅ With Tree of Thought (CORE Framework)

**Prompt:**

```markdown
**Context**: 
Model Studio is a WPF desktop app (net8.0-windows) in the Urban Survivor game project.
It uses CommunityToolkit.Mvvm, Microsoft.Extensions.DependencyInjection, and AvalonDock.
The solution has a strict layering rule: ModelStudio.Core (net8.0) must never reference
WPF or UI packages — it contains models, validation, analysis, and import services.
The WPF app project (ModelStudio) registers all services in App.xaml.cs via
ServiceCollection. ViewModels use [ObservableProperty] and [RelayCommand] source
generators, and all I/O is async (never blocking the UI thread).

The NuGet config (`tools/model_studio/nuget.config`) clears inherited sources and
uses only nuget.org — this is intentional due to a broken GitHub Packages source upstream.

**Objective**: 
Integrate a GitHub SDK into Model Studio so developers can:
1. Authenticate with GitHub (personal or org accounts)
2. Browse repositories for 3D model assets (.glb, .fbx, .obj files)
3. Download release assets directly into the import pipeline
4. Create GitHub Issues for model validation failures (bug reports)

**Requirements**:
- Must respect the Core/WPF layering rule (GitHub service logic in Core, not WPF)
- Must register via DI in App.xaml.cs (constructor injection, no service locator)
- Must use async/await for all GitHub API calls (never block UI thread)
- Must handle authentication securely (no hardcoded tokens)
- Must follow CommunityToolkit.Mvvm patterns ([ObservableProperty], [RelayCommand])
- Must work behind corporate proxies (many game studios use them)

**Use Tree of Thought reasoning:**
1. Generate 3 SDK integration approaches:
   - A: Octokit.net (official GitHub .NET SDK) with OAuth Device Flow
   - B: Octokit.net with Personal Access Token (PAT) configuration
   - C: Raw HttpClient with GitHub REST API v3 and PAT
2. Evaluate each against: DI compatibility, auth UX, proxy support, maintainability, API coverage
3. Lookahead: What if we need GraphQL for complex repo queries? What about rate limiting?
4. Prune the weakest branch and explain why
5. Produce the final service interfaces, DI registration, and ViewModel integration

**Examples**:
- User clicks "Connect to GitHub": OAuth Device Flow shows code + URL, user authorizes in browser
- User browses repo: TreeView shows repository files filtered to .glb/.fbx/.obj
- User downloads asset: Progress bar shows download, file enters import pipeline automatically
- Network error: Status bar shows "GitHub: connection failed — check proxy settings"
```

#### Step 1: Generate Candidate Branches

```
         [GitHub SDK Integration in Model Studio]
         /                  |                      \
    Branch A            Branch B                Branch C
   "Octokit.net +      "Octokit.net +          "Raw HttpClient +
    OAuth Device Flow"  PAT Config"             GitHub REST API"
```

**Branch A — Octokit.net with OAuth Device Flow**
```csharp
// NuGet: Octokit (latest stable)
// Auth: OAuth Device Flow — user gets a code, opens browser, authorizes
public class GitHubAuthService : IGitHubAuthService
{
    public async Task<GitHubClient> AuthenticateAsync(CancellationToken ct)
    {
        var client = new GitHubClient(new ProductHeaderValue("ModelStudio"));
        var request = new OauthDeviceFlowRequest("YOUR_CLIENT_ID");
        var deviceFlow = await client.Oauth.InitiateDeviceFlow(request);
        // Show code to user, poll for authorization
        var token = await client.Oauth.CreateAccessTokenForDeviceFlow(
            "YOUR_CLIENT_ID", deviceFlow, ct);
        client.Credentials = new Credentials(token.AccessToken);
        return client;
    }
}
```
- Full OAuth flow, no token management by user
- Requires GitHub OAuth App registration (client ID)
- Best UX for end users — browser-based authorization
- Device Flow works for desktop apps (no redirect URI needed)

**Branch B — Octokit.net with Personal Access Token**
```csharp
// NuGet: Octokit (latest stable)
// Auth: User provides PAT via settings UI, stored in user config
public class GitHubAuthService : IGitHubAuthService
{
    public Task<GitHubClient> AuthenticateAsync(string personalAccessToken)
    {
        var client = new GitHubClient(new ProductHeaderValue("ModelStudio"));
        client.Credentials = new Credentials(personalAccessToken);
        return Task.FromResult(client);
    }
}
```
- Simple — user creates PAT on github.com, pastes into settings
- No OAuth App registration needed
- User manages their own token lifecycle
- PAT storage must be secure (Windows Credential Manager or DPAPI)

**Branch C — Raw HttpClient with GitHub REST API**
```csharp
// No SDK — direct HTTP calls to api.github.com
public class GitHubApiClient : IGitHubApiClient
{
    private readonly HttpClient _http;

    public async Task<IReadOnlyList<Repository>> GetRepositoriesAsync(string org, CancellationToken ct)
    {
        var response = await _http.GetAsync($"https://api.github.com/orgs/{org}/repos", ct);
        response.EnsureSuccessStatusCode();
        return await response.Content.ReadFromJsonAsync<List<Repository>>(ct);
    }
}
```
- No SDK dependency — full control over HTTP calls
- Must manually handle pagination, rate limiting, error codes
- Must define all response DTOs manually
- Maximum flexibility, minimum abstraction

#### Step 2: Evaluate with Lookahead

| Criteria | A (Octokit + OAuth Device) | B (Octokit + PAT) | C (Raw HttpClient) |
|----------|---------------------------|--------------------|--------------------|
| **DI compatibility** | ✅ GitHubClient injectable as singleton | ✅ GitHubClient injectable as singleton | ✅ HttpClient via IHttpClientFactory |
| **Auth UX** | ✅ Best — browser-based, no token copy-paste | ⚠️ Moderate — user must create/paste PAT | ⚠️ Same as B (PAT needed) |
| **Proxy support** | ✅ Octokit respects system proxy via HttpClient | ✅ Same | ✅ HttpClient proxy configurable |
| **API coverage** | ✅ Full — repos, releases, issues, contents | ✅ Full — same SDK | ❌ Must implement each endpoint |
| **Maintainability** | ✅ SDK handles breaking API changes | ✅ Same | ❌ Must track API changes manually |
| **Secure token storage** | ✅ SDK manages token refresh | ⚠️ Must store PAT securely (Credential Manager) | ⚠️ Must store PAT securely |
| **Setup complexity** | ⚠️ Requires GitHub OAuth App registration | ✅ Zero setup — user creates own PAT | ✅ Zero setup |
| **Lookahead: GraphQL** | ✅ Octokit.GraphQL companion package | ✅ Same | ❌ Must implement GraphQL client |
| **Lookahead: Rate limiting** | ✅ Octokit surfaces RateLimit in responses | ✅ Same | ⚠️ Must parse X-RateLimit headers manually |
| **Lookahead: Fine-grained PATs** | ✅ Works with any token type | ✅ Works with any token type | ✅ Works with any token type |
| **Offline/air-gapped studios** | ❌ OAuth flow needs internet to GitHub | ✅ PAT works once issued | ✅ PAT works once issued |

#### Step 3: Prune and Decide

```
         [GitHub SDK Integration in Model Studio]
         /                  |                      \
    Branch A            Branch B                Branch C
    ⚠️ Best UX,         ⭐ Selected             ✗ Pruned
    complex setup       (pragmatic)
```

- **Branch C pruned** — Reimplementing pagination, rate limiting, error handling, and response DTOs that Octokit already provides is wasteful. The maintenance burden of tracking GitHub API v3/v4 changes is significant. No justification for avoiding a well-maintained Microsoft-affiliated SDK.

- **Branch A is the gold standard** for public-facing apps, but Model Studio is an internal game dev tool. OAuth Device Flow requires registering a GitHub OAuth App, obtaining a client ID, and distributing it — unnecessary overhead for a team tool where developers already have GitHub accounts with PATs.

- **Branch B selected** — Octokit.net provides full API coverage, rate limit handling, and proxy support. PAT authentication is the pragmatic choice for an internal tool:
  1. Developers already use PATs for `git push` and CI/CD
  2. No OAuth App registration needed — zero infrastructure setup
  3. Fine-grained PATs (GitHub's newer token type) give per-repo scoping
  4. PAT can be stored securely via Windows Credential Manager (DPAPI-backed)
  5. If OAuth is needed later, Octokit supports both — the service interface stays the same

#### Step 4: Final Architecture (Branch B)

**Layer placement following ModelStudio architecture rules:**

```
ModelStudio.Core (net8.0) — NO WPF dependency
  ├── Services/
  │   ├── IGitHubService.cs          — Interface for all GitHub operations
  │   ├── GitHubService.cs           — Octokit.net implementation
  │   └── IGitHubAuthProvider.cs     — Interface for token retrieval
  └── Models/
      ├── GitHubAssetInfo.cs         — DTO for release assets
      └── GitHubRepoContent.cs       — DTO for repo browsing results

ModelStudio (WPF App, net8.0-windows)
  ├── Services/
  │   └── CredentialManagerAuthProvider.cs — Windows Credential Manager PAT storage
  ├── ViewModels/
  │   └── GitHubViewModel.cs         — ViewModel for GitHub docking panel
  └── App.xaml.cs                    — DI registration
```

**Step 4a: Core Interfaces (ModelStudio.Core)**

```csharp
// IGitHubAuthProvider.cs — abstracts token retrieval (implemented in WPF layer)
namespace ModelStudio.Core.Services;

public interface IGitHubAuthProvider
{
    Task<string?> GetAccessTokenAsync(CancellationToken ct = default);
    Task SaveAccessTokenAsync(string token, CancellationToken ct = default);
    Task ClearAccessTokenAsync(CancellationToken ct = default);
}

// IGitHubService.cs — all GitHub operations
namespace ModelStudio.Core.Services;

public interface IGitHubService
{
    Task<bool> TestConnectionAsync(CancellationToken ct = default);
    Task<IReadOnlyList<GitHubRepoContent>> BrowseRepositoryAsync(
        string owner, string repo, string path = "", CancellationToken ct = default);
    Task<IReadOnlyList<GitHubAssetInfo>> GetReleaseAssetsAsync(
        string owner, string repo, CancellationToken ct = default);
    Task<string> DownloadAssetAsync(
        GitHubAssetInfo asset, string destinationDir,
        IProgress<double>? progress = null, CancellationToken ct = default);
    Task CreateIssueAsync(
        string owner, string repo, string title, string body,
        CancellationToken ct = default);
    Task<GitHubRateLimitInfo> GetRateLimitAsync(CancellationToken ct = default);
}
```

**Step 4b: Octokit Implementation (ModelStudio.Core)**

```csharp
// GitHubService.cs
using Octokit;
namespace ModelStudio.Core.Services;

public class GitHubService : IGitHubService
{
    private readonly IGitHubAuthProvider _authProvider;
    private GitHubClient? _client;

    public GitHubService(IGitHubAuthProvider authProvider)
    {
        _authProvider = authProvider;
    }

    private async Task<GitHubClient> GetClientAsync(CancellationToken ct)
    {
        if (_client is not null) return _client;

        var token = await _authProvider.GetAccessTokenAsync(ct)
            ?? throw new InvalidOperationException("GitHub PAT not configured. Go to Settings → GitHub.");

        _client = new GitHubClient(new ProductHeaderValue("UrbanSurvivor-ModelStudio"))
        {
            Credentials = new Credentials(token)
        };
        return _client;
    }

    public async Task<bool> TestConnectionAsync(CancellationToken ct = default)
    {
        try
        {
            var client = await GetClientAsync(ct);
            var user = await client.User.Current();
            return user is not null;
        }
        catch
        {
            return false;
        }
    }

    public async Task<IReadOnlyList<GitHubRepoContent>> BrowseRepositoryAsync(
        string owner, string repo, string path = "", CancellationToken ct = default)
    {
        var client = await GetClientAsync(ct);
        var contents = await client.Repository.Content.GetAllContents(owner, repo, path);
        return contents
            .Where(c => c.Type == ContentType.Dir ||
                        IsModelFile(c.Name))
            .Select(c => new GitHubRepoContent(c.Name, c.Path, c.Type.ToString(), c.Size, c.DownloadUrl))
            .ToList();
    }

    public async Task<IReadOnlyList<GitHubAssetInfo>> GetReleaseAssetsAsync(
        string owner, string repo, CancellationToken ct = default)
    {
        var client = await GetClientAsync(ct);
        var releases = await client.Repository.Release.GetAll(owner, repo);
        return releases
            .SelectMany(r => r.Assets
                .Where(a => IsModelFile(a.Name))
                .Select(a => new GitHubAssetInfo(
                    a.Name, a.BrowserDownloadUrl, a.Size, r.TagName, a.Id)))
            .ToList();
    }

    public async Task<string> DownloadAssetAsync(
        GitHubAssetInfo asset, string destinationDir,
        IProgress<double>? progress = null, CancellationToken ct = default)
    {
        var client = await GetClientAsync(ct);
        var response = await client.Connection.Get<byte[]>(
            new Uri(asset.DownloadUrl), TimeSpan.FromMinutes(10));

        var destPath = Path.Combine(destinationDir, asset.FileName);
        await File.WriteAllBytesAsync(destPath, response.Body, ct);
        progress?.Report(1.0);
        return destPath;
    }

    public async Task CreateIssueAsync(
        string owner, string repo, string title, string body,
        CancellationToken ct = default)
    {
        var client = await GetClientAsync(ct);
        await client.Issue.Create(owner, repo, new NewIssue(title) { Body = body });
    }

    public async Task<GitHubRateLimitInfo> GetRateLimitAsync(CancellationToken ct = default)
    {
        var client = await GetClientAsync(ct);
        var rateLimit = await client.RateLimit.GetRateLimits();
        var core = rateLimit.Resources.Core;
        return new GitHubRateLimitInfo(core.Remaining, core.Limit, core.Reset.UtcDateTime);
    }

    private static bool IsModelFile(string fileName) =>
        fileName.EndsWith(".glb", StringComparison.OrdinalIgnoreCase) ||
        fileName.EndsWith(".fbx", StringComparison.OrdinalIgnoreCase) ||
        fileName.EndsWith(".obj", StringComparison.OrdinalIgnoreCase) ||
        fileName.EndsWith(".gltf", StringComparison.OrdinalIgnoreCase);
}
```

**Step 4c: WPF Auth Provider (ModelStudio app)**

```csharp
// CredentialManagerAuthProvider.cs — Windows Credential Manager storage
using System.Runtime.InteropServices;
using System.Security;
namespace ModelStudio.Services;

public class CredentialManagerAuthProvider : Core.Services.IGitHubAuthProvider
{
    private const string CredentialTarget = "ModelStudio:GitHubPAT";

    public Task<string?> GetAccessTokenAsync(CancellationToken ct = default)
    {
        // Read from Windows Credential Manager (DPAPI-encrypted)
        var credential = CredentialManager.ReadCredential(CredentialTarget);
        return Task.FromResult(credential?.Password);
    }

    public Task SaveAccessTokenAsync(string token, CancellationToken ct = default)
    {
        CredentialManager.WriteCredential(CredentialTarget, "GitHubPAT", token);
        return Task.CompletedTask;
    }

    public Task ClearAccessTokenAsync(CancellationToken ct = default)
    {
        CredentialManager.DeleteCredential(CredentialTarget);
        return Task.CompletedTask;
    }
}
```

**Step 4d: ViewModel (CommunityToolkit.Mvvm pattern)**

```csharp
// GitHubViewModel.cs
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using ModelStudio.Core.Services;
using System.Collections.ObjectModel;

namespace ModelStudio.ViewModels;

public partial class GitHubViewModel : ObservableObject
{
    private readonly IGitHubService _gitHubService;
    private readonly IGitHubAuthProvider _authProvider;

    public GitHubViewModel(IGitHubService gitHubService, IGitHubAuthProvider authProvider)
    {
        _gitHubService = gitHubService;
        _authProvider = authProvider;
    }

    [ObservableProperty]
    private bool isConnected;

    [ObservableProperty]
    private string? statusMessage;

    [ObservableProperty]
    private string? repositoryOwner;

    [ObservableProperty]
    private string? repositoryName;

    [ObservableProperty]
    private double downloadProgress;

    public ObservableCollection<GitHubRepoContent> RepoContents { get; } = new();
    public ObservableCollection<GitHubAssetInfo> ReleaseAssets { get; } = new();

    [RelayCommand]
    private async Task ConnectAsync(string personalAccessToken)
    {
        StatusMessage = "Connecting to GitHub...";
        await _authProvider.SaveAccessTokenAsync(personalAccessToken);
        IsConnected = await _gitHubService.TestConnectionAsync();
        StatusMessage = IsConnected ? "Connected to GitHub" : "Connection failed — check PAT";
    }

    [RelayCommand]
    private async Task BrowseRepositoryAsync()
    {
        if (string.IsNullOrEmpty(RepositoryOwner) || string.IsNullOrEmpty(RepositoryName)) return;

        StatusMessage = "Browsing repository...";
        RepoContents.Clear();

        var contents = await _gitHubService.BrowseRepositoryAsync(
            RepositoryOwner, RepositoryName);

        foreach (var item in contents)
            RepoContents.Add(item);

        StatusMessage = $"Found {RepoContents.Count} model files";
    }

    [RelayCommand]
    private async Task DownloadAssetAsync(GitHubAssetInfo asset)
    {
        StatusMessage = $"Downloading {asset.FileName}...";
        DownloadProgress = 0;

        var progress = new Progress<double>(p => DownloadProgress = p);
        var destDir = Path.Combine(Environment.CurrentDirectory, "import_staging");
        Directory.CreateDirectory(destDir);

        var localPath = await _gitHubService.DownloadAssetAsync(asset, destDir, progress);
        StatusMessage = $"Downloaded to {localPath}";
    }

    [RelayCommand]
    private async Task ReportValidationIssueAsync(string title, string body)
    {
        if (string.IsNullOrEmpty(RepositoryOwner) || string.IsNullOrEmpty(RepositoryName)) return;

        await _gitHubService.CreateIssueAsync(RepositoryOwner, RepositoryName, title, body);
        StatusMessage = "Issue created on GitHub";
    }

    [RelayCommand]
    private async Task DisconnectAsync()
    {
        await _authProvider.ClearAccessTokenAsync();
        IsConnected = false;
        RepoContents.Clear();
        ReleaseAssets.Clear();
        StatusMessage = "Disconnected from GitHub";
    }
}
```

**Step 4e: DI Registration (App.xaml.cs additions)**

```csharp
// Add to App.OnStartup in App.xaml.cs:

// GitHub services
services.AddSingleton<IGitHubAuthProvider, CredentialManagerAuthProvider>();
services.AddSingleton<IGitHubService, GitHubService>();

// GitHub ViewModel
services.AddTransient<GitHubViewModel>();
```

**Step 4f: NuGet Package Addition**

```xml
<!-- Add to ModelStudio.Core.csproj (net8.0, no WPF dependency) -->
<PackageReference Include="Octokit" Version="13.0.1" />
```

The Octokit package targets `netstandard2.0` — it has NO WPF or Windows dependency, so it is safe to add to the Core project without violating the layering rule.

#### Step 5: Verify Against Requirements

- [x] **Core/WPF layering respected** — `IGitHubService` + `GitHubService` live in `ModelStudio.Core` (net8.0); `CredentialManagerAuthProvider` lives in `ModelStudio` (WPF app); Core never references WPF
- [x] **DI registration** — All services registered in `App.xaml.cs` via `ServiceCollection`, injected via constructor
- [x] **Async/await everywhere** — All GitHub API calls are async, ViewModel uses `[RelayCommand]` on `async Task` methods
- [x] **Secure authentication** — PAT stored in Windows Credential Manager (DPAPI-encrypted), never in plaintext config files
- [x] **CommunityToolkit.Mvvm patterns** — `[ObservableProperty]`, `[RelayCommand]`, `partial class`, `ObservableObject` base
- [x] **Proxy support** — Octokit uses `HttpClient` internally, which respects system proxy settings and `HTTP_PROXY` env var
- [x] **Rate limiting** — `GetRateLimitAsync()` exposes remaining API calls; can be shown in status bar
- [x] **Future-proof for OAuth** — `IGitHubAuthProvider` interface means swapping PAT for OAuth Device Flow requires only a new provider implementation, no changes to `GitHubService` or ViewModels

---

### Developer Execution Prompt

Use this prompt in VS2026 Copilot Chat (or GitHub Copilot agent mode) to implement the selected branch:

```markdown
@workspace Implement GitHub SDK integration in Model Studio using Tree of Thought Branch B 
(Octokit.net + PAT authentication). Follow these steps:

**Step 1 — NuGet Package**:
Add `Octokit` (latest stable, currently 13.0.1) to `ModelStudio.Core.csproj`.
Do NOT add it to the WPF app project — Octokit targets netstandard2.0 and belongs in Core.

**Step 2 — Core Interfaces** (in ModelStudio.Core/Services/):
Create `IGitHubAuthProvider.cs` with methods: GetAccessTokenAsync, SaveAccessTokenAsync, ClearAccessTokenAsync.
Create `IGitHubService.cs` with methods: TestConnectionAsync, BrowseRepositoryAsync, GetReleaseAssetsAsync, 
DownloadAssetAsync, CreateIssueAsync, GetRateLimitAsync.
Create DTOs: `GitHubAssetInfo.cs` (record with FileName, DownloadUrl, Size, TagName, AssetId) and 
`GitHubRepoContent.cs` (record with Name, Path, Type, Size, DownloadUrl) and 
`GitHubRateLimitInfo.cs` (record with Remaining, Limit, ResetUtc) in ModelStudio.Core/Models/.

**Step 3 — Octokit Implementation** (in ModelStudio.Core/Services/):
Create `GitHubService.cs` implementing IGitHubService. Use Octokit.GitHubClient with ProductHeaderValue 
"UrbanSurvivor-ModelStudio". Filter repo contents and release assets to model files (.glb, .fbx, .obj, .gltf).
All methods must be async and accept CancellationToken.

**Step 4 — Windows Credential Manager Auth** (in ModelStudio/Services/):
Create `CredentialManagerAuthProvider.cs` implementing IGitHubAuthProvider. Store PAT in Windows 
Credential Manager under target "ModelStudio:GitHubPAT". Use P/Invoke to CredWrite/CredRead/CredDelete 
(or the AdysTech.CredentialManager NuGet package for a managed wrapper).

**Step 5 — ViewModel** (in ModelStudio/ViewModels/):
Create `GitHubViewModel.cs` using CommunityToolkit.Mvvm source generators:
- Must be `partial class` inheriting `ObservableObject`
- Use [ObservableProperty] for: IsConnected, StatusMessage, RepositoryOwner, RepositoryName, DownloadProgress
- Use [RelayCommand] on async Task methods: ConnectAsync, BrowseRepositoryAsync, DownloadAssetAsync, 
  ReportValidationIssueAsync, DisconnectAsync
- Use ObservableCollection<T> for RepoContents and ReleaseAssets
- Constructor-inject IGitHubService and IGitHubAuthProvider

**Step 6 — DI Registration** (in App.xaml.cs):
Add to OnStartup: 
  services.AddSingleton<IGitHubAuthProvider, CredentialManagerAuthProvider>();
  services.AddSingleton<IGitHubService, GitHubService>();
  services.AddTransient<GitHubViewModel>();

**Constraints**:
- ModelStudio.Core must NOT reference WPF, PresentationFramework, or WindowsBase
- Do NOT use MessageBox.Show — surface errors via StatusMessage property
- Do NOT store PAT in appsettings.json or plaintext files
- Use the existing nuget.config (nuget.org only, no GitHub Packages source)
- Follow the naming conventions: private fields _camelCase, [ObservableProperty] fields camelCase
```

---

## CORE Framework Prompt Templates

### Template 1: Architecture Decision

```markdown
**Context**:
[Describe your VS2026 extension, target framework, existing dependencies]

**Objective**:
[What you want to design/build]

**Requirements**:
- [Functional requirement 1]
- [Performance requirement]
- [VS2026 SDK compliance requirement]
- [Testability requirement]

**Use Tree of Thought reasoning:**
1. Generate 3 architectural approaches: [A name], [B name], [C name]
2. Evaluate each against: [Requirement 1], [Requirement 2], VS SDK patterns
3. Lookahead: What happens at [scale scenario]? What about [future feature]?
4. Prune the weakest branch and explain why
5. Produce the final class structure with registration

**Examples**:
- When [trigger]: [Expected behavior]
- When [error case]: [Expected error handling]
```

### Template 2: VS2026 Integration Pattern

```markdown
**Context**:
Building a VS2026 extension that needs to integrate with [VS feature: Build/Debug/Editor/etc.].
Using [SDK: Community.VisualStudio.Toolkit / raw VS SDK]. Targeting [.NET version].

**Objective**:
Implement [feature] that [behavior description].

**Requirements**:
- Follow VS2026 [specific pattern: AsyncPackage/MEF/etc.] best practices
- Support [VS2026 feature: async operations/cancellation/threading]
- Integrate with [VS component: Error List/Output Window/Solution Explorer]
- [Additional constraint]

**Use Tree of Thought reasoning:**
1. Generate 3 VS integration approaches
2. Evaluate each against: VS SDK compliance, thread safety, user experience
3. Lookahead: Does each approach work with [VS scenario: large solutions/remote dev]?
4. Prune and select. Produce final implementation.

**Examples**:
- User action: [Trigger] → Expected: [Outcome]
- Error scenario: [Condition] → Expected: [Error handling]
```

### Template 3: Performance-Critical Tool

```markdown
**Context**:
[VS2026 extension scenario requiring performance optimization]

**Objective**:
[Performance goal: response time < X ms, memory < Y MB, etc.]

**Requirements**:
- Must not block VS UI thread
- Handle [data scale: N items/files/projects]
- Support incremental/cached results
- Graceful degradation under load

**Use Tree of Thought reasoning:**
1. Generate 3 approaches with different performance tradeoffs:
   - A: [Eager/sync approach]
   - B: [Lazy/async approach]  
   - C: [Cached/incremental approach]
2. Evaluate: latency, memory, CPU, scalability
3. Lookahead: Performance at 10x scale? During debugging?
4. Prune, select, and produce optimized implementation

**Examples**:
- Input: [Size/complexity] → Expected latency: [Target]
- Under load: [Scenario] → Expected behavior: [Degradation strategy]
```

---

## VS2026-Specific ToT Considerations

### When to Use ToT in VS Extension Development

| Scenario | Use ToT? | Why |
|----------|----------|-----|
| Choosing between MEF and ServiceProvider | ✅ Yes | Multiple valid patterns with different tradeoffs |
| Implementing a simple command | ❌ No | Single clear path, use CoT |
| Designing async threading strategy | ✅ Yes | JoinableTaskFactory vs Task vs BackgroundWorker |
| Adding a menu item | ❌ No | Standard VS pattern, well-documented |
| Custom tool window state management | ✅ Yes | Multiple valid state patterns |
| Error handling strategy across extension | ✅ Yes | Affects user experience significantly |

### VS2026 Lookahead Questions

When evaluating branches, always ask these VS-specific lookahead questions:

1. **Scale**: "What happens with a 100-project solution?"
2. **Remote Dev**: "Does this work in VS2026 Remote Development scenarios?"
3. **Performance**: "Does this block the UI thread during a debug session?"
4. **Backwards Compat**: "Will this work if user is on VS2026 Preview vs GA?"
5. **CI/CD**: "Does this require VS, or can it run in headless builds?"

### Thread-Safety Evaluation Criteria

Always include these in your evaluation matrix for VS2026 tools:

| Branch | Main Thread Required? | JoinableTaskFactory Used? | Deadlock Risk? |
|--------|----------------------|---------------------------|----------------|
| A | ... | ... | ... |
| B | ... | ... | ... |
| C | ... | ... | ... |

---

## Key Takeaways

### ToT for VS2026 Tools Development

1. **Branch** — Generate 3 implementation approaches before coding
2. **Evaluate** — Score against VS SDK compliance, threading model, testability
3. **Lookahead** — Consider scale, remote dev, and performance scenarios
4. **Prune** — Eliminate approaches that violate VS best practices
5. **Implement** — Use CoT within the winning branch for step-by-step coding

### CORE Framework Recap

- **C**ontext: VS2026 SDK version, toolkit, existing code
- **O**bjective: What the tool/extension should accomplish
- **R**equirements: Threading, performance, VS integration constraints
- **E**xamples: Expected behavior, error cases

### Best Practice: ToT → CoT Handoff

Use **ToT to decide WHAT architecture to use**, then **CoT to decide HOW to implement it**.

```
[ToT: Which pattern?]           [CoT: How to implement?]
         ↓                              ↓
   Branch A ✗                     Step 1: Create interface
   Branch B ⭐ ─────────────────→ Step 2: Implement class
   Branch C ✗                     Step 3: Register in Package
                                  Step 4: Add unit tests
```

---

## Additional Resources

- **Chain of Thought doc**: `docs/workshops/CHAIN_OF_THOUGHT.md` — linear reasoning companion
- **MCP Integration**: `docs/workshops/mcp.md` — Model Context Protocol for Copilot extensions
- **VS2026 Extensibility Docs**: [Microsoft Docs](https://docs.microsoft.com/visualstudio/extensibility)
- **Community.VisualStudio.Toolkit**: [GitHub](https://github.com/VsixCommunity/Community.VisualStudio.Toolkit)
- **GitHub Copilot Best Practices**: [GitHub Docs](https://docs.github.com/copilot/using-github-copilot/best-practices-for-using-github-copilot)

---

**Author**: GitHub Copilot  
**Context**: Visual Studio 2026 Tools & Extension Development  
**Framework**: CORE (Context, Objective, Requirements, Examples)  
**Last Updated**: February 12, 2026
