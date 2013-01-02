package memory;

import kha.Image;
import kha.Loader;
import kha.Painter;

class Card {
	public var x: Float;
	public var y: Float;
	public static var width = 150;
	public static var height = 150;
	public var zoom: Float = 1;
	public var food: Food;
	
	private var back: Image;
	private var rotation: Float = 0;
	private var rotations: Int = 0;
	
	public function new(x: Float, y: Float, food: Food) {
		this.x = x;
		this.y = y;
		this.food = food;
		back = Loader.the.getImage("memory/card_back");
	}
	
	public function update(): Void {
		if (rotations > 0) {
			var firstSector = false;
			if (rotation < Math.PI) firstSector = true;
			rotation += 0.1;
			if (rotation >= Math.PI * 2 || (firstSector && rotation >= Math.PI)) --rotations;
			rotation = rotation % (Math.PI * 2);
		}
	}
	
	public function render(painter: Painter): Void {
		var image: Image = null;
		if (rotation > Math.PI * 0.5 && rotation <= Math.PI * 1.5) image = food.image;
		else image = back;
		var width = Math.abs(Math.cos(rotation)) * Card.width;
		painter.drawImage2(image, 0, 0, back.getWidth(), back.getHeight(), x - width * zoom / 2, y - height * zoom / 2, width * zoom, height * zoom);
	}
	
	public function click(): Void {
		++rotations;
	}
}