package;

import kha.Starter;

class Main {
	public static function main() {
		kha.Sys.needs3d = true;
		var starter = new Starter();
		starter.start(new YolkfolkRestaurant2());
		//starter.start(new YolkfolkRestaurant());
		//starter.start(new memory.Memory());
	}
}
