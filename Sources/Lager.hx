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
	public var myIsOpen : Bool = false;
	private var myAllItems : Array<LagerDaten>;
	
	var myPosition:Position;
	var myStartPosition:Position;
	var myLager:Array<EZutat>;
	private var myNotizBlock :Sprite;
	private var counter:Int = 2;//nur zum testen!!
	
	public function new() 
	{	
		
		
	}
	public function reflashGUI()
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
	
	public function GUION()
	{
		reflashGUI();
	}
	
	public function GUIOFF()
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
	
	public function showWindow()
	{
		if (myIsOpen)
			return;

		myAllItems = new Array<LagerDaten>();
		counter = 2;//Temp Lagerstand überarbeiten!!!
		myStartPosition = new Position(10, 100);
		myPosition = new Position(1,1);
		myPosition.x = myStartPosition.x;
		myPosition.y = myStartPosition.y;
		myNotizBlock = StGameManager.MyGameManager().addItem(Eitem.NOTIZBLOCK, myPosition.x, myPosition.y);
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
			counter++;
		}
		myIsOpen = true;
	}
	
	public function closeWindow()
	{
		StGameManager.MyGameManager().delItem(myNotizBlock);
		for (lagerdaten in myAllItems )
		{
			for (lagerSprite in lagerdaten.getSpriteListe())
			{
				StGameManager.MyGameManager().delItem(lagerSprite);
			}
		}
		myIsOpen = false;
		myNotizBlock = null;
	}
	
	public function moouseEvent(paX:Int, paY:Int)
	{
		mouseEventIcon(paX, paY);
	}
	
	private function mouseEventIcon(paX:Int, paY:Int)
	{
		if (!myIsOpen)
		{
			if (myButIconOpen != null)
			{
				if (StHelper.IsOverTestBySprite(paX, paY, myButIconOpen))
				{
					this.showWindow();
					this.reflashGUI();
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
					this.reflashGUI();
				}
			}
		}
	}
	
}