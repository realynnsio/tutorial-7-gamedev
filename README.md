# Tutorial 7: Latihan Mandiri

Reference: https://csui-game-development.github.io/tutorials/tutorial-7/

For this tutorial, due to time constraints and the continuous struggle of fighting my own demons, I was only able to implement one mechanic outside of the main tutorial: sprinting & crouching.

All I did to implement this was to mess with the speed calculations given certain key events (faster when shift is pressed, slower when ctrl is pressed) and added an extra oomph of moving the player's camera downwards when they're currently crouching. That's it! Code below.

```
var speed_mult = 1 # base multiplier

...

func _physics_process(delta):
	...
	
	# Run, Crouch, Walk
	if Input.is_key_pressed(KEY_SHIFT):
		speed_mult = 4
	elif Input.is_key_pressed(KEY_CTRL):
		speed_mult = 0.3
	else:
		speed_mult = 1
		
	velocity.x = lerp(velocity.x, movement_vector.x * speed_mult * speed, acceleration * delta)
	velocity.z = lerp(velocity.z, movement_vector.z * speed_mult * speed, acceleration * delta)
	
	# Head position
	if Input.is_key_pressed(KEY_CTRL):
		head.position.y = head_position - 0.5
	else:
		head.position.y = head_position
    
    ...
```