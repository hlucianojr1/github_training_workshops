```prompt
---
mode: 'agent'
description: 'First-time setup guide for BlenderKit integration with Blender MCP. Covers addon installation, authentication, and verification.'
---

# Setup BlenderKit Integration

Configure BlenderKit as an asset source for Urban Survivor development.

## Prerequisites

- Blender 4.0+ installed
- BlenderMCP addon installed and running
- BlenderKit account (free tier available)

---

## Step 1: Install BlenderKit Addon

1. Open Blender
2. Go to **Edit → Preferences → Add-ons**
3. Click **Install...** or search the marketplace
4. Search for "BlenderKit" in the addon list
5. Check the box to enable the addon
6. Expand the addon panel and note the preferences section

---

## Step 2: Authenticate BlenderKit Account

1. In **Edit → Preferences → Add-ons → BlenderKit**
2. Click **Login** or **Sign Up** if you don't have an account
3. Complete authentication in the browser window that opens
4. Return to Blender - you should see your username displayed
5. Verify "Logged in as: [your_username]" appears in preferences

---

## Step 3: Enable BlenderKit in BlenderMCP

1. In Blender's 3D Viewport, press `N` to open the sidebar
2. Find the **BlenderMCP** panel tab
3. Locate the **"Use BlenderKit"** checkbox
4. Enable the checkbox
5. Ensure the MCP server is running (green status indicator)

---

## Step 4: Verify Integration

Use the MCP tool to verify everything is configured correctly:

```
get_blenderkit_status()
```

**Expected successful response:**
```json
{
  "enabled": true,
  "addon_installed": true,
  "authenticated": true,
  "api_key_available": true,
  "message": "BlenderKit integration is ready"
}
```

---

## Troubleshooting

| Error Message | Cause | Solution |
|---------------|-------|----------|
| `"BlenderKit addon is not installed"` | Addon missing | Install BlenderKit addon via Edit → Preferences → Add-ons |
| `"BlenderKit user is not authenticated"` | Not logged in | Log in via BlenderKit addon preferences |
| `"BlenderKit integration is disabled in MCP settings"` | Toggle off | Enable "Use BlenderKit" checkbox in BlenderMCP panel |
| `"API key not available"` | Authentication incomplete | Re-authenticate in BlenderKit preferences |
| Connection timeout | Network issue | Check internet connection, firewall settings |

---

## Available MCP Tools After Setup

Once setup is complete, these tools become available:

| Tool | Purpose |
|------|---------|
| `get_blenderkit_status` | Verify integration status |
| `search_blenderkit_assets` | Search for models, materials, HDRIs |
| `get_blenderkit_categories` | List available categories |
| `download_blenderkit_asset` | Download and import assets |
| `poll_blenderkit_download` | Check background download progress |

---

## Quick Test Search

Verify search functionality works:

```
search_blenderkit_assets(
    query="vintage car",
    asset_type="model",
    free_only=True,
    count=5
)
```

If results return, BlenderKit integration is fully operational.

---

## Urban Survivor Usage Notes

- **Always use `free_only=True`** to avoid unexpected purchases
- Search for "1960s", "vintage", "retro" for period-appropriate assets
- Check poly counts against `docs/ART_GUIDELINES.md` budgets
- After download, hand off to **GLB Import Reviewer** agent for quality check
- Update `docs/ASSET_TRACKER.md` with Source: BlenderKit and License info

---

## Related Prompts

- `search-blenderkit-asset.prompt.md` — Asset search workflow
- `import-blenderkit-model.prompt.md` — Import and review workflow
- `poll-blenderkit-download.prompt.md` — Handle large file downloads
```
