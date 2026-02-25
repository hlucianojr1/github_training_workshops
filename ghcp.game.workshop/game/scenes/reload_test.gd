extends Node

func _ready():
	print("=== RELOAD SYSTEM TEST ===")
	
	# Get player and weapon
	var player: Node = get_node("/root/TestScene/Player")
	var weapon: Node = player.get_node("Weapon")
	
	if not weapon:
		print("FAIL: Weapon not found")
		return
	
	# Test 1: Initial state
	print("\n--- Test 1: Initial State ---")
	print("Magazine: ", weapon.get_current_mag_ammo(), "/", weapon.get_mag_capacity())
	print("Reserve: ", weapon.get_reserve_ammo())
	print("Is reloading: ", weapon.get_is_reloading())
	
	# Test 2: Fire until empty
	print("\n--- Test 2: Fire Until Empty ---")
	var initial_mag: int = weapon.get_current_mag_ammo()
	for i in range(initial_mag + 2):  # Try to fire more than mag capacity
		weapon.fire()
		await get_tree().create_timer(0.1).timeout
	print("After firing ", initial_mag + 2, " times:")
	print("Magazine: ", weapon.get_current_mag_ammo(), "/", weapon.get_mag_capacity())
	
	# Test 3: Start reload
	print("\n--- Test 3: Reload System ---")
	print("Can reload: ", weapon.can_reload())
	weapon.start_reload()
	print("Is reloading: ", weapon.get_is_reloading())
	print("Reload progress: ", weapon.get_reload_progress())
	
	# Test 4: Cannot fire during reload
	print("\n--- Test 4: Cannot Fire During Reload ---")
	print("Can fire during reload: ", weapon.can_fire())
	weapon.fire()  # Should fail
	
	# Test 5: Wait for reload to complete
	print("\n--- Test 5: Complete Reload ---")
	var reload_time: float = weapon.get_reload_time()
	print("Waiting ", reload_time, " seconds for reload...")
	await get_tree().create_timer(reload_time + 0.1).timeout
	print("Magazine after reload: ", weapon.get_current_mag_ammo(), "/", weapon.get_mag_capacity())
	print("Reserve after reload: ", weapon.get_reserve_ammo())
	print("Is reloading: ", weapon.get_is_reloading())
	
	# Test 6: Can fire after reload
	print("\n--- Test 6: Fire After Reload ---")
	print("Can fire after reload: ", weapon.can_fire())
	weapon.fire()
	print("Magazine after shot: ", weapon.get_current_mag_ammo())
	
	# Test 7: Cancel reload
	print("\n--- Test 7: Cancel Reload ---")
	weapon.fire()
	weapon.start_reload()
	print("Started reload, is_reloading: ", weapon.get_is_reloading())
	weapon.cancel_reload()
	print("After cancel, is_reloading: ", weapon.get_is_reloading())
	print("Magazine unchanged: ", weapon.get_current_mag_ammo())
	
	print("\n=== RELOAD TESTS COMPLETE ===")
	get_tree().quit()
