shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

// og colour
uniform vec4 original_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); 

// new colour to replace og colour
uniform vec4 replace_color : source_color = vec4(0.0, 0.0, 1.0, 1.0); 

// how much of a match i want
uniform float tolerance : hint_range(0.0, 1.0) = 0.05; 

void fragment() {
    vec4 current_color = texture(TEXTURE, UV);
    
    float color_distance = distance(current_color.rgb, original_color.rgb);
    if (color_distance <= tolerance) {
        COLOR = vec4(replace_color.rgb, current_color.a);
    } else {
        COLOR = current_color;
    }
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
