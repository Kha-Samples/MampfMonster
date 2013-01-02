package memory;

import kha.Image;
import kha.Loader;
import kha.Painter;
import kha.Vector2;

class ClassPlate {
	private static var width = 200;
	private static var height = 200;
	private static var green: Image;
	private static var yellow: Image;
	private static var red: Image;
	private static var neutral: Image;
	private static var right: Image;
	private static var wrong: Image;
	
	private var color: MampfColor;
	private var shown = false;
	private var correct = false;
	public var pos: Vector2;
	
	public static function init(): Void {
		green   = Loader.the.getImage("memory/class_green");
		yellow  = Loader.the.getImage("memory/class_yellow");
		red     = Loader.the.getImage("memory/class_red");
		neutral = Loader.the.getImage("memory/class_neutral");
		right   = Loader.the.getImage("memory/class_right");
		wrong   = Loader.the.getImage("memory/class_wrong");
	}
	
	public function new(color: MampfColor) {
		this.color = color;
		pos = new Vector2();
	}
	
	public function setCorrect(correct: Bool) {
		this.correct = correct;
	}
	
	public function update(): Void {
		
	}
	
	public function render(painter: Painter): Void {
		var image: Image = null;
		switch (color) {
			case MampfColor.Green:
				image = green;
			case MampfColor.Yellow:
				image = yellow;
			case MampfColor.Red:
				image = red;
		}
		painter.drawImage2(image, 0, 0, image.getWidth(), image.getHeight(), pos.x - width / 2, pos.y - height / 2, width, height);
		if (shown) {
			if (correct) painter.drawImage2(right, 0, 0, right.getWidth(), right.getHeight(), pos.x - width / 2, pos.y - height / 2, width, height);
			else painter.drawImage2(wrong, 0, 0, wrong.getWidth(), wrong.getHeight(), pos.x - width / 2, pos.y - height / 2, width, height);
		}
		else painter.drawImage2(neutral, 0, 0, neutral.getWidth(), neutral.getHeight(), pos.x - width / 2, pos.y - height / 2, width, height);
	}
	
	public function show(): Void {
		shown = true;
	}
	
	public function hide(): Void {
		shown = false;
	}
}