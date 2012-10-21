package;

import kha.Loader;
import kha.Sprite;
import kha.Vector3;

class Hand extends Sprite {
	public function new(yolk: Cook, left: Bool) {
		super(Loader.the.getImage("hand.png"), 5 * 3, 6 * 3, 1);
		accy = 0;
		this.yolk = yolk;
		this.left = left;
		position = new Vector3();
	}
	
	override public function update(): Void {
		++count;
		
		switch (yolk.direction) {
		case UP:
			if (left) {
				position.x = yolk.x - 10;
				position.y = yolk.y + 20 + swing();
				z = 0;
			}
			else {
				position.x = yolk.x + 40;
				position.y = yolk.y + 20 - swing();
				z = 0;
			}
		case DOWN:
			if (left) {
				position.x = yolk.x + 40;
				position.y = yolk.y + 20 - swing();
				z = 2;
			}
			else {
				position.x = yolk.x - 10;
				position.y = yolk.y + 20 + swing();
				z = 2;
			}
		case LEFT:
			if (left) {
				position.x = yolk.x + 20 - swing();
				position.y = yolk.y + 20;
				z = 2;
			}
			else {
				position.x = yolk.x + 10 + swing();
				position.y = yolk.y + 24;
				z = 0;
			}
		case RIGHT:
			if (left) {
				position.x = yolk.x + 10 + swing();
				position.y = yolk.y + 24;
				z = 0;
			}
			else {
				position.x = yolk.x + 10 - swing();
				position.y = yolk.y + 20;
				z = 2;
			}
		}
		
		x = position.x;
		y = position.y - position.z;
	}
	
	private function swing(): Float {
		var value = 5 * Math.sin((left ? count : (count + 5)) / 10);
		var nextValue = 5 * Math.sin((left ? (count + 1) : (count + 6)) / 10);

		if (!moving && yolk.walking) {
			if (value <= 0 && nextValue >= 0) moving = true;
			if (value >= 0 && nextValue <= 0) moving = true;
		}
		else if (moving && !yolk.walking) {
			if (value <= 0 && nextValue >= 0) moving = false;
			if (value >= 0 && nextValue <= 0) moving = false;
		}
		
		if (moving) return value;
		else return 0;
	}
	
	private var moving: Bool = false;
	private var position: Vector3;
	private var yolk: Cook;
	private var count: Int = 0;
	private var left: Bool;
}