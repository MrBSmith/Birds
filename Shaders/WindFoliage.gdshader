shader_type canvas_item;

uniform sampler2D noise1;
uniform sampler2D noise2;

uniform vec2 deform1 = vec2(0.002);
uniform vec2 deform2 = vec2(0.002);

uniform float speed1 : hint_range(0.0, 99.0) = 1.0;
uniform float speed2 : hint_range(0.0, 99.0) = 1.0;

void fragment() {
	vec2 n1_offset = texture(noise1, UV).rg * vec2(sin(TIME * speed1)) * deform1;
	vec2 n2_offset = texture(noise2, UV).rg * vec2(sin(TIME * speed2)) * deform2;
	
	COLOR = texture(TEXTURE, UV + n1_offset + n2_offset);
}
