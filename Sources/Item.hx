package;

import kha.Button;
import kha.Loader;
import kha.Sprite;


//Daniel: die Images müssen noch Local und im Projekt umbenannt werden... damit die namen aus den enum erstellt werden können
class Item extends Sprite {
	public function new(id: Eitem): Void {
		switch(id) {
			case Eitem.TOMATE:
				super(Loader.the.getImage("img_" + Std.string(id) + ".png"), 64, 64, 1);	
				this.id = id;
				accy = 0;
			case Eitem.SPAGHETTI:
				super(Loader.the.getImage("img_" + Std.string(id) + ".png"), 64, 64, 1);	
				this.id = id;
				accy = 0;
			case Eitem.COOKINGBOOK:
				super(Loader.the.getImage("img_CookingBook.png"), 512, 384, 0);
				this.id = id;
				accy = 0;		
			case Eitem.BUTCOOKINGBOOKOPEN:
				super(Loader.the.getImage("img_BookIcon_1.png"), 64, 64, 2);
				this.id = id;
				accy = 0;
			case Eitem.BUTCOOKINGBOOKCLOSE:
				super(Loader.the.getImage("img_BookIcon_2.png"), 64, 64, 1);
				this.id = id;
				accy = 0;
			case Eitem.BUTBOOKBACK:
				super(Loader.the.getImage("img_" + Std.string(id) + ".png"), 64, 32, 1);	
				this.id = id;
				accy = 0;
			case Eitem.BUTBOOKNEXT:
				super(Loader.the.getImage("img_" + Std.string(id) + ".png"), 64, 32, 1);	
				this.id = id;
				accy = 0;
			
			default:
				
		}
		
		
		var string = Std.string(Eitem.TOMATE);
	}
	
	public function ReturnMySelf(): Item
	{
		return this;
	}
	
	private var id: Eitem;
}

