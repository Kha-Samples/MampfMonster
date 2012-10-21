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
		Configuration.setScreen(this);
	}
	
	override public function buttonDown(button: Button): Void {
		switch (button) {
		case Button.LEFT:
			cook.left = true;
			cook.changeDirection();
		case Button.RIGHT:
			cook.right = true;
			cook.changeDirection();
		case Button.UP:
			cook.up = true;
			cook.changeDirection();
		case Button.DOWN:
			cook.down = true;
			cook.changeDirection();
		default:
		}
	}
	
	override public function buttonUp(button: Button): Void {
		switch (button) {
		case Button.LEFT:
			cook.left = false;
			cook.changeDirection();
		case Button.RIGHT:
			cook.right = false;
			cook.changeDirection();
		case Button.UP:
			cook.up = false;
			cook.changeDirection();
		case Button.DOWN:
			cook.down = false;
			cook.changeDirection();
		default:
		}
	}
	
	private var cook: Cook;
}