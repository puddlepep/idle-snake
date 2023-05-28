shader_type canvas_item;

uniform sampler2D noise;
uniform vec4 color : source_color;

void fragment() {
	vec4 n = texture(noise, UV);
	COLOR = mix(color, n, 0.2) * COLOR.a;
}
