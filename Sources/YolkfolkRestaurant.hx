package;

import kha.Configuration;
import kha.Game;
import kha.Loader;
import kha.LoadingScreen;

class YolkfolkRestaurant extends Game {
	public function new(): Void {
		super("Yolkfolk Restaurant", false);	
	}
	
	public override function init(): Void {
		Configuration.setScreen(new LoadingScreen());
		Loader.the.loadRoom("restaurant", initLevel);
	}
	
	private function initLevel(): Void {
		scene.addHero(new Cook());
		Configuration.setScreen(this);
	}
}