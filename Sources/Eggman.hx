package;

import kha.graphics.IndexBuffer;
import kha.graphics.Program;
import kha.graphics.TextureWrap;
import kha.graphics.VertexType;
import kha.Loader;
import kha.graphics.FragmentShader;
import kha.graphics.Texture;
import kha.graphics.VertexData;
import kha.graphics.VertexShader;
import kha.graphics.VertexBuffer;
import kha.graphics.VertexStructure;
import kha.math.Vector3;

class Eggman {
	private var indexBuffer: IndexBuffer;
	private var bodyVertexShader: VertexShader;
	private var bodyFragmentShader: FragmentShader;
	private var bodyVertexBuffer: VertexBuffer;
	private var bodyProgram: Program;
	private var bodyTexture: Texture;
	private var bodyNormals: Texture;
	private var faceTexture: Texture;
	
	private var partsVertexShader: VertexShader;
	private var partsFragmentShader: FragmentShader;
	private var partsVertexBuffer: VertexBuffer;
	private var partsProgram: Program;
	private var earTexture: Texture;
	private var earNormals: Texture;
	private var handtex: Texture;
	private var handnormals: Texture;
	private var foottex: Texture;
	private var footnormals: Texture;
	
	private var position: Vector3;
	private var aim: Vector3;
	private var angle: Float;
	private var rotaim: Float;
	
	private var moving: Bool = false;
	private var rotating: Bool = false;
	
	private var lightPosition: Vector3;
	
	private var leftHandRot: Float;
	private var rightHandRot: Float;
	private var leftFootHeight: Float;
	private var leftFootSpeed: Float;
	private var leftFootMoving: Bool;
	private var rightFootHeight: Float;
	private var rightFootSpeed: Float;
	private var rightFootMoving: Bool;
	
	private static var jump: Float = 0.02;
	
	public function setLight(position: Vector3): Void {
		lightPosition = position;
	}
	
	public function setPosition(x: Float, y: Float, z: Float): Void {
		position = new Vector3(x, y, z);
	}
	
	public function getPosition(): Vector3 {
		return position;
	}
	
	public function setAim(x: Float, y: Float, z: Float): Void {
		aim = new Vector3(x, y, z);
		var direction = aim.sub(position);
		rotaim = Math.atan2(direction.y, direction.x);
		rotating = true;
		moving = false;
		
		leftFootSpeed = jump;
		leftFootMoving = true;	
	}
	
	public function update(): Void {
		var acc = -0.0025;
		if (moving || rotating) {
			if (leftFootMoving) {
				//var goingUp = leftFootSpeed > 0;
				leftFootSpeed += acc;
				//if (goingUp && leftFootSpeed < 0) rightFootMoving = true;
				leftFootHeight += leftFootSpeed;
				if (leftFootHeight < 0) {
					leftFootHeight = 0;
					//leftFootSpeed = jump;
					if (!rightFootMoving) {
						rightFootSpeed = jump;
						rightFootMoving = true;
					}
					leftFootMoving = false;
				}
			}
			
			if (rightFootMoving) {
				rightFootSpeed += acc;
				rightFootHeight += rightFootSpeed;
				if (rightFootHeight < 0) {
					rightFootHeight = 0;
					if (!leftFootMoving) {
						leftFootSpeed = jump;
						leftFootMoving = true;
					}
					rightFootMoving = false;
				}
			}
		}
		else {
			leftFootSpeed += acc;
			leftFootHeight += leftFootSpeed;
			if (leftFootHeight < 0) {
				leftFootHeight = 0;
				leftFootSpeed = 0;
				leftFootMoving = false;
			}
			
			rightFootSpeed += acc;
			rightFootHeight += rightFootSpeed;
			if (rightFootHeight < 0) {
				rightFootHeight = 0;
				rightFootSpeed = 0;
				rightFootMoving = false;
			}
		}
		
		if (moving) {
			leftHandRot += 0.07;
			rightHandRot += 0.07;
			leftHandRot = leftHandRot % (Math.PI * 2.0);
			rightHandRot = rightHandRot % (Math.PI * 2.0);
		}
		else {
			if (leftHandRot > 0) {
				leftHandRot += 0.07;
				rightHandRot += 0.07;
				if (leftHandRot > Math.PI * 2.0) {
					leftHandRot = 0;
					rightHandRot = 0;
				}
			}
		}
		var rotspeed = 0.02;
		//angle += rotspeed;
		if (rotating) {
			angle = adjustAngle(angle);
			rotaim = adjustAngle(rotaim);
			
			var amount1 = Math.abs(angle - rotaim);
			var amount2 = Math.abs(angle - (rotaim - Math.PI * 2.0));
			if (amount2 < amount1) {
				rotaim = rotaim - Math.PI * 2.0;
			}
			
			if (angle < rotaim) {
				angle += rotspeed;
				if (angle >= rotaim) {
					angle = rotaim;
					rotating = false;
					moving = true;
				}
			}
			else if (angle > rotaim) {
				angle -= rotspeed;
				if (angle <= rotaim) {
					angle = rotaim;
					rotating = false;
					moving = true;
				}
			}
		}
		else if (moving) {
			var speed = aim.sub(position);
			if (speed.length <= 0.005) {
				position = aim;
				moving = false;
				return;
			}
			speed.length = 0.003;
			position = position.add(speed);
		}
	}
	
