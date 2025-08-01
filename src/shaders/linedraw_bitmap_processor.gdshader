shader_type canvas_item;

uniform vec4 line_color:source_color = vec4(1.,1.,1.,1.);
uniform float segment_radius;
uniform int segment_count = 0;
uniform lowp vec2 segments[1000];

const vec4 WHITE = vec4(1.,1.,1.,1.);
const vec4 BLACK = vec4(0.,0.,0.,1.);
const vec4 TRANSPARENT=vec4(0.,0.,0.,0.);

void fragment() {
  bool do_draw = false;
  if (segment_count < 1) {
    discard;
  }
  ivec2 tex_size = textureSize(TEXTURE, 0);
  vec2 screen_relative_position = vec2(tex_size) * UV;
  for (int i = 0; i < segment_count; i++) {
    vec2 segment = segments[i];
    if (distance(segment, screen_relative_position) > segment_radius) {
      continue;
    }
    do_draw = true;
    break;
  }
  if (do_draw) {
    COLOR = line_color;
  } else {
    COLOR = TRANSPARENT;
  }
}