---
agent: 'audio-ambience'
description: 'Configure ambient audio zones, dynamic music triggers, and 3D spatial audio for atmospheric immersion.'
---

Setup ambient audio system for post-apocalyptic NYC atmosphere.

## Load Context First
- docs/ART_GUIDELINES.md Section 7 (Audio Assets)
- docs/SPEC.md Section 9 (Audio Design)
- game/scenes/ (level scenes)

## Requirements
- Zone-based ambient loops
- Random one-shot environmental sounds
- Dynamic music state system
- 3D positional audio for gameplay feedback
- Smooth transitions between zones

## Steps

1) Setup Audio Bus Structure:
   ```
   Project Settings > Audio > Buses:
   
   Master
   ├── Music (Volume: -6dB)
   │   └── Effect: Compressor (subtle)
   ├── SFX (Volume: 0dB)
   │   ├── SFX_Weapons
   │   └── SFX_Environment
   ├── Ambience (Volume: -3dB)
   │   └── Effect: Reverb (subtle room)
   └── UI (Volume: -6dB)
   ```

2) Create AmbienceZone Scene:
   ```
   AmbienceZone.tscn:
   └── Area3D: "AmbienceZone"
       ├── CollisionShape3D (sized to zone)
       └── AudioStreamPlayer: "AmbientLoop"
   
   Script (ambience_zone.gd):
   ```
   ```gdscript
   extends Area3D
   class_name AmbienceZone
   
   @export var ambient_loop: AudioStream
   @export var ambient_volume_db: float = 0.0
   @export var one_shots: Array[AudioStream]
   @export var one_shot_interval_min: float = 3.0
   @export var one_shot_interval_max: float = 10.0
   @export var reverb_preset: String = "outdoor"
   
   @onready var ambient_player: AudioStreamPlayer = $AmbientLoop
   
   var one_shot_timer: float = 0.0
   
   func _ready():
       body_entered.connect(_on_body_entered)
       body_exited.connect(_on_body_exited)
       ambient_player.bus = "Ambience"
   
   func _on_body_entered(body: Node3D):
       if body.is_in_group("player"):
           _start_ambience()
   
   func _on_body_exited(body: Node3D):
       if body.is_in_group("player"):
           _stop_ambience()
   
   func _start_ambience():
       if ambient_loop:
           ambient_player.stream = ambient_loop
           ambient_player.volume_db = ambient_volume_db
           ambient_player.play()
           # Apply reverb preset
           AudioServer.set_bus_effect_enabled(
               AudioServer.get_bus_index("Ambience"), 0, true)
   
   func _stop_ambience():
       # Fade out over 2 seconds
       var tween = create_tween()
       tween.tween_property(ambient_player, "volume_db", -40.0, 2.0)
       tween.tween_callback(ambient_player.stop)
   
   func _process(delta: float):
       if ambient_player.playing and one_shots.size() > 0:
           one_shot_timer -= delta
           if one_shot_timer <= 0:
               _play_random_one_shot()
               one_shot_timer = randf_range(one_shot_interval_min, one_shot_interval_max)
   
   func _play_random_one_shot():
       var sound = one_shots.pick_random()
       # Create temporary AudioStreamPlayer3D at random position in zone
       var player = AudioStreamPlayer3D.new()
       player.stream = sound
       player.bus = "SFX_Environment"
       add_child(player)
       player.global_position = _get_random_point_in_zone()
       player.play()
       player.finished.connect(player.queue_free)
   
   func _get_random_point_in_zone() -> Vector3:
       var shape = $CollisionShape3D.shape as BoxShape3D
       return global_position + Vector3(
           randf_range(-shape.size.x/2, shape.size.x/2),
           randf_range(-shape.size.y/2, shape.size.y/2),
           randf_range(-shape.size.z/2, shape.size.z/2)
       )
   ```

