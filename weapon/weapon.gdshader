// 视频作者的实现方式
shader_type canvas_item;

uniform vec4 line_color : source_color = vec4(0, 0, 0, 1); // 武器描边颜色 RGBA
uniform float line_thickness : hint_range(0, 10, 0.1) = 1.0; // 描边厚度值

// 八个方向坐标，作为描边扩散方向
const vec2 OFFSET[8] = {
	vec2(1, 0), vec2(1, 1), vec2(0, 1), vec2(-1, 1),
	vec2(-1, 0), vec2(-1, -1), vec2(0, -1), vec2(1, -1)
};

void fragment() {
	// TEXTURE_PIXEL_SIZE 表示纹理单个像素大小，值是 (1.0 / texture_width, 1.0 / texture_height)
	vec2 size = TEXTURE_PIXEL_SIZE * line_thickness; // 计算像素值大小
	float outline = 0.0; // 描边透明度

	for(int i = 0; i < OFFSET.length(); i++) {
		// 在 UV 坐标系中，(0, 0) 表示纹理的左下角，(1, 1) 表示右上角
		outline += texture(TEXTURE, UV + size * OFFSET[i]).a; // 叠加描边实现往外扩
	}

	outline = min(outline, 1); // 最大值 1，不透明

	vec4 color = texture(TEXTURE, UV);
	// 混合原始颜色和描边颜色
	COLOR = mix(color, line_color, outline - color.a);
}