package;

import flash.display.Sprite;
import kha.Button;
import kha.Configuration;
import kha.Game;
import kha.Loader;
import kha.LoadingScreen;
import kha.Scene;
import kha.Sound;
import kha.Tile;
import kha.Tilemap;

class YolkfolkRestaurantneuextends Game {
	public function new(): Void {
		super("Yolkfolk Restaurant", false);
		StGameManager.InitGame(this);
		StGameManager.InitCookingBook(new CookingBook());
	}
	
	public override function init(): Void {

		Configuration.setScreen(new LoadingScreen());
		Loader.the.loadRoom("restaurant", initLevel);
		
		
	}
	
	private function isCollidable(index: Int): Bool {
		return false;
	}
	
	private function startBook(): Void {
		var sound: Sound = Loader.the.getSound("jump");
		sound.play();
		
		myItem_01 = StGameManager.MyGameManager().addItem(Eitem.TOMATE, 0, 0);
		
		StGameManager.MyCookingBookManager().GUION();
<<<<<<< HEAD
		
		var MyLager : Lager = new Lager();

		//cook = new Cook();
		//scene.addHero(cook);
=======
	}
	
	private function startCook(): Void {
		StGameManager.MyGameManager().CreateBackground();
		
		cook = new Cook();
		scene.addHero(cook);
>>>>>>> 7d584b91b7f18f578403e71b3d51a9f32370981f
		
		addTable(60, 100);
		addTable(500, 300);
	}
	
	private function initLevel(): Void {
		//startBook();
		startCook();
		Configuration.setScreen(this);
	}
	
	public function CreateBackground()
	{
		var tileColissions = new Array<Tile>();
		for (i in 0...(6 * 8)) {
			tileColissions.push(new Tile(i, isCollidable(i)));
		}
		var blob = Loader.the.getBlob("restaurant.map");
		var levelWidth : Int = blob.readInt();
		var levelHeight : Int = blob.readInt();
		var map = new Array<Array<Int>>();
		for (x in 0...levelWidth) {
			map.push(new Array<Int>());
			for (y in 0...levelHeight) {
				map[x].push(blob.readInt());
			}
		}
		var tilemap: Tilemap = new Tilemap("054-Wall02", 16 * 3, 16 * 3, map, tileColissions);
		Scene.the.setColissionMap(tilemap);
		Scene.the.addBackgroundTilemap(tilemap, 1);
		
		
	}
	
	public function addItem(id: Eitem, x: Float, y: Float): Item {
			
		//var item = new Item().createByID(id);
		var item = Item.createByString(Std.string(id));
		item.x = x;
		item.y = y;
		scene.addEnemy(item);
		return item;
	}
	
	public function addItemByString(id: String, x: Float, y: Float): Item {
			
		var item = Item.createByString(id);
		item.x = x;
		item.y = y;
		scene.addEnemy(item);
		return item;
	}
	public function delItem(paSprite : kha.Sprite)
	{
		scene.removeEnemy(paSprite);
		//paSprite = null;
	}
	private function addTable(x: Float, y: Float): Void {
		var table = new Table();
		table.x = x;
		table.y = y;
		scene.addEnemy(table);
		
		var chair1 = new Chair1();
		chair1.x = x + 50;
		chair1.y = y - 60;
		scene.addEnemy(chair1);
		
		var chair2 = new Chair2();
		chair2.x = x + 50;
		chair2.y = y + 140;
		scene.addEnemy(chair2);
	}
	
	override public function mouseDown(paX: Int, paY: Int): Void 
	{ 
		
		
		if (myItem_01 == null)
		{
			myItem_01 = StGameManager.MyGameManager().addItem(Eitem.TOMATE, paX, paY);
		}
		else if (StHelper.IsOverTestBySprite(paX, paY, myItem_01))
		{
			StGameManager.MyGameManager().delItem(myItem_01);
			myItem_01 = null;
		}
	}
	
	override public function mouseUp  (paX: Int, paY: Int): Void 
	{ 
		StGameManager.MyCookingBookManager().moouseEvent(paX, paY);
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
	
	private var myItem_01 : Item;
	private var cook: Cook;
	
	
}