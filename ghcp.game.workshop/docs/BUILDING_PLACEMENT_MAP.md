# Level 1 Building Placement Map

## Overview
Added 8 new city buildings to `level_1.tscn` positioned along the street corridor.

## Building Layout

```
                    NORTH (-140)
                         |
    Building_Public_North (0, 0, -140)
                         |
                         |
                    (-120)
    [-35] Building_City_North_01
                         |
                         |
                    (-100)
    [-35] Building_City_West_01
                         |
                         |
                    (-80)
    [-35] Building_Residential_West_02    [35] Building_Residential_East_02
                         |
                         |
                    (-60)
    [-35] CBS_Skyscraper_West (existing, scale 50x)
                         |
                         |
                    (-40)
                         |           [35] Building_City_Southeast_01
                         |
                    (-20)
    [-35] Building_Office_West_01    [35] Building_Office_East_01
                         |
                         |
                    SOUTH (0)
```

## Building Details

| Building Name | Model File | Position (X, Y, Z) | Side | Description |
|---------------|------------|-------------------|------|-------------|
| CBS_Skyscraper_West | building_cbs_skyscraper_lod0.glb | (-35, 0, -60) | West | Existing skyscraper (scale 50x) |
| Building_Office_West_01 | downtown_modernoffice_3.glb | (-35, 0, -20) | West | Modern office entrance area |
| Building_Office_East_01 | downtown_modernoffice_4.glb | (35, 0, -20) | East | Modern office entrance area |
| Building_Residential_West_02 | downtown_residential_2.glb | (-35, 0, -80) | West | Residential building mid-level |
| Building_Residential_East_02 | downtown_residential_3.glb | (35, 0, -80) | East | Residential building mid-level |
| Building_Public_North | downtown_publicbuilding_1.glb | (0, 0, -140) | North | Public building at level exit |
| Building_City_North_01 | u2NBuild3.gltf | (-35, 0, -120) | West | City building near exit |
| Building_City_Southeast_01 | u2SEBuild2.gltf | (35, 0, -40) | East | City building sanctuary area |
| Building_City_West_01 | u2WBuild1.gltf | (-35, 0, -100) | West | City building killzone area |

## Coordinate System Reference

- **X axis**: East (+) / West (-)
- **Z axis**: South (0) / North (-150)
- **Y axis**: Ground level (0)

## Street Layout Context

- **Player Spawn**: (0, 1, -5)
- **Street Width**: ~60 units
- **Buildings Offset**: ±35 units from center
- **Level Exit**: (0, 0, -150)

## Gameplay Areas Covered

| Area | Z Range | Buildings |
|------|---------|-----------|
| Entrance Row | 0 to -25 | Office West/East 01 |
| Sanctuary | -30 to -50 | Southeast 01 |
| Times Square Center | -55 to -75 | CBS Skyscraper, Residential West/East |
| Killzone | -80 to -105 | City West 01 |
| Blockade | -110 to -130 | City North 01 |
| Exit | -135 to -150 | Public North |

## Next Steps

1. **Open Godot Editor** and load `game/scenes/level_1.tscn`
2. **Check 3D Viewport** to verify building placement
3. **Adjust Transforms** if buildings:
   - Float above ground (adjust Y position)
   - Overlap each other (adjust X/Z spacing)
   - Need rotation (modify transform matrix)
4. **Add Collision** if buildings don't have collision meshes
5. **Test Navigation** - ensure player can move around buildings
6. **Performance Check** - verify FPS remains acceptable

## Available Building Models Not Yet Placed

- `downtown_modernoffice_1_b.glb`
- `downtown_modernoffice_2.glb`
- `downtown_modernoffice_5_b.glb`
- `downtown_modernoffice_5.glb`
- `downtown_residential_4.glb`
- `building_military_base_lod0.glb`
- `building_storefront_strip_lod0.glb`
- Many more in `game/assets/models/city/` (u2EBuild*, u2NEBuild*, u2NWBuild*, u2SWBuild*, etc.)

## Tips for Further Placement

- Use **instancing** for repeated buildings
- Group buildings by **area** (Entrance, Sanctuary, Killzone, etc.)
- Maintain **30-50 unit spacing** between buildings
- Add **rotation** for visual variety: `Transform3D(0, 0, 1, 0, 1, 0, -1, 0, 0, x, y, z)` for 90° rotation
- Consider **scale** adjustments for height variety
