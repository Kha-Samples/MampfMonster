package;

import kha.Configuration;
import kha.Game;
import kha.graphics.FragmentShader;
import kha.graphics.Texture;
import kha.graphics.TextureWrap;
import kha.graphics.VertexBuffer;
import kha.graphics.VertexData;
import kha.graphics.VertexShader;
import kha.graphics.VertexStructure;
import kha.Loader;
import kha.LoadingScreen;
import kha.Painter;
import kha.Vector3;

class YolkfolkRestaurant2 extends Game {
	private var vertexShader: VertexShader;
	private var fragmentShader: FragmentShader;
	private var wallTexture: Texture;
	private var floorTexture: Texture;
	private var doorTexture: Texture;
	private var tableTexture: Texture;
	private var lampTexture: Texture;
	private var backWall: VertexBuffer;
	private var floor: VertexBuffer;
	private var rightWall: VertexBuffer;
	private var door: VertexBuffer;
	private var table: VertexBuffer;
	private var lamp: VertexBuffer;
	private var eggman: Eggman;
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
		eggman = new Eggman();
		wallTexture = kha.Sys.graphics.createTexture(Loader.the.getImage("pattern_wall_restaurant"));
		floorTexture = kha.Sys.graphics.createTexture(Loader.the.getImage("img_floor_frontal"));
		doorTexture = kha.Sys.graphics.createTexture(Loader.the.getImage("img_kitchendoor_frontal"));
		tableTexture = kha.Sys.graphics.createTexture(Loader.the.getImage("img_table"));
		lampTexture = kha.Sys.graphics.createTexture(Loader.the.getImage("img_lamp2"));
		vertexShader = kha.Sys.graphics.createVertexShader(
			"attribute vec3 pos;" +
			"attribute vec2 tex;" +
			"varying vec4 position;" +
			"varying vec2 texcoord;" +
			"void main() {" +
				"texcoord = tex;" +
				"gl_Position = position = vec4(pos.x, pos.y * pos.z, pos.z * pos.z, pos.z);" +
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
		
		var structure = new VertexStructure();
		structure.add("pos", VertexData.Float3);
		structure.add("tex", VertexData.Float2);
		
		backWall = kha.Sys.graphics.createVertexBuffer(4, structure);
		floor = kha.Sys.graphics.createVertexBuffer(4, structure);
		rightWall = kha.Sys.graphics.createVertexBuffer(4, structure);
		door = kha.Sys.graphics.createVertexBuffer(4, structure);
		table = kha.Sys.graphics.createVertexBuffer(4, structure);
		lamp = kha.Sys.graphics.createVertexBuffer(4, structure);
		
		Configuration.setScreen(this);
	}
	
