package memory;

import kha.Painter;
import kha.Vector2;

class FoodDragger {
	private var first: Card;
	private var second: Card;
	private var aim1: Vector2;
	private var aim2: Vector2;
	private var start1: Vector2;
	private var start2: Vector2;
	private var time: Float;
	public var offset: Vector2;
	
	public function new() {
		aim1 = new Vector2(450, 300);
		aim2 = new Vector2(550, 400);
		offset = new Vector2();
	}
	
	public function setCards(first: Card, second: Card): Void {
		this.first = first;
		this.second = second;
		start1 = new Vector2(first.x, first.y);
		start2 = new Vector2(second.x, second.y);
		time = 0;
	}
	
	private static function catmullrom(t: Float, p0: Float, p1: Float, p2: Float, p3: Float): Float {
		return 0.5 * (
              (2 * p1) +
              (-p0 + p2) * t +
              (2 * p0 - 5 * p1 + 4 * p2 - p3) * t * t +
              (-p0 + 3 * p1 - 3 * p2 + p3) * t * t * t
              );
	}
	
	public function update(): Void {
		if (first == null) return;
		time += 0.02;
		if (time >= 1) time = 1;
		var tween = catmullrom(time, 5, 0, 1, -5);
		var pos1 = start1.add(aim1.sub(start1).mult(tween));
		var pos2 = start2.add(aim2.sub(start2).mult(tween));
		first.x = pos1.x + offset.x;
		first.y = pos1.y + offset.y;
		second.x = pos2.x + offset.x;
		second.y = pos2.y + offset.y;
		first.zoom = 1 + time;
		second.zoom = 1 + time;
		first.update();
		second.update();
	}
	
	public function render(painter: Painter): Void {
		if (first == null) return;
		first.render(painter);
		second.render(painter);
	}
	
	private var mx: Float;
	private var my: Float;
	private var moving = false;
	
	public function mouseDown(x: Int, y: Int): Void {
		var halfSize = 225;
		if (x > offset.x + 1024 / 2 - halfSize && x < offset.x + 1024 / 2 + halfSize && y > offset.y + 768 / 2 - halfSize && y < offset.y + 768 / 2 + halfSize) {
			moving = true;
			mx = x - offset.x;
			my = y - offset.y;
		}
	}
	
	public function mouseUp(x: Int, y: Int): Void {
		moving = false;
	}
	
	public function mouseMove(x: Int, y: Int): Void {
		if (moving) {
			offset.x = x - mx;
			offset.y = y - my;
		}
	}
}