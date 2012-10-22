package;

import kha.Loader;
import kha.Sprite;

class Hat extends Sprite {
	public function new(): Void {
		super(Loader.the.getImage("hat.png"), 18 * 3, 14 * 3, 2);
		accy = 0;
	}
	
}