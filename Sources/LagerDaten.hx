package ;
import kha.Sprite;

/**
 * ...
 * @author Daniel Rachtan
 */

class LagerDaten 
{
	private var myZutat:EZutat;
	private var myHaben:Int;
	private var myMax:Int;
	private var mySpriteListe:Array<Sprite>;
	private var myStartPosition:Position;
	private var myPosition:Position;
	
	public function new(paZutat:EZutat, paHaben:Int, paStartPosition:Position) 
	{
		myZutat = paZutat;
		myHaben = paHaben;
		myMax = 6;
		myStartPosition = paStartPosition;
		createSprites();
	}
	private function createSprites()
	{
		myPosition = myStartPosition;
		mySpriteListe = new Array<Sprite>();
		//Bild und Werkzeuge
		var temp :Sprite = StGameManager.MyGameManager().addItem(StHelper.changeStringToEItem(Std.string(myZutat)), myPosition.x, myPosition.y);
		mySpriteListe.push(temp);
		//weiter
		//
		myPosition.y += 70;
		//Bestand
		var counter:Int = 0;
		var WareCounter:Int = 0;
		while (counter < myMax)
		{
			if (counter < myHaben)//guthaben
			{
				//Item umwandeln
				var l_Item:Eitem = StHelper.changeStringToEItem(Std.string(myZutat));
				//Item erstellen
				var temp :Sprite = StGameManager.MyGameManager().addItem(l_Item, myPosition.x, myPosition.y);
				mySpriteListe.push(temp);
				myPosition.x += 70;
			}
			else//leere Fächer
			{
				var l_Item:Eitem = StHelper.changeStringToEItem(Std.string(myZutat));
				var temp :Sprite = StGameManager.MyGameManager().addItemByString("" + Std.string(l_Item) + "_SW" , myPosition.x, myPosition.y);
				mySpriteListe.push(temp);
				myPosition.x += 70;
			}
			//myPosition.x = myStartPosition.x;
			counter++;
		}
		//mySpriteListe
		
	}
	
	public function getMax():Int
	{
		return myMax;
	}
	public function setMax(paValue:Int)
	{
		myMax = paValue;
	}
	public function getHaben():Int
	{
		return myHaben;
	}
	public function setHaben(paValue:Int)
	{
		if(paValue > myMax)
			myHaben = myMax;
		else if (paValue < 0)
			myHaben = 0;
		else
			myHaben = paValue;
	}
	public function getZutat():EZutat
	{
		return myZutat;
	}
	public function getSpriteListe():Array<Sprite>
	{
		return mySpriteListe;
	}
}