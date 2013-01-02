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
	private var dragger: FoodDragger;
	
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
		dragger = new FoodDragger();
		Food.cook();
		ClassPlate.init();
		cards = new Array<Card>();
		
		var foodCount = 0;
		var x = 100;
		while (x < 1000) {
			var y = 100;
			while (y < 800) {
				++foodCount;
				y += 190;
			}
			x += 200;
		}
		
		var bigFoodPile = Food.all.copy();
		var foodPile = new Array<Food>();
		
		for (i in 0...Std.int(foodCount / 2)) {
			var food = bigFoodPile[Random.getUpTo(bigFoodPile.length - 1)];
			bigFoodPile.remove(food);
			foodPile.push(food);
			foodPile.push(food);
		}
		
		x = 100;
		while (x < 1000) {
			var y = 100;
			while (y < 800) {
				var xx = x + Random.getUpTo(40) - 20;
				var yy = y + Random.getUpTo(40) - 20;
				var food = foodPile[Random.getUpTo(foodPile.length - 1)];
				foodPile.remove(food);
				cards.push(new Card(xx, yy, food));
				//cards.push(new Card(xx, yy, Food.all[0]));
				y += 190;
			}
			x += 200;
		}
		setInstance();
		Configuration.setScreen(this);
	}
	
	override public function update(): Void {
		if (waiting > 0) {
			--waiting;
			if (waiting <= 0) {
				firstCard.click();
				secondCard.click();
				firstCard = null;
				secondCard = null;
			}
		}
		for (card in cards) card.update();
		dragger.update();
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
		dragger.render(painter);
	}
	
	var clickedCard: Card = null;
	var firstCard: Card = null;
	var secondCard: Card = null;
	var waiting: Int = 0;
	var dragging = false;
	
	public function nextRound(): Void {
		dragging = false;
	}
	
	override public function mouseDown(x: Int, y: Int): Void {
		if (dragging) {
			dragger.mouseDown(x, y);
			return;
		}
		if (waiting > 0) return;
		for (card in cards) {
			if (x >= card.x - Card.width / 2 && x <= card.x + Card.width / 2 && y >= card.y - Card.height / 2 && y <= card.y + Card.height / 2) {
				clickedCard = card;
				break;
			}
		}
	}
	
	override public function mouseUp(x: Int, y: Int): Void {
		if (dragging) {
			dragger.mouseUp(x, y);
			return;
		}
		if (waiting > 0) return;
		for (card in cards) {
			if (x >= card.x - Card.width / 2 && x <= card.x + Card.width / 2 && y >= card.y - Card.height / 2 && y <= card.y + Card.height / 2) {
				if (clickedCard == card) {
					card.click();
					clickedCard = null;
					
					if (firstCard == null) {
						firstCard = card;
					}
					else {
						if (firstCard.food == card.food) {
							cards.remove(firstCard);
							cards.remove(card);
							dragger.setCards(firstCard, card);
							firstCard = null;
							dragging = true;
						}
						else {
							secondCard = card;
							waiting = 80;
						}
					}
					
					break;
				}
			}
		}
	}
	
	override public function mouseMove(x: Int, y: Int): Void {
		if (dragging) {
			dragger.mouseMove(x, y);
			return;
		}
	}
}