3) Create DynamicMusicManager Autoload:
   ```gdscript
   # autoload/dynamic_music_manager.gd
   extends Node
   
   enum MusicState { EXPLORATION, TENSION, COMBAT, SAFE }
   
   @onready var base_layer: AudioStreamPlayer = $BaseLayer
   @onready var tension_layer: AudioStreamPlayer = $TensionLayer
   @onready var combat_layer: AudioStreamPlayer = $CombatLayer
   
   var current_state: MusicState = MusicState.EXPLORATION
   
   func _ready():
       for player in [base_layer, tension_layer, combat_layer]:
           player.bus = "Music"
       tension_layer.volume_db = -40.0
       combat_layer.volume_db = -40.0
   
   func set_state(new_state: MusicState):
       if new_state == current_state:
           return
       current_state = new_state
       
       match new_state:
           MusicState.EXPLORATION:
               _fade_to(tension_layer, -40.0, 2.0)
               _fade_to(combat_layer, -40.0, 2.0)
           MusicState.TENSION:
               _fade_to(tension_layer, 0.0, 1.0)
               _fade_to(combat_layer, -40.0, 1.0)
           MusicState.COMBAT:
               _fade_to(tension_layer, 0.0, 0.5)
               _fade_to(combat_layer, 0.0, 0.5)
           MusicState.SAFE:
               _fade_to(tension_layer, -40.0, 3.0)
               _fade_to(combat_layer, -40.0, 3.0)
               # Could crossfade to different safe zone track
   
   func _fade_to(player: AudioStreamPlayer, target_db: float, duration: float):
       var tween = create_tween()
       tween.tween_property(player, "volume_db", target_db, duration)
   ```

4) Create 3D Environmental Sounds:
   ```gdscript
   # env_audio_source.gd
   extends AudioStreamPlayer3D
   class_name EnvAudioSource
   
   @export var sounds: Array[AudioStream]
   @export var play_interval_min: float = 5.0
   @export var play_interval_max: float = 15.0
   @export var auto_start: bool = true
   
   var timer: float = 0.0
   
   func _ready():
       bus = "SFX_Environment"
       max_distance = 25.0
       attenuation_model = ATTENUATION_LOGARITHMIC
       if auto_start:
           timer = randf_range(0.0, play_interval_max)
   
   func _process(delta: float):
       if sounds.size() == 0:
           return
       timer -= delta
       if timer <= 0:
           _play_random()
           timer = randf_range(play_interval_min, play_interval_max)
   
   func _play_random():
       if sounds.size() > 0:
           stream = sounds.pick_random()
           play()
   ```

5) Connect Combat to Music System:
   ```gdscript
   # In combat system or enemy AI
   signal combat_started
   signal combat_ended
   signal enemy_spotted_player
   
   # Connect these in level script:
   func _ready():
       for enemy in get_tree().get_nodes_in_group("enemies"):
           enemy.player_spotted.connect(_on_enemy_spotted)
           enemy.died.connect(_check_combat_end)
       
   func _on_enemy_spotted():
       DynamicMusicManager.set_state(DynamicMusicManager.MusicState.TENSION)
   
   func _on_combat_started():
       DynamicMusicManager.set_state(DynamicMusicManager.MusicState.COMBAT)
   
   func _check_combat_end():
       if get_tree().get_nodes_in_group("enemies").filter(func(e): return e.is_alive).size() == 0:
           DynamicMusicManager.set_state(DynamicMusicManager.MusicState.EXPLORATION)
   ```

6) Place Audio in Level:
   ```
   Level_1
   ├── AmbienceZone (covers whole level)
   │   └── ambient_loop: amb_urban_ruins.ogg
   │   └── one_shots: [metal_creak, distant_collapse, wind_gust]
   ├── Interior_Zone_1 (building interiors)
   │   └── ambient_loop: amb_interior_drip.ogg
   │   └── reverb_preset: "small_room"
   └── Environmental_Audio
       ├── EnvAudioSource (near rubble pile)
       │   └── sounds: [debris_settle_1, debris_settle_2]
       ├── EnvAudioSource (near broken pipe)
       │   └── sounds: [water_drip_1, water_drip_2]
       └── AudioStreamPlayer3D (constant: wind through gap)
           └── stream: wind_whistle_loop.ogg
   ```

## Audio Asset Checklist
```
Required ambient loops:
- [ ] amb_urban_ruins_loop.ogg (exterior base)
- [ ] amb_interior_basement.ogg
- [ ] amb_wind_exposed.ogg

Required one-shots:
- [ ] sfx_env_metal_creak_01-03.ogg
- [ ] sfx_env_distant_collapse_01-02.ogg
- [ ] sfx_env_debris_settle_01-03.ogg
- [ ] sfx_env_glass_tinkle_01-02.ogg

Required music tracks:
- [ ] mus_explore_base.ogg (looping)
- [ ] mus_tension_layer.ogg (looping, sync)
- [ ] mus_combat_layer.ogg (looping, sync)
```

## Acceptance Criteria
- [ ] Ambient audio plays in designated zones
- [ ] Smooth transitions when entering/exiting zones
- [ ] Random one-shots add life to environment
- [ ] Music responds to combat state
- [ ] 3D sounds positioned correctly
- [ ] No audio clipping or distortion
- [ ] Performance impact minimal (<1ms)
