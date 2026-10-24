shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}


uniform vec4 original_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); 
uniform vec4 replace_color : source_color = vec4(0.0, 0.0, 1.0, 1.0); 
uniform float tolerance : hint_range(0.0, 1.0) = 0.05; 


uniform float flash_modifier : hint_range(0.0, 1.0) = 0.0;
uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // Default White

void fragment() {
    vec4 current_color = texture(TEXTURE, UV);

    float color_distance = distance(current_color.rgb, original_color.rgb);
    if (color_distance <= tolerance) {
        current_color = vec4(replace_color.rgb, current_color.a);
    }
    
    current_color.rgb = mix(current_color.rgb, flash_color.rgb, flash_modifier);
    
    COLOR = current_color;
}
