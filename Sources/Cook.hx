package;

import kha.Loader;
import kha.Sprite;

class Cook extends Sprite {
	public function new() {
		super(Loader.the.getImage("yolk.png"), 15 * 3, 17 * 3, 0);
		accy = 0;
	}
}