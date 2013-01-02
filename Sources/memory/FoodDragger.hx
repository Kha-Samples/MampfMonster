package memory;

import kha.Game;
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
	private var green: ClassPlate;
	private var yellow: ClassPlate;
	private var red: ClassPlate;
	private var greenStart: Vector2;
	private var yellowStart: Vector2;
	private var redStart: Vector2;
	private var greenAim: Vector2;
	private var yellowAim: Vector2;
	private var redAim: Vector2;
	
	public function new() {
		aim1 = new Vector2(450, 300);
		aim2 = new Vector2(550, 400);
		offset = new Vector2();
		green  = new ClassPlate(MampfColor.Green);
		yellow = new ClassPlate(MampfColor.Yellow);
		red    = new ClassPlate(MampfColor.Red);
		greenAim  = new Vector2(900, 300);
		yellowAim = new Vector2(850, 450);
		redAim    = new Vector2(900, 600);
		green.pos  = greenStart  = new Vector2(1200, greenAim.y);
		yellow.pos = yellowStart = new Vector2(1200, yellowAim.y);
		red.pos    = redStart    = new Vector2(1200, redAim.y);
	}
	
	public function setCards(first: Card, second: Card): Void {
		this.first = first;
		this.second = second;
		switch (first.food.color) {
			case MampfColor.Green:
				green.setCorrect(true);
				yellow.setCorrect(false);
				red.setCorrect(false);
			case MampfColor.Yellow:
				green.setCorrect(false);
				yellow.setCorrect(true);
				red.setCorrect(false);
			case MampfColor.Red:
				green.setCorrect(false);
				yellow.setCorrect(false);
				red.setCorrect(true);
		}
		start1 = new Vector2(first.x, first.y);
		start2 = new Vector2(second.x, second.y);
		time = 0;
		closing = false;
		lastClass = null;
		offset.x = 0;
		offset.y = 0;
		green.hide();
		yellow.hide();
		red.hide();
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
		
		if (closing) {
			var closeTween = catmullrom(time, 1, 0, 1, -1);
			var classTween = catmullrom(time, 10, 0, 1, -1);
			
			green.pos  = greenAim.add(greenStart.sub(greenAim).mult(classTween));
			yellow.pos = yellowAim.add(yellowStart.sub(yellowAim).mult(classTween));
			red.pos    = redAim.add(redStart.sub(redAim).mult(classTween));
			
			var closePos1 = firstCloseStart.add(lastClass.pos.sub(firstCloseStart).mult(closeTween));
			var closePos2 = secondCloseStart.add(lastClass.pos.sub(secondCloseStart).mult(closeTween));
			first.x = closePos1.x;
			first.y = closePos1.y;
			second.x = closePos2.x;
			second.y = closePos2.y;
			first.zoom = 2 - time * 2;
			second.zoom = 2 - time * 2;
			time += 0.02;
			if (time >= 1) {
				time = 1;
				cast(Game.the, Memory).nextRound();
			}
			return;
		}
		
		var tween = catmullrom(time, 5, 0, 1, -5);
		var pos1 = start1.add(aim1.sub(start1).mult(tween));
		var pos2 = start2.add(aim2.sub(start2).mult(tween));
		first.x = pos1.x + offset.x;
		first.y = pos1.y + offset.y;
		second.x = pos2.x + offset.x;
		second.y = pos2.y + offset.y;
		first.zoom = 1 + time;
		second.zoom = 1 + time;
		
		var tween2 = catmullrom(time, 10, 0, 1, -1);
		green.pos  = greenStart.add(greenAim.sub(greenStart).mult(tween2));
		yellow.pos = yellowStart.add(yellowAim.sub(yellowStart).mult(tween2));
		red.pos    = redStart.add(redAim.sub(redStart).mult(tween2));
		
		first.update();
		second.update();
		green.update();
		yellow.update();
		red.update();
		
		time += 0.02;
		if (time >= 1) time = 1;
	}
	
	public function render(painter: Painter): Void {
		if (first == null) return;
		
		red.render(painter);
		yellow.render(painter);
		green.render(painter);
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
	
	private var lastClass: ClassPlate = null;
	private var closing = false;
	private var firstCloseStart: Vector2;
	private var secondCloseStart: Vector2;
	
	public function mouseUp(x: Int, y: Int): Void {
		moving = false;
		if (lastClass != null) {
			closing = true;
			firstCloseStart = new Vector2(first.x, first.y);
			secondCloseStart = new Vector2(second.x, second.y);
			time = 0;
		}
	}
	
	public function mouseMove(x: Int, y: Int): Void {
		if (moving) {
			offset.x = x - mx;
			offset.y = y - my;
			if (offset.x > 100 && offset.y > -250) {
				var center = new Vector2(offset.x + 1024 / 2, offset.y + 768 / 2);
				var greenLength = center.sub(green.pos).length;
				var yellowLength = center.sub(yellow.pos).length;
				var redLength = center.sub(red.pos).length;
				if (greenLength < yellowLength && greenLength < redLength) {
					green.show();
					yellow.hide();
					red.hide();
					lastClass = green;
				}
				else if (yellowLength < redLength) {
					green.hide();
					yellow.show();
					red.hide();
					lastClass = yellow;
				}
				else {
					green.hide();
					yellow.hide();
					red.show();
					lastClass = red;
				}
			}
			else {
				green.hide();
				yellow.hide();
				red.hide();
				lastClass = null;
			}
		}
	}
}