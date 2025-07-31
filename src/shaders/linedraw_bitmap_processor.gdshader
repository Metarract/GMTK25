shader_type canvas_item;

uniform vec4 line_color:source_color = vec4(1.,1.,1.,1.);
const vec4 WHITE = vec4(1.,1.,1.,1.);
const vec4 BLACK = vec4(0.,0.,0.,1.);
const vec4 TRANSPARENT=vec4(0.,0.,0.,0.);

void fragment() {
  vec4 pixel = texture(TEXTURE,UV);
  
  if (pixel == WHITE) {
    COLOR = line_color;
  } else if (pixel == BLACK) {
    COLOR = TRANSPARENT;
  }
}