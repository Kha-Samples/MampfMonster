package;

import kha.Loader;
import kha.Sprite;

class Table extends Sprite {
	public function new(): Void {
		super(Loader.the.getImage("table.png"), 58 * 3, 48 * 3, 4);
		accy = 0;
	}
}