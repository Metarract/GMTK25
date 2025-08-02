shader_type canvas_item;

uniform float strength : hint_range(0.0, 0.7);
const vec4 WHITE = vec4(1.,1.,1.,1.);

void fragment() {
  COLOR = mix(COLOR, vec4(WHITE.rgb, COLOR.a), strength);
}