	public function new() {
		indexBuffer = YolkfolkRestaurant2.createIndexBufferForQuads(1);
		leftHandRot = 0;
		rightHandRot = 0;
		leftFootHeight = 0;
		leftFootSpeed = 0;
		rightFootHeight = 0;
		rightFootSpeed = 0;
		leftFootMoving = false;
		rightFootMoving = false;
		position = new Vector3(0, 0, 0.5);
		aim = new Vector3();
		angle = 0;
		var structure = new VertexStructure();
		structure.add("position", VertexData.Float3, VertexType.Position);
		bodyVertexBuffer = kha.Sys.graphics.createVertexBuffer(4, structure);
		var vertices = bodyVertexBuffer.lock();
		vertices[0] = -1.0; vertices[ 1] = -1.0; vertices[ 2] = 0.0;
		vertices[3] = -1.0; vertices[ 4] =  1.0; vertices[ 5] = 0.0;
		vertices[6] =  1.0; vertices[ 7] = -1.0; vertices[ 8] = 0.0;
		vertices[9] =  1.0; vertices[10] =  1.0; vertices[11] = 0.0;
		bodyVertexBuffer.unlock();
		
		bodyTexture = cast Loader.the.getImage("img_fur2");
		bodyNormals = cast Loader.the.getImage("img_fur2n");
		faceTexture = cast Loader.the.getImage("img_face_a1");
		
		bodyVertexShader = kha.Sys.graphics.createVertexShader(Loader.the.getShader("eggman_body.vert"));
		bodyFragmentShader = kha.Sys.graphics.createFragmentShader(Loader.the.getShader("eggman_body.frag"));
		bodyProgram = kha.Sys.graphics.createProgram();
		bodyProgram.setVertexShader(bodyVertexShader);
		bodyProgram.setFragmentShader(bodyFragmentShader);
		bodyProgram.link(structure);
		
		partsVertexShader = kha.Sys.graphics.createVertexShader(Loader.the.getShader("eggman_parts.vert"));
		partsFragmentShader = kha.Sys.graphics.createFragmentShader(Loader.the.getShader("eggman_parts.frag"));
		partsProgram = kha.Sys.graphics.createProgram();
		structure = new VertexStructure();
		structure.add("pos", VertexData.Float3, VertexType.Position);
		structure.add("tex", VertexData.Float2, VertexType.TexCoord);
		partsProgram.setVertexShader(partsVertexShader);
		partsProgram.setFragmentShader(partsFragmentShader);
		partsProgram.link(structure);
		partsVertexBuffer = kha.Sys.graphics.createVertexBuffer(4, structure);
		earTexture = cast Loader.the.getImage("img_ear09_overlay");
		earNormals = cast Loader.the.getImage("img_ear09n");
		
		handtex = cast Loader.the.getImage("img_hand_chef_overlay");
		handnormals = cast Loader.the.getImage("img_hand_chefn");
		foottex = cast Loader.the.getImage("img_foot_chef_overlay");
		footnormals = cast Loader.the.getImage("img_foot_chefn");
	}
	
