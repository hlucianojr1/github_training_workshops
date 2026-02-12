```prompt
---
agent: 'blenderkit-asset-scout'
description: 'Search BlenderKit for 3D assets with period-appropriate filters and poly-budget awareness.'
---

# Search BlenderKit for Assets

Find 3D models, materials, or HDRIs from BlenderKit for Urban Survivor.

## Prerequisites

- BlenderKit integration configured (see `setup-blenderkit.prompt.md`)
- Review `docs/ART_GUIDELINES.md` for poly budgets
- Check `docs/ASSET_TRACKER.md` for needed assets

---

## Input Parameters

- **Search Query**: What to search for (e.g., "1960s car", "brick wall", "golden hour")
- **Asset Type**: `model` | `material` | `hdr` | `brush` | `scene`
- **Category** (optional): Filter by category (e.g., "vehicles", "architecture")
- **Count**: Number of results (default: 20, max: 100)

---

## Workflow

### Step 1: Verify BlenderKit Status

```python
get_blenderkit_status()
```

If not ready, complete setup first.

### Step 2: Execute Search

**CRITICAL: Always use `free_only=True`**

```python
search_blenderkit_assets(
    query="[SEARCH_QUERY]",
    asset_type="[model|material|hdr]",
    category="[OPTIONAL_CATEGORY]",
    free_only=True,  # MANDATORY - never set to False
    count=20
)
```

### Step 3: Review Results

Evaluate results based on:

| Criteria | Check |
|----------|-------|
| Period Accuracy | Does it fit 1960s NYC aesthetic? |
| Poly Budget | Will it meet ART_GUIDELINES targets? |
| Material Quality | Does it have proper PBR materials? |
| License | Is it CC0 or Royalty-Free? |

### Step 4: Select and Download

```python
download_blenderkit_asset(
    asset_id="[SELECTED_ASSET_ID]",
    location=[0, 0, 0]
)
```

### Step 5: Handle Large Downloads

If `status="downloading"` returned:

```python
poll_blenderkit_download(download_id="[DOWNLOAD_ID]")
```

See `poll-blenderkit-download.prompt.md` for complete workflow.

---

## 1960s Search Query Examples

### Vehicles

```python
search_blenderkit_assets(query="1960s sedan", asset_type="model", category="vehicles", free_only=True)
search_blenderkit_assets(query="vintage taxi", asset_type="model", category="vehicles", free_only=True)
search_blenderkit_assets(query="classic american car", asset_type="model", free_only=True)
search_blenderkit_assets(query="retro bus", asset_type="model", free_only=True)
search_blenderkit_assets(query="1950s pickup truck", asset_type="model", free_only=True)
```

### Architecture

```python
search_blenderkit_assets(query="brick apartment building", asset_type="model", category="architecture", free_only=True)
search_blenderkit_assets(query="1960s storefront", asset_type="model", free_only=True)
search_blenderkit_assets(query="art deco facade", asset_type="model", free_only=True)
search_blenderkit_assets(query="brownstone", asset_type="model", free_only=True)
```

### Street Props

```python
search_blenderkit_assets(query="vintage street lamp", asset_type="model", free_only=True)
search_blenderkit_assets(query="fire hydrant", asset_type="model", free_only=True)
search_blenderkit_assets(query="phone booth retro", asset_type="model", free_only=True)
search_blenderkit_assets(query="mailbox classic", asset_type="model", free_only=True)
search_blenderkit_assets(query="trash can metal", asset_type="model", free_only=True)
```

### Materials (Weathered/Aged)

```python
search_blenderkit_assets(query="rust metal", asset_type="material", free_only=True)
search_blenderkit_assets(query="worn leather", asset_type="material", free_only=True)
search_blenderkit_assets(query="cracked concrete", asset_type="material", free_only=True)
search_blenderkit_assets(query="peeling paint", asset_type="material", free_only=True)
search_blenderkit_assets(query="dirty brick", asset_type="material", free_only=True)
```

### HDRIs (Lighting)

```python
search_blenderkit_assets(query="golden hour urban", asset_type="hdr", free_only=True)
search_blenderkit_assets(query="overcast city", asset_type="hdr", free_only=True)
search_blenderkit_assets(query="sunset street", asset_type="hdr", free_only=True)
search_blenderkit_assets(query="studio lighting", asset_type="hdr", free_only=True)
```

---

## Poly Budget Reference

From `docs/ART_GUIDELINES.md`:

| Asset Type | Target Polys | BlenderKit Search Tips |
|------------|--------------|------------------------|
| Vehicles | 3,000 - 6,000 | Look for "low poly" or "game ready" |
| Hero Buildings | 8,000 - 10,000 | May need simplification |
| Storefronts | 4,000 - 5,000 | Check complexity before download |
| Street Props | 150 - 1,500 | Most should be fine |
| Debris | 50 - 600 | Look for simple geometry |

---

## After Search

1. **Download selected asset** using `download_blenderkit_asset`
2. **Review quality** via `@glb-import-reviewer` agent
3. **Enhance materials** via `@texture-artist` agent if needed
4. **Update tracking** in `docs/ASSET_TRACKER.md`:

```markdown
| Asset | Poly Target | Texture Size | Status | Source | License | Notes |
|-------|-------------|--------------|--------|--------|---------|-------|
| [Name] | [X,XXX] | [size] | ✅ | BlenderKit | CC0 | asset_id: [id] |
```

---

## Related Prompts

- `setup-blenderkit.prompt.md` — First-time configuration
- `import-blenderkit-model.prompt.md` — Full import workflow
- `poll-blenderkit-download.prompt.md` — Large file downloads
```
