shader_type spatial;
render_mode blend_mix, depth_draw_always, cull_disabled, diffuse_lambert, specular_schlick_ggx;

uniform sampler2D tex_frg_2;



void fragment() {
// VectorCompose:6
	float n_in6p0 = 0.02000;
	float n_in6p1 = 0.10000;
	float n_in6p2 = 0.00000;
	vec3 n_out6p0 = vec3(n_in6p0, n_in6p1, n_in6p2);


// Input:3
	float n_out3p0 = TIME;


// FloatOp:5
	float n_out5p0 = n_out6p0.x * n_out3p0;


// Input:7
	vec2 n_out7p0 = UV;


// VectorOp:8
	vec3 n_out8p0 = vec3(n_out5p0) + vec3(n_out7p0, 0.0);


// Texture2D:2
	vec4 n_out2p0 = texture(tex_frg_2, vec2(n_out8p0.xy));


// Output:0
	ALBEDO = vec3(n_out2p0.xyz);
	ALPHA = 0.8;

}