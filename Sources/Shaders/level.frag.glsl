#version 100

#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;
varying vec4 position;
varying vec2 texcoord;

void kmain() {
	gl_FragColor = vec4(texture2D(sampler, texcoord).xyz, texture2D(sampler, texcoord).a);
}
