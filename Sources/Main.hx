package;

import kha.Starter;

class Main {
	public static function main() {
		kha.Sys.needs3d = true;
		new Starter().start(new YolkfolkRestaurant2());
		//new Starter().start(new YolkfolkRestaurant());
		//new Starter().start(new memory.Memory());
	}
}