	private function drawObject(time: Float, texture: Texture, normals: Texture, x: Float, y: Float, w: Float, h: Float, mirror: Bool, z: Float) {
		/*if (z < 0) {
			z = -z;
			z /= 6;
			z += 1;
			w /= z;
			h /= z;
		}
		else {
			z /= 6;
			z += 1;
			w *= z;
			h *= z;
		}*/
		kha.Sys.graphics.setProgram(partsProgram);

		kha.Sys.graphics.setFloat(partsProgram.getConstantLocation("time"), time);
		kha.Sys.graphics.setFloat2(partsProgram.getConstantLocation("resolution"), 1024.0, 768.0);
		kha.Sys.graphics.setFloat3(partsProgram.getConstantLocation("lightPosition"), lightPosition.x, lightPosition.y, lightPosition.z);
		
		var vertices = partsVertexBuffer.lock();
		vertices[ 0] = x - w / 2.0; vertices[ 1] = y - h / 2.0; vertices[ 2] = z;
		vertices[ 5] = x - w / 2.0; vertices[ 6] = y + h / 2.0; vertices[ 7] = z;
		vertices[10] = x + w / 2.0; vertices[11] = y - h / 2.0; vertices[12] = z;
		vertices[15] = x + w / 2.0; vertices[16] = y + h / 2.0; vertices[17] = z;
		if (mirror) {
			vertices[ 3] = 1.0; vertices[ 4] = 1.0;
			vertices[ 8] = 1.0; vertices[ 9] = 0.0;
			vertices[13] = 0.0; vertices[14] = 1.0;
			vertices[18] = 0.0; vertices[19] = 0.0;
		}
		else {
			vertices[ 3] = 0.0; vertices[ 4] = 1.0;
			vertices[ 8] = 0.0; vertices[ 9] = 0.0;
			vertices[13] = 1.0; vertices[14] = 1.0;
			vertices[18] = 1.0; vertices[19] = 0.0;
		}
		partsVertexBuffer.unlock();
		kha.Sys.graphics.setVertexBuffer(partsVertexBuffer);
		
		kha.Sys.graphics.setTexture(partsProgram.getConstantLocation("sampler"), texture);
		kha.Sys.graphics.setTextureWrap(partsProgram.getConstantLocation("sampler"), TextureWrap.ClampToEdge, TextureWrap.ClampToEdge);
		
		kha.Sys.graphics.setTexture(partsProgram.getConstantLocation("normals"), normals);
		kha.Sys.graphics.setTextureWrap(partsProgram.getConstantLocation("normals"), TextureWrap.ClampToEdge, TextureWrap.ClampToEdge);

		indexBuffer.set();
		kha.Sys.graphics.drawIndexedVertices();
	}

	private function drawBody(time: Float, xoffset: Float): Void {
		kha.Sys.graphics.setProgram(bodyProgram);
		
		kha.Sys.graphics.setFloat(bodyProgram.getConstantLocation("time"), time);
		kha.Sys.graphics.setFloat(bodyProgram.getConstantLocation("angle"), angle);
		kha.Sys.graphics.setFloat2(bodyProgram.getConstantLocation("resolution"), 1024.0, 768.0);
		kha.Sys.graphics.setFloat3(bodyProgram.getConstantLocation("center"), position.x + xoffset + 0.05, position.y - 0.1, calcZ());
		kha.Sys.graphics.setFloat3(bodyProgram.getConstantLocation("lightPosition"), lightPosition.x, lightPosition.y, lightPosition.z);

		kha.Sys.graphics.setTexture(bodyProgram.getConstantLocation("sampler"), bodyTexture);
		kha.Sys.graphics.setTextureWrap(bodyProgram.getConstantLocation("sampler"), TextureWrap.Repeat, TextureWrap.Repeat);
		kha.Sys.graphics.setTexture(bodyProgram.getConstantLocation("normals"), bodyNormals);
		kha.Sys.graphics.setTextureWrap(bodyProgram.getConstantLocation("normals"), TextureWrap.Repeat, TextureWrap.Repeat);
		kha.Sys.graphics.setTexture(bodyProgram.getConstantLocation("facetex"), faceTexture);
		kha.Sys.graphics.setTextureWrap(bodyProgram.getConstantLocation("facetex"), TextureWrap.ClampToEdge, TextureWrap.ClampToEdge);
		
		kha.Sys.graphics.setVertexBuffer(bodyVertexBuffer);
		kha.Sys.graphics.setIndexBuffer(indexBuffer);
		kha.Sys.graphics.drawIndexedVertices();
	
		drawObject(time, earTexture, earNormals, 0.13 + position.x + xoffset, 0.09 + position.y, 0.15, 0.15, false, calcZ());
	}
	
	private function calcZ(): Float {
		return YolkfolkRestaurant2.calcZ(position.y -0.75 / 2.0 - 0.25 / 2.0);
	}
	
