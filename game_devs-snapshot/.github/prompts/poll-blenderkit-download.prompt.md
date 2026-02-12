```prompt
---
agent: 'blenderkit-asset-scout'
description: 'Poll and handle background BlenderKit downloads for large files (>10MB). Includes completion and error handling workflows.'
---

# Poll BlenderKit Download

Handle background downloads for large BlenderKit assets (>10MB).

## When to Use

When `download_blenderkit_asset` returns:

```json
{
  "status": "downloading",
  "download_id": "dl_abc123",
  "asset_id": "asset-uuid",
  "message": "Large file detected. Download started in background..."
}
```

---

## Input Parameters

- **Download ID**: The `download_id` returned from `download_blenderkit_asset`

---

## Workflow

### Step 1: Initial Poll

```python
poll_blenderkit_download(download_id="[DOWNLOAD_ID]")
```

### Step 2: Interpret Response

#### Status: `downloading` (In Progress)

```json
{
  "status": "downloading",
  "download_id": "dl_abc123",
  "progress": 45.5,
  "message": "Downloading... 45.5%"
}
```

**Action**: Wait and poll again.

#### Status: `completed` (Success)

```json
{
  "status": "completed",
  "download_id": "dl_abc123",
  "asset_name": "Vintage Car",
  "object_name": "Vintage_Car",
  "message": "Download completed and asset imported"
}
```

**Action**: Proceed to quality review phase.

#### Status: `failed` (Error)

```json
{
  "status": "failed",
  "download_id": "dl_abc123",
  "error": "Network timeout"
}
```

**Action**: Troubleshoot and retry.

---

## Polling Strategy

### Recommended Polling Intervals

| Progress Range | Wait Time | Rationale |
|----------------|-----------|-----------|
| 0% - 25% | 5 seconds | Early stage, slow start |
| 25% - 75% | 3 seconds | Active download |
| 75% - 99% | 2 seconds | Near completion |
| Processing | 5 seconds | Post-download import |

### Manual Polling Loop

```python
# Poll every few seconds until complete
import time

download_id = "[DOWNLOAD_ID]"
max_attempts = 60  # 5 minutes max at 5-second intervals

for attempt in range(max_attempts):
    status = poll_blenderkit_download(download_id=download_id)
    
    if status["status"] == "completed":
        print(f"✅ Asset imported: {status['object_name']}")
        break
    elif status["status"] == "failed":
        print(f"❌ Download failed: {status.get('error', 'Unknown error')}")
        break
    else:
        progress = status.get("progress", 0)
        print(f"⏳ Downloading... {progress:.1f}%")
        time.sleep(5)
else:
    print("⚠️ Download timed out after 5 minutes")
```

---

## Error Handling

### Common Errors and Solutions

| Error | Cause | Solution |
|-------|-------|----------|
| `"Network timeout"` | Connection issue | Check internet, retry |
| `"Asset not found"` | Invalid asset ID | Verify asset_id from search |
| `"Authentication failed"` | Session expired | Re-authenticate in BlenderKit addon |
| `"Rate limited"` | Too many requests | Wait 1-2 minutes, retry |
| `"Server error"` | BlenderKit issue | Wait and retry later |
| `"Disk full"` | No storage space | Free up space, retry |

### Retry Strategy

```python
def download_with_retry(asset_id, max_retries=3):
    for attempt in range(max_retries):
        result = download_blenderkit_asset(asset_id=asset_id, location=[0, 0, 0])
        
        if result["status"] == "completed":
            return result
        
        if result["status"] == "downloading":
            # Poll until complete or failed
            final = poll_until_complete(result["download_id"])
            if final["status"] == "completed":
                return final
        
        print(f"Attempt {attempt + 1} failed, retrying...")
        time.sleep(10 * (attempt + 1))  # Exponential backoff
    
    return {"status": "failed", "error": "Max retries exceeded"}
```

---

## After Successful Download

Once `status="completed"`:

1. **Get scene info** to find imported object:
   ```python
   mcp_blender_get_scene_info()
   ```

2. **Setup review lighting**:
   ```python
   mcp_blender_auto_setup_scene_lighting(
       scene_description="asset review",
       target_object="[OBJECT_NAME_FROM_RESPONSE]"
   )
   ```

3. **Capture preview**:
   ```python
   mcp_blender_get_viewport_screenshot()
   ```

4. **Continue with import workflow**:
   See `import-blenderkit-model.prompt.md` Phase 2 onwards.

---

## Troubleshooting Stuck Downloads

### Download Appears Frozen

If progress doesn't change for >2 minutes:

1. Check Blender is responsive (not frozen)
2. Check BlenderKit addon panel for status
3. Check network connection
4. Cancel and retry:
   ```python
   # Re-initiate download
   download_blenderkit_asset(asset_id="[ASSET_ID]", location=[0, 0, 0])
   ```

### Download ID Not Found

If polling returns "download not found":

1. Download may have completed very quickly
2. Check `mcp_blender_get_scene_info()` for the asset
3. Re-initiate download if asset not present

---

## Integration with Other Prompts

| Scenario | Next Step |
|----------|-----------|
| Download complete | `import-blenderkit-model.prompt.md` Phase 2 (Quality Review) |
| Download failed | Retry or `search-blenderkit-asset.prompt.md` for alternative |
| Need different asset | `search-blenderkit-asset.prompt.md` |

---

## Quick Reference

```python
# Start download
result = download_blenderkit_asset(asset_id="abc123", location=[0, 0, 0])

# If background download started
if result["status"] == "downloading":
    download_id = result["download_id"]
    
    # Poll until done
    while True:
        status = poll_blenderkit_download(download_id=download_id)
        
        if status["status"] == "completed":
            print(f"✅ Imported: {status['object_name']}")
            # Continue to quality review...
            break
        elif status["status"] == "failed":
            print(f"❌ Failed: {status['error']}")
            # Handle error...
            break
        
        # Still downloading, wait and poll again
        time.sleep(3)
```
```
