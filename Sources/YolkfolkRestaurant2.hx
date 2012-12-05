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
	private var wallTexture: Texture;
	private var floorTexture: Texture;
	private var doorTexture: Texture;
	private var backWall: VertexBuffer;
	private var floor: VertexBuffer;
	private var rightWall: VertexBuffer;
	private var door: VertexBuffer;
	private var time: Float = 0;
	
	public function new() {
		super("Yolkfolk Restaurant", false);
		kha.Sys.needs3d = true;
	}
	
	override public function init(): Void {
		Configuration.setScreen(new LoadingScreen());
		Loader.the.loadRoom("restaurant2", initLevel);
	}
	
	private function initLevel(): Void {
		wallTexture = kha.Sys.graphics.createTexture(Loader.the.getImage("pattern_wall_restaurant.png"));
		floorTexture = kha.Sys.graphics.createTexture(Loader.the.getImage("img_floor_frontal.png"));
		doorTexture = kha.Sys.graphics.createTexture(Loader.the.getImage("img_kitchendoor_frontal.png"));
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
		backWall = kha.Sys.graphics.createVertexBuffer(4, 5 * 4);
		floor = kha.Sys.graphics.createVertexBuffer(4, 5 * 4);
		rightWall = kha.Sys.graphics.createVertexBuffer(4, 5 * 4);
		door = kha.Sys.graphics.createVertexBuffer(4, 5 * 4);
		
		Configuration.setScreen(this);
	}
	
	override public function update(): Void {
		super.update();
		time += 1.0 / 60.0;
		var xoffset = -time / 30.0;
		
		var vertices = backWall.lock();
		vertices[ 0] = -1.0 + xoffset; vertices[ 1] =  0.0; vertices[ 2] = 1.0; vertices[ 3] = 0.0; vertices[ 4] = 0.0;
		vertices[ 5] = -1.0 + xoffset; vertices[ 6] =  1.0; vertices[ 7] = 1.0; vertices[ 8] = 0.0; vertices[ 9] = 1.0;
		vertices[10] =  1.0 + xoffset; vertices[11] =  0.0; vertices[12] = 1.0; vertices[13] = 1.0; vertices[14] = 0.0;
		vertices[15] =  1.0 + xoffset; vertices[16] =  1.0; vertices[17] = 1.0; vertices[18] = 1.0; vertices[19] = 1.0;
		backWall.unlock();
		
		vertices = floor.lock();
		vertices[ 0] = -1.0 + xoffset; vertices[ 1] = -1.0; vertices[ 2] = 0.5; vertices[ 3] = 0.0; vertices[ 4] = 0.0;
		vertices[ 5] = -1.0 + xoffset; vertices[ 6] =  0.0; vertices[ 7] = 1.0; vertices[ 8] = 0.0; vertices[ 9] = 1.0;
		vertices[10] =  1.0 + xoffset; vertices[11] = -1.0; vertices[12] = 0.5; vertices[13] = 1.0; vertices[14] = 0.0;
		vertices[15] =  1.0 + xoffset; vertices[16] =  0.0; vertices[17] = 1.0; vertices[18] = 1.0; vertices[19] = 1.0;
		floor.unlock();
		
		vertices = rightWall.lock();
		vertices[ 0] =  1.0 + xoffset; vertices[ 1] =  0.0; vertices[ 2] = 1.0; vertices[ 3] = 0.0; vertices[ 4] = 0.0;
		vertices[ 5] =  1.0 + xoffset; vertices[ 6] =  1.0; vertices[ 7] = 1.0; vertices[ 8] = 0.0; vertices[ 9] = 1.0;
		vertices[10] =  1.0 + xoffset; vertices[11] = -1.0; vertices[12] = 0.5; vertices[13] = 1.0; vertices[14] = 0.0;
		vertices[13] =  1.0 + xoffset; vertices[14] =  1.0; vertices[15] = 0.5; vertices[18] = 1.0; vertices[19] = 1.0;
		rightWall.unlock();

		vertices = door.lock();
		vertices[ 0] =  1.0 + xoffset; vertices[ 1] = -0.5; vertices[ 2] = 2.0 / 3.0; vertices[ 3] = 0.0; vertices[ 4] = 0.0;
		vertices[ 5] =  1.0 + xoffset; vertices[ 6] =  0.5; vertices[ 7] = 2.0 / 3.0; vertices[ 8] = 0.0; vertices[ 9] = 1.0;
		vertices[10] =  1.0 + xoffset; vertices[11] = -1.0; vertices[12] = 0.5;       vertices[13] = 1.0; vertices[14] = 0.0;
		vertices[13] =  1.0 + xoffset; vertices[14] =  0.5; vertices[15] = 0.5;       vertices[18] = 1.0; vertices[19] = 1.0;
		door.unlock();
	}
	
	override public function render(painter: Painter): Void {
		kha.Sys.graphics.setVertexShader(vertexShader);
		kha.Sys.graphics.setFragmentShader(fragmentShader);
		kha.Sys.graphics.linkShaders();
		
		wallTexture.set(0);
		kha.Sys.graphics.setVertexBuffer(backWall);
		kha.Sys.graphics.drawArrays();
		
		floorTexture.set(0);
		kha.Sys.graphics.setVertexBuffer(floor);
		kha.Sys.graphics.drawArrays();
		
		wallTexture.set(0);
		kha.Sys.graphics.setVertexBuffer(rightWall);
		kha.Sys.graphics.drawArrays();
		
		doorTexture.set(0);
		kha.Sys.graphics.setVertexBuffer(door);
		kha.Sys.graphics.drawArrays();
	}
}