shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec2 resolution = vec2(240, 240);

void fragment() {
	vec2 uv = floor(SCREEN_UV * resolution) / resolution;
	COLOR = textureLod(SCREEN_TEXTURE, uv, 0.0);
}
