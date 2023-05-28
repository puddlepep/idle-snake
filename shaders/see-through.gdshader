shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec4 screen_col = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	vec4 tex_col = texture(TEXTURE, UV);
	
	if (screen_col != tex_col) {
		COLOR = vec4(0.0,0.0,0.0,0.3);
		COLOR.a *= tex_col.a;
	}
}
