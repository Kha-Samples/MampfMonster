package;

import kha.Loader;
import kha.graphics.FragmentShader;
import kha.graphics.Texture;
import kha.graphics.VertexData;
import kha.graphics.VertexShader;
import kha.graphics.VertexBuffer;
import kha.graphics.VertexStructure;

class Eggman {
	private var bodyVertexShader: VertexShader;
	private var bodyFragmentShader: FragmentShader;
	private var bodyVertexBuffer: VertexBuffer;
	private var bodyTexture: Texture;
	private var bodyNormals: Texture;
	private var faceTexture: Texture;
	
	public function new() {
		var structure = new VertexStructure();
		structure.add("pos", VertexData.Float3);
		bodyVertexBuffer = kha.Sys.graphics.createVertexBuffer(4, structure);
		var vertices = bodyVertexBuffer.lock();
		vertices[0] = -1.0; vertices[ 1] = -1.0; vertices[ 2] = 0.0;
		vertices[3] = -1.0; vertices[ 4] =  1.0; vertices[ 5] = 0.0;
		vertices[6] =  1.0; vertices[ 7] = -1.0; vertices[ 8] = 0.0;
		vertices[9] =  1.0; vertices[10] =  1.0; vertices[11] = 0.0;
		bodyVertexBuffer.unlock();
		
		bodyTexture = kha.Sys.graphics.createTexture(Loader.the.getImage("img_fur2"));
		bodyNormals = kha.Sys.graphics.createTexture(Loader.the.getImage("img_fur2n"));
		faceTexture = kha.Sys.graphics.createTexture(Loader.the.getImage("img_face_a1"));
		
		bodyVertexShader = kha.Sys.graphics.createVertexShader(Loader.the.getBlob("eggman_body.vs.glsl").toString());
		bodyFragmentShader = kha.Sys.graphics.createFragmentShader(Loader.the.getBlob("eggman_body.fs.glsl").toString());
	}
	
	private function drawBody(time: Float): Void {
		kha.Sys.graphics.setVertexShader(bodyVertexShader);
		kha.Sys.graphics.setFragmentShader(bodyFragmentShader);
		kha.Sys.graphics.linkShaders();
		
		bodyFragmentShader.setFloat("time", time);
		bodyFragmentShader.setFloat2("resolution", 1024.0, 768.0);

		bodyTexture.set(0);
		bodyNormals.set(1);
		faceTexture.set(2);
		
		kha.Sys.graphics.setVertexBuffer(bodyVertexBuffer);
		kha.Sys.graphics.drawArrays();
	
		//drawObject(texture2, normals2, 0.26, 0.3, 0.3, 0.3);
	}
	
	public function render(time: Float): Void {
		drawBody(time);
	}
}