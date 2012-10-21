package;

import kha.*;

class Hand extends Sprite {
	public function new() {
		super(Loader.the.getImage("hand.png"), 5 * 3, 6 * 3, 2);
		accy = 0;
		position = new Vector3();
	}
	
	private var position: Vector3;
}