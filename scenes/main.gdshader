shader_type canvas_item;

void fragment() {
    // Adjust the 0.05 value to speed up or slow down the scrolling
    vec2 moving_uv = vec2(UV.x + TIME * 0.05, UV.y); 
    COLOR = texture(TEXTURE, moving_uv);
}
