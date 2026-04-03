shader_type canvas_item;

instance uniform float darkness_mult : hint_range(0.0, 1.0, 0.1) = .5;

void vertex() {
	
	// Called for every vertex the material is visible on.
}

// Frag shader in godot by default is modulate x self modulate x texture
void fragment() {
	
	COLOR.rgb *= darkness_mult;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
