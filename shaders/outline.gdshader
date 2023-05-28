shader_type canvas_item;

uniform vec4 outline_color: source_color = vec4(1.0);
uniform float width: hint_range(0.0, 10.0) = 1.0;

vec4 get_color_at(sampler2D tex, vec2 uv) {
	vec4 color = texture(tex, uv);
	if (uv != clamp(uv, vec2(0.0), vec2(1.0))) {
		color.a = 0.0;
	}
	
	return color;
}

void vertex() {
	VERTEX *= 2.0;
}

void fragment() {
	
	vec2 uv = UV * 2.0 - 0.5;
	vec4 color = get_color_at(TEXTURE, uv);
	
	if (color.a == 0.0) {
		for (int x = -1; x <= 1; x++) {
			for (int y = -1; y <= 1; y++) {
				
				vec2 offset = vec2(float(x), float(y)) * TEXTURE_PIXEL_SIZE * width;
				vec4 col = get_color_at(TEXTURE, uv + offset);
				
				if (col.a == 1.0) {
					color = outline_color;
				}
				
			}
		}
	}
	
	COLOR = color;
}