	override public function update(): Void {
		super.update();
		time += 1.0 / 60.0;
		//var xoffset = 0;// -time / 30.0;
		var eggx = eggman.getPosition().x;
		if (Math.abs(eggx - xoffset) > 0.01) {
			if (eggx > -xoffset) xoffset -= 0.001;
			else xoffset += 0.001;
		}
		//else xoffset += 0.001;
		
		var vertices = backWall.lock();
		vertices[ 0] = -1.0 + xoffset; vertices[ 1] =  0.0; vertices[ 2] = 1.0; vertices[ 3] = 0.0; vertices[ 4] = 0.0;
		vertices[ 5] = -1.0 + xoffset; vertices[ 6] =  1.0; vertices[ 7] = 1.0; vertices[ 8] = 0.0; vertices[ 9] = 1.0;
		vertices[10] =  1.0 + xoffset; vertices[11] =  0.0; vertices[12] = 1.0; vertices[13] = 2.0 * 1024 / 768; vertices[14] = 0.0;
		vertices[15] =  1.0 + xoffset; vertices[16] =  1.0; vertices[17] = 1.0; vertices[18] = 2.0 * 1024 / 768; vertices[19] = 1.0;
		backWall.unlock();
		
		vertices = floor.lock();
		vertices[ 0] = -1.0 + xoffset; vertices[ 1] = -1.0; vertices[ 2] = 0.5; vertices[ 3] = 0.0; vertices[ 4] = 0.0;
		vertices[ 5] = -1.0 + xoffset; vertices[ 6] =  0.0; vertices[ 7] = 1.0; vertices[ 8] = 0.0; vertices[ 9] = 3.0;
		vertices[10] =  1.0 + xoffset; vertices[11] = -1.0; vertices[12] = 0.5; vertices[13] = 3.0; vertices[14] = 0.0;
		vertices[15] =  1.0 + xoffset; vertices[16] =  0.0; vertices[17] = 1.0; vertices[18] = 3.0; vertices[19] = 3.0;
		floor.unlock();
		
		vertices = rightWall.lock();
		vertices[ 0] =  1.0 + xoffset; vertices[ 1] =  0.0; vertices[ 2] = 1.0; vertices[ 3] = 0.0; vertices[ 4] = 0.0;
		vertices[ 5] =  1.0 + xoffset; vertices[ 6] =  1.0; vertices[ 7] = 1.0; vertices[ 8] = 0.0; vertices[ 9] = 1.0;
		vertices[10] =  1.0 + xoffset; vertices[11] = -1.0; vertices[12] = 0.5; vertices[13] = 1.0; vertices[14] = 0.0;
		vertices[15] =  1.0 + xoffset; vertices[16] =  1.0; vertices[17] = 0.5; vertices[18] = 1.0; vertices[19] = 1.0;
		rightWall.unlock();

		vertices = door.lock();
		vertices[ 0] =  1.0 + xoffset; vertices[ 1] = -0.5; vertices[ 2] = 2.0 / 3.0; vertices[ 3] = 0.0; vertices[ 4] = 0.0;
		vertices[ 5] =  1.0 + xoffset; vertices[ 6] =  0.5; vertices[ 7] = 2.0 / 3.0; vertices[ 8] = 0.0; vertices[ 9] = 1.0;
		vertices[10] =  1.0 + xoffset; vertices[11] = -1.0; vertices[12] = 0.5;       vertices[13] = 1.0; vertices[14] = 0.0;
		vertices[15] =  1.0 + xoffset; vertices[16] =  0.5; vertices[17] = 0.5;       vertices[18] = 1.0; vertices[19] = 1.0;
		door.unlock();
		
		vertices = table.lock();
		vertices[ 0] = -0.2 + xoffset; vertices[ 1] = -0.7; vertices[ 2] = 0.7; vertices[ 3] = 0.0; vertices[ 4] = 0.0;
		vertices[ 5] = -0.2 + xoffset; vertices[ 6] = -0.2; vertices[ 7] = 0.7; vertices[ 8] = 0.0; vertices[ 9] = 1.0;
		vertices[10] =  0.2 + xoffset; vertices[11] = -0.7; vertices[12] = 0.7; vertices[13] = 1.0; vertices[14] = 0.0;
		vertices[15] =  0.2 + xoffset; vertices[16] = -0.2; vertices[17] = 0.7; vertices[18] = 1.0; vertices[19] = 1.0;
		table.unlock();
		
		vertices = lamp.lock();
		vertices[ 0] = -0.1 + xoffset; vertices[ 1] =  0.2; vertices[ 2] = 0.7; vertices[ 3] = 0.0; vertices[ 4] = 0.0;
		vertices[ 5] = -0.1 + xoffset; vertices[ 6] =  0.8; vertices[ 7] = 0.7; vertices[ 8] = 0.0; vertices[ 9] = 1.0;
		vertices[10] =  0.1 + xoffset; vertices[11] =  0.2; vertices[12] = 0.7; vertices[13] = 1.0; vertices[14] = 0.0;
		vertices[15] =  0.1 + xoffset; vertices[16] =  0.8; vertices[17] = 0.7; vertices[18] = 1.0; vertices[19] = 1.0;
		lamp.unlock();
		
		//eggman.setPosition(xoffset, 0, 0);
		eggman.setLight(new Vector3(0, 0.5, 0.7));
		eggman.update();
	}
	
	override public function render(painter: Painter): Void {
		kha.Sys.graphics.setVertexShader(vertexShader);
		kha.Sys.graphics.setFragmentShader(fragmentShader);
		kha.Sys.graphics.linkShaders();
		fragmentShader.setInt("sampler", 0);
		
		wallTexture.set(0);
		kha.Sys.graphics.setTextureWrap(0, TextureWrap.Repeat, TextureWrap.Repeat);
		kha.Sys.graphics.setVertexBuffer(backWall);
		kha.Sys.graphics.drawArrays();
		
		floorTexture.set(0);
		kha.Sys.graphics.setTextureWrap(0, TextureWrap.Repeat, TextureWrap.Repeat);
		kha.Sys.graphics.setVertexBuffer(floor);
		kha.Sys.graphics.drawArrays();
		
		wallTexture.set(0);
		kha.Sys.graphics.setTextureWrap(0, TextureWrap.Repeat, TextureWrap.Repeat);
		kha.Sys.graphics.setVertexBuffer(rightWall);
		kha.Sys.graphics.drawArrays();
		
		doorTexture.set(0);
		kha.Sys.graphics.setTextureWrap(0, TextureWrap.ClampToEdge, TextureWrap.ClampToEdge);
		kha.Sys.graphics.setVertexBuffer(door);
		kha.Sys.graphics.drawArrays();
		
		tableTexture.set(0);
		kha.Sys.graphics.setTextureWrap(0, TextureWrap.ClampToEdge, TextureWrap.ClampToEdge);
		kha.Sys.graphics.setVertexBuffer(table);
		kha.Sys.graphics.drawArrays();
		
		lampTexture.set(0);
		kha.Sys.graphics.setTextureWrap(0, TextureWrap.ClampToEdge, TextureWrap.ClampToEdge);
		kha.Sys.graphics.setVertexBuffer(lamp);
		kha.Sys.graphics.drawArrays();
		
		eggman.render(time, xoffset);
	}
	
	private var aimx: Float = 0.0;
	private var aimy: Float = 0.0;
	private var xoffset: Float = 0.0;
	
	override public function mouseDown(xi: Int, yi: Int): Void {
		var x: Float = xi;
		var y: Float = yi;
		x -= 40;
		y -= 200;
		x /= (1024 / 2);
		x -= 1.0;
		y /= (768 / 2);
		y -= 1.0;
		y *= -1.0;
		
		aimx = x - xoffset;
		aimy = y;
		eggman.setAim(aimx, aimy, 0);
	}
}