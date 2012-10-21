package;

import kha.*;

class Foot extends Sprite {
	public function new() {
		super(Loader.the.getImage("foot.png"), 7 * 3, 5 * 3, 1);
		accy = 0;
		position = new Vector3(50, 50, 0);
		lastPosition = new Vector2(position.x, position.y);
		aim = new Vector2(lastPosition.x, lastPosition.y);
		speed = new Vector3();
	}
	
	public function setAim(x: Float, y: Float): Void {
		aim.x = x;
		aim.y = y;
		if ((position.x != x || position.y != y) && position.z == 0 && speed.z == 0) {
			speed.z = 1.8;
		}
		/*if (position.z == 0 && speed.z == 0) {
			lastPosition.x = position.x;
			lastPosition.y = position.y;
			speed.z = 1.8;
			var direction = new Vector2(x - position.x, y - position.y);
			direction.length = 2;
			speed.x = direction.x;
			speed.y = direction.y;
		}*/
	}
	
	override public function update(): Void {
		if (position.x < aim.x) speed.x = absoluteSpeed;
		else if (position.x > aim.x) speed.x = -absoluteSpeed;
		else speed.x = 0;
		
		if (position.y < aim.y) speed.y = absoluteSpeed;
		else if (position.y > aim.y) speed.y = -absoluteSpeed;
		else speed.y = 0;
		
		speed.z -= 0.1;
		position.x += speed.x;
		position.y += speed.y;
		position.z += speed.z;
		
		if (position.z < 0) {
			position.z = 0;
			speed.z = 0;
		}
		
		if (speed.x > 0) {
			if (position.x >= aim.x) {
				position.x = aim.x;
				speed.x = 0;
			}
		}
		else if (speed.x < 0) {
			if (position.x <= aim.x) {
				position.x = aim.x;
				speed.x = 0;
			}
		}
		
		if (speed.y > 0) {
			if (position.y >= aim.y) {
				position.y = aim.y;
				speed.y = 0;
			}
		}
		else if (speed.y < 0) {
			if (position.y <= aim.y) {
				position.y = aim.y;
				speed.y = 0;
			}
		}
		
		x = position.x;
		y = position.y - position.z;
	}
	
	private static var absoluteSpeed = 2;
	private var lastPosition: Vector2;
	private var aim: Vector2;
	private var position: Vector3;
	private var speed: Vector3;
}