	private function adjustZ(z: Float): Float {
		return z /= -24;
	}
	
	private function adjustAngle(angle: Float): Float {
		while (angle < 0) angle += Math.PI * 2.0;
		return angle % (Math.PI * 2.0);
	}
	
	public function render(time: Float, xoffset: Float): Void {
		//var angle = Math.PI + time * Math.PI * 2.0 / 20.0;
		var angle = this.angle + Math.PI;
		angle += Math.sin(leftHandRot) * 0.5;
		angle = adjustAngle(angle);
		var z = Math.cos(angle);
		z = adjustZ(z);
		if (z >= 0) drawObject(time, handtex, handnormals, Math.sin(angle) * 0.15 + 0.05 + position.x + xoffset, -0.2 + position.y, 0.25, 0.25, (angle > Math.PI) ? true : false, z + calcZ());

		//angle = time * Math.PI * 2.0 / 20.0;
		angle = this.angle;
		angle += Math.sin(rightHandRot) * 0.5;
		angle = adjustAngle(angle);
		z = Math.cos(angle);
		z = adjustZ(z);
		if (z >= 0) drawObject(time, handtex, handnormals, Math.sin(angle) * 0.15 + 0.05 + position.x + xoffset, -0.2 + position.y, 0.25, 0.25, (angle > Math.PI) ? true : false, z + calcZ());

		//angle = Math.PI + time * Math.PI * 2.0 / 20.0;
		angle = this.angle + Math.PI;
		angle = adjustAngle(angle);
		z = Math.cos(angle);
		z = adjustZ(z);
		if (z >= 0) drawObject(time, foottex, footnormals, Math.sin(angle) * 0.1 + 0.05 + position.x + xoffset, -0.75 / 2.0 + position.y + leftFootHeight, 0.25, 0.25, (angle > Math.PI) ? true : false, z + calcZ());

		//angle = time * Math.PI * 2.0 / 20.0;
		angle = this.angle;
		angle = adjustAngle(angle);
		z = Math.cos(angle);
		z = adjustZ(z);
		if (z >= 0) drawObject(time, foottex, footnormals, Math.sin(angle) * 0.1 + 0.05 + position.x + xoffset, -0.75 / 2.0 + position.y + rightFootHeight, 0.25, 0.25, (angle > Math.PI) ? true : false, z + calcZ());

		drawBody(time, xoffset);

		//angle = Math.PI + time * Math.PI * 2.0 / 20.0;
		angle = this.angle + Math.PI;
		angle += Math.sin(leftHandRot) * 0.5;
		angle = adjustAngle(angle);
		z = Math.cos(angle);
		z = adjustZ(z);
		if (z < 0) drawObject(time, handtex, handnormals, Math.sin(angle) * 0.15 + 0.05 + position.x + xoffset, -0.2 + position.y, 0.25, 0.25, (angle > Math.PI) ? true : false, z + calcZ());

		//angle = time * Math.PI * 2.0 / 20.0;
		angle = this.angle;
		angle += Math.sin(rightHandRot) * 0.5;
		angle = adjustAngle(angle);
		z = Math.cos(angle);
		z = adjustZ(z);
		if (z < 0) drawObject(time, handtex, handnormals, Math.sin(angle) * 0.15 + 0.05 + position.x + xoffset, -0.2 + position.y, 0.25, 0.25, (angle > Math.PI) ? true : false, z + calcZ());

		//angle = Math.PI + time * Math.PI * 2.0 / 20.0;
		angle = this.angle + Math.PI;
		angle = adjustAngle(angle);
		z = Math.cos(angle);
		z = adjustZ(z);
		if (z < 0) drawObject(time, foottex, footnormals, Math.sin(angle) * 0.1 + 0.05 + position.x + xoffset, -0.75 / 2.0 + position.y + leftFootHeight, 0.25, 0.25, (angle > Math.PI) ? true : false, z + calcZ());

		//angle = time * Math.PI * 2.0 / 20.0;
		angle = this.angle;
		angle = adjustAngle(angle);
		z = Math.cos(angle);
		z = adjustZ(z);
		if (z < 0) drawObject(time, foottex, footnormals, Math.sin(angle) * 0.1 + 0.05 + position.x + xoffset, -0.75 / 2.0 + position.y + rightFootHeight, 0.25, 0.25, (angle > Math.PI) ? true : false, z + calcZ());
	}
}
