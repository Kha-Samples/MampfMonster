package ;
import kha.Sprite;

/**
 * ...
 * @author Daniel Rachtan
 */

class StHelper 
{

	private static var INSTANCE : StHelper;
	
	private function new() 
	{
		
	}
	
	public static function IsOverTest(paMouseX:Int, paMouseY:Int, paSpriteX:Float , paSpriteY:Float, paSpriteW:Float, paSpriteH:Float) : Bool
	{
		if (paMouseX >= paSpriteX && paMouseX <= (paSpriteX + paSpriteW))
		{
			if (paMouseY >= paSpriteY && paMouseY <= (paSpriteY + paSpriteH))
			{
				return true;
			}
		}
		return false;
	}
	
	public static function IsOverTestBySprite(paMouseX:Int, paMouseY:Int, paSprite:Sprite) : Bool
	{
		return StHelper.IsOverTest(paMouseX, paMouseY, paSprite.x, paSprite.y, paSprite.width, paSprite.height);
	}
	
	public static function changeStringToEItem(paEItem : String) : Eitem
	{
		try
		{
			return  Type.createEnum(Eitem, paEItem);
		}
		catch( msg : String )
		{
			trace("Error occurred: " + msg);
			return Eitem.NONE;
		}
		return Eitem.NONE;
	}
}