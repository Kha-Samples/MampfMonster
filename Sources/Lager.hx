package ;
import kha.Sprite;

/**
 * ...
 * @author Daniel Rachtan
 */

class Lager 
{
	public var myButIconOpen : Item;
	public var myButIconClose : Item;
	public var myButOK : Array<Item>;
	public var myButKaufen :Array<Item>;
	public var myIsOpen : Bool = false;
	private var myAllItems : Array<LagerDaten>;
	
	var myPosition:Position;
	var myStartPosition:Position;
	var myLager:Array<EZutat>;
	private var myNotizBlock :Sprite;
	private var counter:Int = 2;//nur zum testen!!
	
	public function new() 
	{	
		myStartPosition = new Position(10, 100);	
		
	}
	/*daniel 
	-show rezept fehlt
	-scrollen durch alle zutaten
	-maximal 4 zutaten pro feld
	*/
	public function createLager() : Void{
	
		myAllItems = new Array<LagerDaten>();
		counter = 1;//Temp Lagerstand überarbeiten!!!	
		myPosition = new Position(1,1);
		myPosition.x = myStartPosition.x;
		myPosition.y = myStartPosition.y;
		myPosition.x = myStartPosition.x + 30;
		myPosition.y = myStartPosition.y + 20;
		var l_alleZutaten : Array<String> = Type.getEnumConstructs(EZutat);
		for (daten in l_alleZutaten )
		{
			if (daten != "NONE")
			{
			
				var temp : LagerDaten = new LagerDaten(Type.createEnum(EZutat, daten), counter , myPosition);
				myPosition.y += 70;
				myPosition.x = myStartPosition.x + 30;
				myAllItems.push(temp);
				
			}
			//counter++;
		}
		closeWindow();
	}
	public function reflashGUI() : Void
	{
		this.GUIOFF();
		
		if (myIsOpen)
		{
			myButIconClose = StGameManager.MyGameManager().addItem(Eitem.BUTCOOKINGBOOKOPEN, 300, 0);
		}
		else
		{
			myButIconOpen = StGameManager.MyGameManager().addItem(Eitem.BUTCOOKINGBOOKCLOSE, 300, 0);
		}
			
	}
	
	public function GUION() : Void
	{
		reflashGUI();
	}
	
	public function GUIOFF() : Void
	{
		if (myButIconOpen != null) 
		{
			StGameManager.MyGameManager().delItem(myButIconOpen);
			myButIconOpen = null;
		}
		
		if (myButIconClose != null) 
		{
			StGameManager.MyGameManager().delItem(myButIconClose);
			myButIconClose = null;
		}
	}
	
	public function showWindow() : Void
	{
		if (myIsOpen)
			return;
		
		myPosition = new Position(0,0);
		myPosition.x = myStartPosition.x;
		myPosition.y = myStartPosition.y;
		myNotizBlock = StGameManager.MyGameManager().addItem(Eitem.NOTIZBLOCK, myPosition.x, myPosition.y);
		
		for (lagerdaten in myAllItems )
		{
			lagerdaten.createSprites();
		}
		
		myIsOpen = true;
	}
	
	public function showRezeptWindow(paRezept : Rezept) : Void
	{
		
		if (myIsOpen)
			return;
		myButOK = new Array <Item>();
		myButKaufen = new Array <Item>();
		
		myPosition = new Position(0,0);
		myPosition.x = myStartPosition.x;
		myPosition.y = myStartPosition.y;
		myNotizBlock = StGameManager.MyGameManager().addItem(Eitem.NOTIZBLOCK, myPosition.x, myPosition.y);
		
		for (lagerdaten in myAllItems )
		{
			for (rezeptdaten in paRezept.myZutaten)
			{
				if (Std.string( lagerdaten.getZutat()) == Std.string(rezeptdaten) && lagerdaten.getSpriteListe() == null )
				{
					var temp : Position = lagerdaten.createRezeptSprites(true, paRezept.getAnzZutaten(Std.string(rezeptdaten)));
					if (lagerdaten.getRezeptHaveAll())
					{//alles ok
						myButOK.push(StGameManager.MyGameManager().addItem(Eitem.OK, temp.x, temp.y));
					}
					else
					{//kaufen etwas fehlt
						myButKaufen.push(StGameManager.MyGameManager().addItem(Eitem.CANCEL, temp.x, temp.y));
					}
				}
			}
			
		}
		
		myIsOpen = true;
		
		
		
	}
	
	public function closeWindow() :Void
	{
		if (!myIsOpen)
			return;
		StGameManager.MyGameManager().delItem(myNotizBlock);
		for (lagerdaten in myAllItems )
		{
			lagerdaten.delSprites();
		}
		if (myButOK != null)
		{
			for (daten in myButOK)
			{
				StGameManager.MyGameManager().delItem(daten);
			}
			myButOK = null;
		}
		if (myButKaufen != null)
		{
			for (daten in myButKaufen)
			{
				StGameManager.MyGameManager().delItem(daten);
			}
			myButKaufen = null;
		}
		myIsOpen = false;
		myNotizBlock = null;
	}
	
	public function moouseEvent(paX:Int, paY:Int) : Void
	{
		mouseEventIcon(paX, paY);
	}
	
	private function mouseEventIcon(paX:Int, paY:Int) : Void
	{
		if (!myIsOpen)
		{
			if (myButIconOpen != null)
			{
				if (StHelper.IsOverTestBySprite(paX, paY, myButIconOpen))
				{
					this.showWindow();
					//this.reflashGUI();
				}
			}
		}
		else
		{
			if (myButIconClose != null)
			{
				if (StHelper.IsOverTestBySprite(paX, paY, myButIconClose))
				{
					this.closeWindow();
					//this.reflashGUI();
				}
			}
		}
	}
	
}