package;

import kha.Button;
import kha.Loader;
import kha.Sprite;
import kha.Image;


//Daniel: die Images müssen noch Local und im Projekt umbenannt werden... damit die namen aus den enum erstellt werden können
class Item extends Sprite {
	private static var myId:String;
		private function new(): Void {
			var temp : Image = Loader.the.getImage("img_" + myId );
			var x:Int = 0;
			var y:Int = 0;
			if(temp != null){
				x = temp.getWidth();
				y = temp.getHeight();
			}
			super(temp, x, y, 9);	
			this.id = Type.createEnum(Eitem, myId);
			this.accy = 0;
		}
		
		public static function createByString(id: String): Item {
			
			myId = id;
			return new Item();
			
		}
		
		public static function createByID(id: Eitem): Item {	
			return Item.createByString(Std.string(id));
			}

	
	public function ReturnMySelf(): Item
	{
		return this;
	}
	
	private function setID(paId:Eitem) {
		id = paId;
	}
	private var id: Eitem;
}

