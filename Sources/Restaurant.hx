package;

import kha.Assets;
import kha.Color;
import kha.Framebuffer;
import kha.graphics4.BlendingOperation;
import kha.graphics4.FragmentShader;
import kha.graphics4.IndexBuffer;
import kha.graphics4.MipMapFilter;
import kha.graphics4.PipelineState;
import kha.graphics4.TextureAddressing;
import kha.graphics4.TextureFilter;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexStructure;
import kha.Image;
import kha.input.Mouse;
import kha.math.Vector3;
import kha.Scaler;
import kha.Scheduler;
import kha.Shaders;
import kha.System;

class Restaurant {
	private var backbuffer: Image;
	private var vertexShader: VertexShader;
	private var fragmentShader: FragmentShader;
	private var pipeline: PipelineState;
	private var indexBuffer: IndexBuffer;
	private var wallTexture: Image;
	private var floorTexture: Image;
	private var doorTexture: Image;
	private var tableTexture: Image;
	private var lampTexture: Image;
	private var backWall: VertexBuffer;
	private var floor: VertexBuffer;
	private var rightWall: VertexBuffer;
	private var door: VertexBuffer;
	private var table: VertexBuffer;
	private var lamp: VertexBuffer;
	private var eggman: Eggman;
	private var time: Float = 0;
	
	public function new() {
		System.start({title: "Mampf Monster", width: 1024, height: 768}, (window) -> {
			backbuffer = Image.createRenderTarget(1024, 768);
			Assets.loadEverything(initLevel);
		});
	}
		
	private function initLevel(): Void {
		eggman = new Eggman();
		wallTexture = Assets.images.pattern_wall_restaurant;
		floorTexture = Assets.images.img_floor_frontal;
		doorTexture = Assets.images.img_kitchendoor_frontal;
		tableTexture = Assets.images.img_table;
		lampTexture = Assets.images.img_lamp2;
		vertexShader = Shaders.level_vert;
		fragmentShader = Shaders.level_frag;
		pipeline = new PipelineState();
		pipeline.vertexShader = vertexShader;
		pipeline.fragmentShader = fragmentShader;
		var structure = new VertexStructure();
		structure.add("pos", VertexData.Float3);
		structure.add("tex", VertexData.Float2);
		pipeline.inputLayout = [structure];
		pipeline.blendSource = BlendOne;
		pipeline.blendDestination = InverseSourceAlpha;
		pipeline.compile();
		
		backWall = new VertexBuffer(4, structure, Usage.StaticUsage);
		floor = new VertexBuffer(4, structure, Usage.StaticUsage);
		rightWall = new VertexBuffer(4, structure, Usage.StaticUsage);
		door = new VertexBuffer(4, structure, Usage.StaticUsage);
		table = new VertexBuffer(4, structure, Usage.StaticUsage);
		lamp = new VertexBuffer(4, structure, Usage.StaticUsage);
		
		indexBuffer = createIndexBufferForQuads(1);
		
		System.notifyOnFrames(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);
		Mouse.get().notify(mouseDown, null, null, null);
	}
	
	public static function createIndexBufferForQuads(count: Int): IndexBuffer {
		var ib = new IndexBuffer(count * 3 * 2, Usage.StaticUsage);
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
	
	function update(): Void {
		if (eggman == null) return;
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
	
	function render(frames: Array<Framebuffer>): Void {
		if (eggman == null) return;

		var frame = frames[0];
		
		var g = backbuffer.g4;
		g.begin();
		g.clear(Color.Black);
		g.setPipeline(pipeline);
		var samplerLocation = pipeline.getTextureUnit("texsample");
		g.setIndexBuffer(indexBuffer);
		
		g.setTexture(samplerLocation, wallTexture);
		g.setTextureParameters(samplerLocation, TextureAddressing.Repeat, TextureAddressing.Repeat, TextureFilter.LinearFilter, TextureFilter.LinearFilter, MipMapFilter.NoMipFilter);
		g.setVertexBuffer(backWall);
		g.drawIndexedVertices();
		
		g.setTexture(samplerLocation, floorTexture);
		g.setTextureParameters(samplerLocation, TextureAddressing.Repeat, TextureAddressing.Repeat, TextureFilter.LinearFilter, TextureFilter.LinearFilter, MipMapFilter.NoMipFilter);
		g.setVertexBuffer(floor);
		g.drawIndexedVertices();
		
		g.setTexture(samplerLocation, wallTexture);
		g.setTextureParameters(samplerLocation, TextureAddressing.Repeat, TextureAddressing.Repeat, TextureFilter.LinearFilter, TextureFilter.LinearFilter, MipMapFilter.NoMipFilter);
		g.setVertexBuffer(rightWall);
		g.drawIndexedVertices();
		
		g.setTexture(samplerLocation, doorTexture);
		g.setTextureParameters(samplerLocation, TextureAddressing.Clamp, TextureAddressing.Clamp, TextureFilter.LinearFilter, TextureFilter.LinearFilter, MipMapFilter.NoMipFilter);
		g.setVertexBuffer(door);
		g.drawIndexedVertices();
		
		eggman.render(g, time, xoffset);
		
		g.setPipeline(pipeline);
		g.setIndexBuffer(indexBuffer);
		
		g.setTexture(samplerLocation, tableTexture);
		g.setVertexBuffer(table);
		g.drawIndexedVertices();
		
		g.setTexture(samplerLocation, lampTexture);
		g.setVertexBuffer(lamp);
		g.drawIndexedVertices();
		g.end();
		
		frame.g2.begin();
		Scaler.scale(backbuffer, frame, kha.ScreenRotation.Rotation180);
		frame.g2.end();
	}
	
	private var aimx: Float = 0.0;
	private var aimy: Float = 0.0;
	private var xoffset: Float = 0.0;
	
	function mouseDown(button: Int, xi: Int, yi: Int): Void {
		var x: Float = xi;
		var y: Float = yi;
		x -= 40;
		y -= 200;
		x /= (1024 / 2);
		x -= 1.0;
		x *= -1.0;
		y /= (768 / 2);
		y -= 1.0;
		y *= -1.0;
		
		aimx = x - xoffset;
		aimy = y;
		eggman.setAim(aimx, aimy, calcZ(aimy));
	}
}
