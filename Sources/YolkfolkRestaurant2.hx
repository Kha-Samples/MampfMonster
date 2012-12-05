package;

import kha.Configuration;
import kha.Game;
import kha.graphics.FragmentShader;
import kha.graphics.Texture;
import kha.graphics.VertexBuffer;
import kha.graphics.VertexShader;
import kha.Loader;
import kha.LoadingScreen;
import kha.Painter;

class YolkfolkRestaurant2 extends Game {
	private var vertexShader: VertexShader;
	private var fragmentShader: FragmentShader;
	private var texture: Texture;
	private var vertexBuffer: VertexBuffer;
	
	public function new() {
		super("Yolkfolk Restaurant", false);
		kha.Sys.needs3d = true;
	}
	
	override public function init(): Void {
		Configuration.setScreen(new LoadingScreen());
		Loader.the.loadRoom("restaurant2", initLevel);
	}
	
	private function initLevel(): Void {
		texture = kha.Sys.graphics.createTexture(Loader.the.getImage("pattern_wall_restaurant.png"));
		vertexShader = kha.Sys.graphics.createVertexShader(
			"attribute vec3 pos;" +
			"attribute vec2 tex;" +
			"varying vec4 position;" +
			"varying vec2 texcoord;" +
			"void main() {" +
				"texcoord = tex;" +
				"gl_Position = position = vec4(pos.x / pos.z, pos.y, pos.z, 1.0);" +
			"}"
		);
		fragmentShader = kha.Sys.graphics.createFragmentShader(
			"#ifdef GL_ES\n" +
			"precision highp float;\n" +
			"#endif\n" +
			"uniform sampler2D sampler;\n" +
			"varying vec4 position;\n" +
			"varying vec2 texcoord;\n" +
			"void main() {" +
				"gl_FragColor = vec4(texture2D(sampler, texcoord).xyz, texture2D(sampler, texcoord).a);" +
			"}"
		);
		vertexBuffer = kha.Sys.graphics.createVertexBuffer(4, 5 * 4);
		var vertices = vertexBuffer.lock();
		var xoffset = 0.0;
		vertices[ 0] = -1.0 + xoffset; vertices[ 1] = 0.0; vertices[ 2] = 1.0; vertices[ 3] = 0.0; vertices[ 4] = 0.0;
		vertices[ 5] = -1.0 + xoffset; vertices[ 6] = 1.0; vertices[ 7] = 1.0; vertices[ 8] = 0.0; vertices[ 9] = 1.0;
		vertices[10] =  1.0 + xoffset; vertices[11] = 0.0; vertices[12] = 1.0; vertices[13] = 1.0; vertices[14] = 0.0;
		vertices[15] =  1.0 + xoffset; vertices[16] = 1.0; vertices[17] = 1.0; vertices[18] = 1.0; vertices[19] = 1.0;
		vertexBuffer.unlock();
		Configuration.setScreen(this);
	}
	
	override public function render(painter: Painter) {
		kha.Sys.graphics.setVertexShader(vertexShader);
		kha.Sys.graphics.setFragmentShader(fragmentShader);
		kha.Sys.graphics.linkShaders();
		texture.set(0);
		kha.Sys.graphics.setVertexBuffer(vertexBuffer);
		kha.Sys.graphics.drawArrays();
	}
}