package;

import kha.Button;
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
		cook = new Cook();
		scene.addHero(cook);
		scene.addHero(new Foot());
		Configuration.setScreen(this);
	}
	
	override public function buttonDown(button: Button): Void {
		switch (button) {
		case Button.LEFT:
			cook.left = true;
		case Button.RIGHT:
			cook.right = true;
		case Button.UP:
			cook.up = true;
		case Button.DOWN:
			cook.down = true;
		default:
		}
	}
	
	override public function buttonUp(button: Button): Void {
		switch (button) {
		case Button.LEFT:
			cook.left = false;
		case Button.RIGHT:
			cook.right = false;
		case Button.UP:
			cook.up = false;
		case Button.DOWN:
			cook.down = false;
		default:
		}
	}
	
	private var cook: Cook;
}