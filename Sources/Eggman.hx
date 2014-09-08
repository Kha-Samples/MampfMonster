package;

import kha.graphics4.Graphics;
import kha.graphics4.IndexBuffer;
import kha.graphics4.MipMapFilter;
import kha.graphics4.Program;
import kha.graphics4.TextureAddressing;
import kha.graphics4.TextureFilter;
import kha.graphics4.Usage;
import kha.Image;
import kha.Loader;
import kha.graphics4.FragmentShader;
import kha.graphics4.VertexData;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexStructure;
import kha.math.Vector3;

class Eggman {
	private var indexBuffer: IndexBuffer;
	private var bodyVertexShader: VertexShader;
	private var bodyFragmentShader: FragmentShader;
	private var bodyVertexBuffer: VertexBuffer;
	private var bodyProgram: Program;
	private var bodyTexture: Image;
	private var bodyNormals: Image;
	private var faceTexture: Image;
	
	private var partsVertexShader: VertexShader;
	private var partsFragmentShader: FragmentShader;
	private var partsVertexBuffer: VertexBuffer;
	private var partsProgram: Program;
	private var earTexture: Image;
	private var earNormals: Image;
	private var handtex: Image;
	private var handnormals: Image;
	private var foottex: Image;
	private var footnormals: Image;
	
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
		structure.add("position", VertexData.Float3);
		bodyVertexBuffer = new VertexBuffer(4, structure, Usage.StaticUsage);
		var vertices = bodyVertexBuffer.lock();
		vertices[0] = -1.0; vertices[ 1] = -1.0; vertices[ 2] = 0.0;
		vertices[3] = -1.0; vertices[ 4] =  1.0; vertices[ 5] = 0.0;
		vertices[6] =  1.0; vertices[ 7] = -1.0; vertices[ 8] = 0.0;
		vertices[9] =  1.0; vertices[10] =  1.0; vertices[11] = 0.0;
		bodyVertexBuffer.unlock();
		
		bodyTexture = cast Loader.the.getImage("img_fur2");
		bodyNormals = cast Loader.the.getImage("img_fur2n");
		faceTexture = cast Loader.the.getImage("img_face_a1");
		
		bodyVertexShader = new VertexShader(Loader.the.getShader("eggman_body.vert"));
		bodyFragmentShader = new FragmentShader(Loader.the.getShader("eggman_body.frag"));
		bodyProgram = new Program();
		bodyProgram.setVertexShader(bodyVertexShader);
		bodyProgram.setFragmentShader(bodyFragmentShader);
		bodyProgram.link(structure);
		
		partsVertexShader = new VertexShader(Loader.the.getShader("eggman_parts.vert"));
		partsFragmentShader = new FragmentShader(Loader.the.getShader("eggman_parts.frag"));
		partsProgram = new Program();
		structure = new VertexStructure();
		structure.add("pos", VertexData.Float3);
		structure.add("tex", VertexData.Float2);
		partsProgram.setVertexShader(partsVertexShader);
		partsProgram.setFragmentShader(partsFragmentShader);
		partsProgram.link(structure);
		partsVertexBuffer = new VertexBuffer(4, structure, Usage.StaticUsage);
		earTexture = cast Loader.the.getImage("img_ear09_overlay");
		earNormals = cast Loader.the.getImage("img_ear09n");
		
