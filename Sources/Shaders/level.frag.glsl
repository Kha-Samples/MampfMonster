#version 100

#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D textex;
varying vec2 texcoord;

void kore() {
	gl_FragColor = vec4(texture2D(textex, texcoord).xyz, texture2D(textex, texcoord).a);
}
