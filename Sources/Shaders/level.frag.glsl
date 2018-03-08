#version 450

uniform sampler2D texsample;
in vec2 texcoord;
out vec4 frag;

void main() {
	frag = vec4(texture(texsample, texcoord).xyz, texture(texsample, texcoord).a);
}