		handtex = cast Loader.the.getImage("img_hand_chef_overlay");
		handnormals = cast Loader.the.getImage("img_hand_chefn");
		foottex = cast Loader.the.getImage("img_foot_chef_overlay");
		footnormals = cast Loader.the.getImage("img_foot_chefn");
	}
	
	private function drawObject(g: Graphics, time: Float, texture: Image, normals: Image, x: Float, y: Float, w: Float, h: Float, mirror: Bool, z: Float) {
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
		g.setProgram(partsProgram);

		g.setFloat(partsProgram.getConstantLocation("time"), time);
		g.setFloat2(partsProgram.getConstantLocation("resolution"), 1024.0, 768.0);
		g.setFloat3(partsProgram.getConstantLocation("lightPosition"), lightPosition.x, lightPosition.y, lightPosition.z);
		
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
		g.setVertexBuffer(partsVertexBuffer);
		
		g.setTexture(partsProgram.getTextureUnit("sampler"), texture);
		g.setTextureParameters(partsProgram.getTextureUnit("sampler"), TextureAddressing.Clamp, TextureAddressing.Clamp, TextureFilter.LinearFilter, TextureFilter.LinearFilter, MipMapFilter.NoMipFilter);
		
		g.setTexture(partsProgram.getTextureUnit("normals"), normals);
		g.setTextureParameters(partsProgram.getTextureUnit("normals"), TextureAddressing.Clamp, TextureAddressing.Clamp, TextureFilter.LinearFilter, TextureFilter.LinearFilter, MipMapFilter.NoMipFilter);
		
		indexBuffer.set();
		g.drawIndexedVertices();
	}

	private function drawBody(g: Graphics, time: Float, xoffset: Float): Void {
		g.setProgram(bodyProgram);
		
		g.setFloat(bodyProgram.getConstantLocation("time"), time);
		g.setFloat(bodyProgram.getConstantLocation("angle"), angle);
		g.setFloat2(bodyProgram.getConstantLocation("resolution"), 1024.0, 768.0);
		g.setFloat3(bodyProgram.getConstantLocation("center"), position.x + xoffset + 0.05, position.y - 0.1, calcZ());
		g.setFloat3(bodyProgram.getConstantLocation("lightPosition"), lightPosition.x, lightPosition.y, lightPosition.z);

		g.setTexture(bodyProgram.getTextureUnit("sampler"), bodyTexture);
		g.setTextureParameters(partsProgram.getTextureUnit("sampler"), TextureAddressing.Repeat, TextureAddressing.Repeat, TextureFilter.LinearFilter, TextureFilter.LinearFilter, MipMapFilter.NoMipFilter);
		g.setTexture(bodyProgram.getTextureUnit("normals"), bodyNormals);
		g.setTextureParameters(partsProgram.getTextureUnit("normals"), TextureAddressing.Repeat, TextureAddressing.Repeat, TextureFilter.LinearFilter, TextureFilter.LinearFilter, MipMapFilter.NoMipFilter);
		g.setTexture(bodyProgram.getTextureUnit("facetex"), faceTexture);
		g.setTextureParameters(partsProgram.getTextureUnit("facetex"), TextureAddressing.Repeat, TextureAddressing.Repeat, TextureFilter.LinearFilter, TextureFilter.LinearFilter, MipMapFilter.NoMipFilter);
		
		g.setVertexBuffer(bodyVertexBuffer);
		g.setIndexBuffer(indexBuffer);
		g.drawIndexedVertices();
	
		drawObject(g, time, earTexture, earNormals, 0.13 + position.x + xoffset, 0.09 + position.y, 0.15, 0.15, false, calcZ());
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
	
	public function render(g: Graphics, time: Float, xoffset: Float): Void {
		//var angle = Math.PI + time * Math.PI * 2.0 / 20.0;
		var angle = this.angle + Math.PI;
		angle += Math.sin(leftHandRot) * 0.5;
		angle = adjustAngle(angle);
		var z = Math.cos(angle);
		z = adjustZ(z);
		if (z >= 0) drawObject(g, time, handtex, handnormals, Math.sin(angle) * 0.15 + 0.05 + position.x + xoffset, -0.2 + position.y, 0.25, 0.25, (angle > Math.PI) ? true : false, z + calcZ());

		//angle = time * Math.PI * 2.0 / 20.0;
		angle = this.angle;
		angle += Math.sin(rightHandRot) * 0.5;
		angle = adjustAngle(angle);
		z = Math.cos(angle);
		z = adjustZ(z);
		if (z >= 0) drawObject(g, time, handtex, handnormals, Math.sin(angle) * 0.15 + 0.05 + position.x + xoffset, -0.2 + position.y, 0.25, 0.25, (angle > Math.PI) ? true : false, z + calcZ());

		//angle = Math.PI + time * Math.PI * 2.0 / 20.0;
		angle = this.angle + Math.PI;
		angle = adjustAngle(angle);
		z = Math.cos(angle);
		z = adjustZ(z);
		if (z >= 0) drawObject(g, time, foottex, footnormals, Math.sin(angle) * 0.1 + 0.05 + position.x + xoffset, -0.75 / 2.0 + position.y + leftFootHeight, 0.25, 0.25, (angle > Math.PI) ? true : false, z + calcZ());

		//angle = time * Math.PI * 2.0 / 20.0;
		angle = this.angle;
		angle = adjustAngle(angle);
		z = Math.cos(angle);
		z = adjustZ(z);
		if (z >= 0) drawObject(g, time, foottex, footnormals, Math.sin(angle) * 0.1 + 0.05 + position.x + xoffset, -0.75 / 2.0 + position.y + rightFootHeight, 0.25, 0.25, (angle > Math.PI) ? true : false, z + calcZ());

		drawBody(g, time, xoffset);

		//angle = Math.PI + time * Math.PI * 2.0 / 20.0;
		angle = this.angle + Math.PI;
		angle += Math.sin(leftHandRot) * 0.5;
		angle = adjustAngle(angle);
		z = Math.cos(angle);
		z = adjustZ(z);
		if (z < 0) drawObject(g, time, handtex, handnormals, Math.sin(angle) * 0.15 + 0.05 + position.x + xoffset, -0.2 + position.y, 0.25, 0.25, (angle > Math.PI) ? true : false, z + calcZ());

		//angle = time * Math.PI * 2.0 / 20.0;
		angle = this.angle;
		angle += Math.sin(rightHandRot) * 0.5;
		angle = adjustAngle(angle);
		z = Math.cos(angle);
		z = adjustZ(z);
		if (z < 0) drawObject(g, time, handtex, handnormals, Math.sin(angle) * 0.15 + 0.05 + position.x + xoffset, -0.2 + position.y, 0.25, 0.25, (angle > Math.PI) ? true : false, z + calcZ());

		//angle = Math.PI + time * Math.PI * 2.0 / 20.0;
		angle = this.angle + Math.PI;
		angle = adjustAngle(angle);
		z = Math.cos(angle);
		z = adjustZ(z);
		if (z < 0) drawObject(g, time, foottex, footnormals, Math.sin(angle) * 0.1 + 0.05 + position.x + xoffset, -0.75 / 2.0 + position.y + leftFootHeight, 0.25, 0.25, (angle > Math.PI) ? true : false, z + calcZ());

		//angle = time * Math.PI * 2.0 / 20.0;
		angle = this.angle;
		angle = adjustAngle(angle);
		z = Math.cos(angle);
		z = adjustZ(z);
		if (z < 0) drawObject(g, time, foottex, footnormals, Math.sin(angle) * 0.1 + 0.05 + position.x + xoffset, -0.75 / 2.0 + position.y + rightFootHeight, 0.25, 0.25, (angle > Math.PI) ? true : false, z + calcZ());
	}
}
