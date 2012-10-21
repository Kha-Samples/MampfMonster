package;

import kha.Loader;
import kha.Sprite;

class Chair2 extends Sprite {
	public function new() {
		super(Loader.the.getImage("chair2.png"), 22 * 3, 23 * 3, 5);
		accy = 0;
	}
}