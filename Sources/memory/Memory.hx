package memory;

import haxe.Timer;
import kha.Configuration;
import kha.Game;
import kha.Image;
import kha.Loader;
import kha.LoadingScreen;
import kha.Painter;
import kha.Random;

class Memory extends Game {
	private var back: Image;
	private var shadow: Image;
	private var cards: Array<Card>;
	
	public function new() {
		super("Memory", false);
	}
	
	override public function init(): Void {
		Configuration.setScreen(new LoadingScreen());
		Loader.the.loadRoom("memory", loadingFinished);
	}
	
	private function loadingFinished(): Void {
		Random.init(Std.int(Timer.stamp() * 1000));
		back = Loader.the.getImage("memory/bg_pattern");
		shadow = Loader.the.getImage("memory/shadow");
		Food.cook();
		cards = new Array<Card>();
		var x = 100;
		while (x < 1000) {
			var y = 100;
			while (y < 800) {
				var xx = x + Random.getUpTo(40) - 20;
				var yy = y + Random.getUpTo(40) - 20;
				cards.push(new Card(xx, yy, Food.all[Random.getUpTo(Food.all.length - 1)]));
				y += 190;
			}
			x += 200;
		}
		Configuration.setScreen(this);
	}
	
	override public function update(): Void {
		for (card in cards) card.update();
	}
	
	override public function render(painter: Painter): Void {
		var x = 0;
		while (x < width) {
			var y = 0;
			while (y < height) {
				painter.drawImage(back, x, y);
				y += back.getHeight();
			}
			x += back.getWidth();
		}
		painter.drawImage2(shadow, 0, 0, shadow.getWidth(), shadow.getHeight(), 0, 0, width, height);
		
		for (card in cards) card.render(painter);
	}
	
	var clickedCard: Card = null;
	
	override public function mouseDown(x: Int, y: Int): Void {
		for (card in cards) {
			if (x >= card.x - Card.width / 2 && x <= card.x + Card.width / 2 && y >= card.y - Card.height / 2 && y <= card.y + Card.height / 2) {
				clickedCard = card;
				break;
			}
		}
	}
	
	override public function mouseUp(x: Int, y: Int): Void {
		for (card in cards) {
			if (x >= card.x - Card.width / 2 && x <= card.x + Card.width / 2 && y >= card.y - Card.height / 2 && y <= card.y + Card.height / 2) {
				if (clickedCard == card) {
					card.click();
					clickedCard = null;
					break;
				}
			}
		}
	}
}