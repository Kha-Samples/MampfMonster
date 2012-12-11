package;

import kha.Loader;
import kha.graphics.FragmentShader;
import kha.graphics.Texture;
import kha.graphics.VertexData;
import kha.graphics.VertexShader;
import kha.graphics.VertexBuffer;
import kha.graphics.VertexStructure;
import kha.Vector3;

class Eggman {
	private var bodyVertexShader: VertexShader;
	private var bodyFragmentShader: FragmentShader;
	private var bodyVertexBuffer: VertexBuffer;
	private var bodyTexture: Texture;
	private var bodyNormals: Texture;
	private var faceTexture: Texture;
	
	private var partsVertexShader: VertexShader;
	private var partsFragmentShader: FragmentShader;
	private var partsVertexBuffer: VertexBuffer;
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
	
	private static var jump: Float = 0.025;
	
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
			leftHandRot += 0.05;
			rightHandRot += 0.05;
		}
		else {
			if (leftHandRot > 0) {
				leftHandRot = leftHandRot % Math.PI;
				rightHandRot = rightHandRot % Math.PI;
				leftHandRot += 0.05;
				rightHandRot += 0.05;
				if (leftHandRot > Math.PI) {
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
			speed.length = 0.005;
			position = position.add(speed);
		}
	}
	
	public function new() {
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
		
		partsVertexShader = kha.Sys.graphics.createVertexShader(Loader.the.getBlob("eggman_parts.vs.glsl").toString());
		partsFragmentShader = kha.Sys.graphics.createFragmentShader(Loader.the.getBlob("eggman_parts.fs.glsl").toString());
		structure = new VertexStructure();
		structure.add("pos", VertexData.Float3);
		structure.add("tex", VertexData.Float2);
		partsVertexBuffer = kha.Sys.graphics.createVertexBuffer(4, structure);
		earTexture = kha.Sys.graphics.createTexture(Loader.the.getImage("img_ear09_overlay"));
		earNormals = kha.Sys.graphics.createTexture(Loader.the.getImage("img_ear09n"));
		
		handtex = kha.Sys.graphics.createTexture(Loader.the.getImage("img_hand_chef_overlay"));
		handnormals = kha.Sys.graphics.createTexture(Loader.the.getImage("img_hand_chefn"));
		foottex = kha.Sys.graphics.createTexture(Loader.the.getImage("img_foot_chef_overlay"));
		footnormals = kha.Sys.graphics.createTexture(Loader.the.getImage("img_foot_chefn"));
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
		kha.Sys.graphics.setVertexShader(partsVertexShader);
		kha.Sys.graphics.setFragmentShader(partsFragmentShader);
		kha.Sys.graphics.linkShaders();

		partsFragmentShader.setFloat("time", time);
		partsFragmentShader.setFloat2("resolution", 1024.0, 768.0);
		partsFragmentShader.setFloat3("lightPosition", lightPosition.x, lightPosition.y, lightPosition.z);
		
		var vertices = partsVertexBuffer.lock();
		vertices[ 0] = x - w / 2.0; vertices[ 1] = y - h / 2.0; vertices[ 2] = z;
		vertices[ 5] = x - w / 2.0; vertices[ 6] = y + h / 2.0; vertices[ 7] = z;
		vertices[10] = x + w / 2.0; vertices[11] = y - h / 2.0; vertices[12] = z;
		vertices[15] = x + w / 2.0; vertices[16] = y + h / 2.0; vertices[17] = z;
		if (mirror) {
			vertices[ 3] = 1.0; vertices[ 4] = 0.0;
			vertices[ 8] = 1.0; vertices[ 9] = 1.0;
			vertices[13] = 0.0; vertices[14] = 0.0;
			vertices[18] = 0.0; vertices[19] = 1.0;
		}
		else {
			vertices[ 3] = 0.0; vertices[ 4] = 0.0;
			vertices[ 8] = 0.0; vertices[ 9] = 1.0;
			vertices[13] = 1.0; vertices[14] = 0.0;
			vertices[18] = 1.0; vertices[19] = 1.0;
		}
		partsVertexBuffer.unlock();
		kha.Sys.graphics.setVertexBuffer(partsVertexBuffer);
		
		texture.set(0);
		partsFragmentShader.setInt("sampler", 0);
		
		normals.set(1);
		partsFragmentShader.setInt("normals", 1);

		kha.Sys.graphics.drawArrays();
	}

	private function drawBody(time: Float, xoffset: Float): Void {
		kha.Sys.graphics.setVertexShader(bodyVertexShader);
		kha.Sys.graphics.setFragmentShader(bodyFragmentShader);
		kha.Sys.graphics.linkShaders();
		
		bodyFragmentShader.setFloat("time", time);
		bodyFragmentShader.setFloat("angle", angle);
		bodyFragmentShader.setFloat2("resolution", 1024.0, 768.0);
		bodyFragmentShader.setFloat3("center", position.x + xoffset + 0.1, position.y - 0.2, calcZ());
		bodyFragmentShader.setFloat3("lightPosition", lightPosition.x, lightPosition.y, lightPosition.z);

		bodyTexture.set(0);
		bodyFragmentShader.setInt("sampler", 0);
		bodyNormals.set(1);
		bodyFragmentShader.setInt("normals", 1);
		faceTexture.set(2);
		bodyFragmentShader.setInt("facetex", 2);
		
		kha.Sys.graphics.setVertexBuffer(bodyVertexBuffer);
		kha.Sys.graphics.drawArrays();
	
		drawObject(time, earTexture, earNormals, 0.26 + position.x + xoffset, 0.18 + position.y, 0.3, 0.3, false, calcZ());
	}
	
	private function calcZ(): Float {
		return YolkfolkRestaurant2.calcZ(position.y - 0.2);
	}
	
	private function adjustZ(z: Float): Float {
		return z /= -12;
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
		if (z >= 0) drawObject(time, handtex, handnormals, Math.sin(angle) * 0.3 + 0.1 + position.x + xoffset, -0.4 + position.y, 0.5, 0.5, (angle > Math.PI) ? true : false, z + calcZ());

		//angle = time * Math.PI * 2.0 / 20.0;
		angle = this.angle;
		angle += Math.sin(rightHandRot) * 0.5;
		angle = adjustAngle(angle);
		z = Math.cos(angle);
		z = adjustZ(z);
		if (z >= 0) drawObject(time, handtex, handnormals, Math.sin(angle) * 0.3 + 0.1 + position.x + xoffset, -0.4 + position.y, 0.5, 0.5, (angle > Math.PI) ? true : false, z + calcZ());

		//angle = Math.PI + time * Math.PI * 2.0 / 20.0;
		angle = this.angle + Math.PI;
		angle = adjustAngle(angle);
		z = Math.cos(angle);
		z = adjustZ(z);
		if (z >= 0) drawObject(time, foottex, footnormals, Math.sin(angle) * 0.2 + 0.1 + position.x + xoffset, -0.75 + position.y + leftFootHeight, 0.5, 0.5, (angle > Math.PI) ? true : false, z + calcZ());

		//angle = time * Math.PI * 2.0 / 20.0;
		angle = this.angle;
		angle = adjustAngle(angle);
		z = Math.cos(angle);
		z = adjustZ(z);
		if (z >= 0) drawObject(time, foottex, footnormals, Math.sin(angle) * 0.2 + 0.1 + position.x + xoffset, -0.75 + position.y + rightFootHeight, 0.5, 0.5, (angle > Math.PI) ? true : false, z + calcZ());

		drawBody(time, xoffset);

		//angle = Math.PI + time * Math.PI * 2.0 / 20.0;
		angle = this.angle + Math.PI;
		angle += Math.sin(leftHandRot) * 0.5;
		angle = adjustAngle(angle);
		z = Math.cos(angle);
		z = adjustZ(z);
		if (z < 0) drawObject(time, handtex, handnormals, Math.sin(angle) * 0.3 + 0.1 + position.x + xoffset, -0.4 + position.y, 0.5, 0.5, (angle > Math.PI) ? true : false, z + calcZ());

		//angle = time * Math.PI * 2.0 / 20.0;
		angle = this.angle;
		angle += Math.sin(rightHandRot) * 0.5;
		angle = adjustAngle(angle);
		z = Math.cos(angle);
		z = adjustZ(z);
		if (z < 0) drawObject(time, handtex, handnormals, Math.sin(angle) * 0.3 + 0.1 + position.x + xoffset, -0.4 + position.y, 0.5, 0.5, (angle > Math.PI) ? true : false, z + calcZ());

		//angle = Math.PI + time * Math.PI * 2.0 / 20.0;
		angle = this.angle + Math.PI;
		angle = adjustAngle(angle);
		z = Math.cos(angle);
		z = adjustZ(z);
		if (z < 0) drawObject(time, foottex, footnormals, Math.sin(angle) * 0.2 + 0.1 + position.x + xoffset, -0.75 + position.y + leftFootHeight, 0.5, 0.5, (angle > Math.PI) ? true : false, z + calcZ());

		//angle = time * Math.PI * 2.0 / 20.0;
		angle = this.angle;
		angle = adjustAngle(angle);
		z = Math.cos(angle);
		z = adjustZ(z);
		if (z < 0) drawObject(time, foottex, footnormals, Math.sin(angle) * 0.2 + 0.1 + position.x + xoffset, -0.75 + position.y + rightFootHeight, 0.5, 0.5, (angle > Math.PI) ? true : false, z + calcZ());
	}
}