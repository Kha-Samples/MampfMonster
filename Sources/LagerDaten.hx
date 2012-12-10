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
	private var myTempIsRezept:Bool;
	private var myTempSize:Int;
	private var myRezeptHaveAll:Bool;
	
	public function new(paZutat:EZutat, paHaben:Int, paStartPosition:Position) 
	{
		myZutat = paZutat;
		myHaben = paHaben;
		myMax = 4;
		myPosition = new Position(paStartPosition.x, paStartPosition.y);
		myStartPosition = new Position(paStartPosition.x, paStartPosition.y);
		//createSprites();
	}
	public function createRezeptSprites(paISRezept:Bool, paSize:Int) : Position
	{
		myTempIsRezept = paISRezept;
		myTempSize = paSize;
		return createSprites();
	}
	
	public function createSprites() : Position
	{
		myPosition = new Position(myStartPosition.x, myStartPosition.y);
		mySpriteListe = new Array<Sprite>();
		myRezeptHaveAll = true;//reset
		//Bild und Werkzeuge
		//var temp :Sprite = StGameManager.MyGameManager().addItem(StHelper.changeStringToEItem(Std.string(myZutat)), myPosition.x, myPosition.y);
		//mySpriteListe.push(temp);
		//weiter
		//
		//myPosition.y += 70;
		//Bestand
		var counter:Int = 0;
		var WareCounter:Int = 0;
		var tempSize = myMax;
		if (myTempIsRezept)
			tempSize = myTempSize;
			
		while (counter < tempSize)
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
				if (myTempIsRezept)//wenn rezept
				{
					myRezeptHaveAll = false;
				}
			}
			//myPosition.x = myStartPosition.x;
			counter++;
		}
		myTempIsRezept = false;//reset
		//mySpriteListe	
		return myPosition;
	}
	public function delSprites() : Void
	{
		if(mySpriteListe!= null)
			for (lagerSprite in mySpriteListe)
			{
				StGameManager.MyGameManager().delItem(lagerSprite);
			}
		mySpriteListe = null;
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
	public function getRezeptHaveAll() : Bool {
		return myRezeptHaveAll;
	}
}