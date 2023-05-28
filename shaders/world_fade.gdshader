shader_type canvas_item;

void fragment() {
	
	float size = 2000.0;
	float uv_limit = size / 4000.0; // 4000 = size of the rect the shader is attached to
	
	vec2 uv = (UV * 2.0) - vec2(1.0);
	float dist = distance(vec2(0.0), uv);
	
	float a = (dist / uv_limit) * (dist / uv_limit);
	COLOR = vec4(0.0,0.0,0.1, a);
}
