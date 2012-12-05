package;

import kha.Configuration;
import kha.Game;
import kha.Loader;
import kha.LoadingScreen;
import kha.Painter;

class YolkfolkRestaurant2 extends Game {
	public function new() {
		super("Yolkfolk Restaurant", false);
	}
	
	override public function init(): Void {
		Configuration.setScreen(new LoadingScreen());
		Loader.the.loadRoom("restaurant2", initLevel);
	}
	
	private function initLevel(): Void {
		Configuration.setScreen(this);
	}
	
	override public function render(painter: Painter) {
		
	}
}