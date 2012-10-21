package;

import kha.Loader;
import kha.Sprite;

class Chair1 extends Sprite {
	public function new(): Void {
		super(Loader.the.getImage("chair1.png"), 22 * 3, 36 * 3, 0);
		accy = 0;
	}	
}