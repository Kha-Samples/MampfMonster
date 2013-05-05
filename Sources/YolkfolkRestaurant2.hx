package;

import kha.Configuration;
import kha.Game;
import kha.graphics.FragmentShader;
import kha.graphics.IndexBuffer;
import kha.graphics.Program;
import kha.graphics.Texture;
import kha.graphics.TextureWrap;
import kha.graphics.VertexBuffer;
import kha.graphics.VertexData;
import kha.graphics.VertexShader;
import kha.graphics.VertexStructure;
import kha.graphics.VertexType;
import kha.Loader;
import kha.LoadingScreen;
import kha.Painter;
import kha.math.Vector3;

class YolkfolkRestaurant2 extends Game {
	private var vertexShader: VertexShader;
	private var fragmentShader: FragmentShader;
	private var program: Program;
	private var indexBuffer: IndexBuffer;
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
	}
	
	override public function init(): Void {
		Configuration.setScreen(new LoadingScreen());
		Loader.the.loadRoom("restaurant2", initLevel);
	}
	
	private function initLevel(): Void {
		eggman = new Eggman();
		wallTexture = cast Loader.the.getImage("pattern_wall_restaurant");
		floorTexture = cast Loader.the.getImage("img_floor_frontal");
		doorTexture = cast Loader.the.getImage("img_kitchendoor_frontal");
		tableTexture = cast Loader.the.getImage("img_table");
		lampTexture = cast Loader.the.getImage("img_lamp2");
		vertexShader = kha.Sys.graphics.createVertexShader(Loader.the.getShader("level.vert"));
		fragmentShader = kha.Sys.graphics.createFragmentShader(Loader.the.getShader("level.frag"));
		program = kha.Sys.graphics.createProgram();
		program.setVertexShader(vertexShader);
		program.setFragmentShader(fragmentShader);
		
		var structure = new VertexStructure();
		structure.add("pos", VertexData.Float3, VertexType.Position);
		structure.add("tex", VertexData.Float2, VertexType.TexCoord);
		program.link(structure);
		
		backWall = kha.Sys.graphics.createVertexBuffer(4, structure);
		floor = kha.Sys.graphics.createVertexBuffer(4, structure);
		rightWall = kha.Sys.graphics.createVertexBuffer(4, structure);
		door = kha.Sys.graphics.createVertexBuffer(4, structure);
		table = kha.Sys.graphics.createVertexBuffer(4, structure);
		lamp = kha.Sys.graphics.createVertexBuffer(4, structure);
		
		indexBuffer = createIndexBufferForQuads(1);
		
		Configuration.setScreen(this);
	}
	
	public static function createIndexBufferForQuads(count: Int): IndexBuffer {
		var ib = kha.Sys.graphics.createIndexBuffer(count * 3 * 2);
		var buffer = ib.lock();
		var i: Int = 0;
		var bi: Int = 0;
		while (bi < count * 3 * 2) {
			buffer[bi + 0] = i;
			buffer[bi + 1] = i + 1;
			buffer[bi + 2] = i + 2;
			buffer[bi + 3] = i + 2;
			buffer[bi + 4] = i + 1;
			buffer[bi + 5] = i + 3;
			
			i += 4;
			bi += 6;
		}
		ib.unlock();
		return ib;
	}
	
	public static function calcZ(y: Float): Float {
		if (y < 0) return (y + 1) / 2 + 0.5;
		else return 1.0;
	}
	
	override public function update(): Void {
		if (eggman == null) return;
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
		vertices[ 0] = -1.0 + xoffset; vertices[ 1] =  0.0; vertices[ 2] = 1.0; vertices[ 3] = 0.0; vertices[ 4] = 1.0;
		vertices[ 5] = -1.0 + xoffset; vertices[ 6] =  1.0; vertices[ 7] = 1.0; vertices[ 8] = 0.0; vertices[ 9] = 0.0;
		vertices[10] =  1.0 + xoffset; vertices[11] =  0.0; vertices[12] = 1.0; vertices[13] = 2.0 * 1024 / 768; vertices[14] = 1.0;
		vertices[15] =  1.0 + xoffset; vertices[16] =  1.0; vertices[17] = 1.0; vertices[18] = 2.0 * 1024 / 768; vertices[19] = 0.0;
		backWall.unlock();
		
		vertices = floor.lock();
		vertices[ 0] = -1.0 + xoffset; vertices[ 1] = -1.0; vertices[ 2] = 0.5; vertices[ 3] = 0.0; vertices[ 4] = 3.0;
		vertices[ 5] = -1.0 + xoffset; vertices[ 6] =  0.0; vertices[ 7] = 1.0; vertices[ 8] = 0.0; vertices[ 9] = 0.0;
		vertices[10] =  1.0 + xoffset; vertices[11] = -1.0; vertices[12] = 0.5; vertices[13] = 3.0; vertices[14] = 3.0;
		vertices[15] =  1.0 + xoffset; vertices[16] =  0.0; vertices[17] = 1.0; vertices[18] = 3.0; vertices[19] = 0.0;
		floor.unlock();
		
		vertices = rightWall.lock();
		vertices[ 0] =  1.0 + xoffset; vertices[ 1] =  0.0; vertices[ 2] = 1.0; vertices[ 3] = 0.0; vertices[ 4] = 1.0;
		vertices[ 5] =  1.0 + xoffset; vertices[ 6] =  1.0; vertices[ 7] = 1.0; vertices[ 8] = 0.0; vertices[ 9] = 0.0;
		vertices[10] =  1.0 + xoffset; vertices[11] = -1.0; vertices[12] = 0.5; vertices[13] = 1.0; vertices[14] = 1.0;
		vertices[15] =  1.0 + xoffset; vertices[16] =  1.0; vertices[17] = 0.5; vertices[18] = 1.0; vertices[19] = 0.0;
		rightWall.unlock();

		vertices = door.lock();
		vertices[ 0] =  1.0 + xoffset; vertices[ 1] = -0.5; vertices[ 2] = 2.0 / 3.0; vertices[ 3] = 0.0; vertices[ 4] = 1.0;
		vertices[ 5] =  1.0 + xoffset; vertices[ 6] =  0.5; vertices[ 7] = 2.0 / 3.0; vertices[ 8] = 0.0; vertices[ 9] = 0.0;
		vertices[10] =  1.0 + xoffset; vertices[11] = -1.0; vertices[12] = 0.5;       vertices[13] = 1.0; vertices[14] = 1.0;
		vertices[15] =  1.0 + xoffset; vertices[16] =  0.5; vertices[17] = 0.5;       vertices[18] = 1.0; vertices[19] = 0.0;
		door.unlock();
		
		vertices = table.lock();
		vertices[ 0] = -0.2 + xoffset; vertices[ 1] = -0.7; vertices[ 2] = 0.7; vertices[ 3] = 0.0; vertices[ 4] = 1.0;
		vertices[ 5] = -0.2 + xoffset; vertices[ 6] = -0.2; vertices[ 7] = 0.7; vertices[ 8] = 0.0; vertices[ 9] = 0.0;
		vertices[10] =  0.2 + xoffset; vertices[11] = -0.7; vertices[12] = 0.7; vertices[13] = 1.0; vertices[14] = 1.0;
		vertices[15] =  0.2 + xoffset; vertices[16] = -0.2; vertices[17] = 0.7; vertices[18] = 1.0; vertices[19] = 0.0;
		table.unlock();
		
		vertices = lamp.lock();
		vertices[ 0] = -0.1 + xoffset; vertices[ 1] =  0.2; vertices[ 2] = 0.7; vertices[ 3] = 0.0; vertices[ 4] = 1.0;
		vertices[ 5] = -0.1 + xoffset; vertices[ 6] =  0.8; vertices[ 7] = 0.7; vertices[ 8] = 0.0; vertices[ 9] = 0.0;
		vertices[10] =  0.1 + xoffset; vertices[11] =  0.2; vertices[12] = 0.7; vertices[13] = 1.0; vertices[14] = 1.0;
		vertices[15] =  0.1 + xoffset; vertices[16] =  0.8; vertices[17] = 0.7; vertices[18] = 1.0; vertices[19] = 0.0;
		lamp.unlock();
		
		//eggman.setPosition(xoffset, 0, 0);
		eggman.setLight(new Vector3(0, 0.5, 0.7));
		eggman.update();
	}
	
	override public function render(painter: Painter): Void {
		if (eggman == null) return;
		kha.Sys.graphics.setProgram(program);
		var samplerLocation = program.getConstantLocation("sampler");
		kha.Sys.graphics.setIndexBuffer(indexBuffer);
		
		kha.Sys.graphics.setTexture(samplerLocation, wallTexture);
		kha.Sys.graphics.setTextureWrap(samplerLocation, TextureWrap.Repeat, TextureWrap.Repeat);
		kha.Sys.graphics.setVertexBuffer(backWall);
		kha.Sys.graphics.drawIndexedVertices();
		
		kha.Sys.graphics.setTexture(samplerLocation, floorTexture);
		kha.Sys.graphics.setTextureWrap(samplerLocation, TextureWrap.Repeat, TextureWrap.Repeat);
		kha.Sys.graphics.setVertexBuffer(floor);
		kha.Sys.graphics.drawIndexedVertices();
		
		kha.Sys.graphics.setTexture(samplerLocation, wallTexture);
		kha.Sys.graphics.setTextureWrap(samplerLocation, TextureWrap.Repeat, TextureWrap.Repeat);
		kha.Sys.graphics.setVertexBuffer(rightWall);
		kha.Sys.graphics.drawIndexedVertices();
		
		kha.Sys.graphics.setTexture(samplerLocation, doorTexture);
		kha.Sys.graphics.setTextureWrap(samplerLocation, TextureWrap.ClampToEdge, TextureWrap.ClampToEdge);
		kha.Sys.graphics.setVertexBuffer(door);
		kha.Sys.graphics.drawIndexedVertices();
		
		eggman.render(time, xoffset);
		
		kha.Sys.graphics.setProgram(program);
		kha.Sys.graphics.setIndexBuffer(indexBuffer);
		
		kha.Sys.graphics.setTexture(samplerLocation, tableTexture);
		kha.Sys.graphics.setTextureWrap(samplerLocation, TextureWrap.ClampToEdge, TextureWrap.ClampToEdge);
		kha.Sys.graphics.setVertexBuffer(table);
		kha.Sys.graphics.drawIndexedVertices();
		
		kha.Sys.graphics.setTexture(samplerLocation, lampTexture);
		kha.Sys.graphics.setTextureWrap(samplerLocation, TextureWrap.ClampToEdge, TextureWrap.ClampToEdge);
		kha.Sys.graphics.setVertexBuffer(lamp);
		kha.Sys.graphics.drawIndexedVertices();
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
		eggman.setAim(aimx, aimy, calcZ(aimy));
	}
}
