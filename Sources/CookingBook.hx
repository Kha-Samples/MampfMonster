package ;
import kha.Sprite;

/**
 * ...
 * @author Daniel Rachtan
 */

class CookingBook 
{
	public var myBookPosition : Position;
	public var myIsOpen : Bool = false;
	public var myBook : Sprite = null;
	public var myButCookingBookOpen : Item;
	public var myButCookingBookClose : Item;
	private var myAnzPages:Int = 0;
	private var myRezeptSprites : Array<Sprite>;
	private var myRezeptPicPos : Array<Position>;
	private var myCurrentRecept : Int = 0;
	
	public var myRezepte : Array<Rezept>;
	
	public function new() 
	{
		myBookPosition = new Position(400, 100);
		myRezepte = new Array<Rezept>();
		myRezepte.push(new Rezept().Create2("Spaghetti", Eitem.TOMATE, Eitem.SPAGHETTI));
		myRezepte.push(new Rezept().Create2("Tomatensuppe", Eitem.TOMATE, Eitem.TOMATE));
		
		myAnzPages = myRezepte.length;
		myRezeptPicPos = new Array<Position>();
		myRezeptPicPos.push(new Position(myBookPosition.x + 60, myBookPosition.y +40 ));
		myRezeptPicPos.push(new Position(myBookPosition.x + 60, myBookPosition.y +140 ));
		myRezeptPicPos.push(new Position(myBookPosition.x + 60, myBookPosition.y +240 ));
		
		
	}
	public function reflashGUI()
	{
		this.GUIOFF();
		
		if (myIsOpen)
		{
			myButCookingBookClose = StGameManager.MyGameManager().addItem(Eitem.BUTCOOKINGBOOKCLOSE, 400, 0);
			ShowRezept();
		}
		else
		{
			myButCookingBookOpen = StGameManager.MyGameManager().addItem(Eitem.BUTCOOKINGBOOKOPEN, 400, 0);
			ShowRezept();
		}
			
	}
	
	private function ShowRezept()
	{
		if (myIsOpen)
		{
			var lAnzZutaten = myRezepte[myCurrentRecept].myZutaten.length;
			//var lCounter = 0;
		//	while(lCounter)
			myRezeptSprites = new Array<Sprite>();
			myRezeptSprites.push(StGameManager.MyGameManager().addItem(Eitem.TOMATE, myRezeptPicPos[0].x, myRezeptPicPos[0].y));
			myRezeptSprites.push(StGameManager.MyGameManager().addItem(Eitem.SPAGHETTI, myRezeptPicPos[1].x, myRezeptPicPos[1].y));
		}
		else
		{
			if(myRezeptSprites != null)
				for (daten in myRezeptSprites)
				{
					StGameManager.MyGameManager().delItem(daten);
				}
		}
	}
	
	public function GUION()
	{
		reflashGUI();
	}
	
	public function GUIOFF()
	{
		if (myButCookingBookOpen != null) 
		{
			StGameManager.MyGameManager().delItem(myButCookingBookOpen);
			myButCookingBookOpen = null;
		}
		
		if (myButCookingBookClose != null) 
		{
			StGameManager.MyGameManager().delItem(myButCookingBookClose);
			myButCookingBookClose = null;
		}
	}
	
	
	public function openBook()
	{
		if (myIsOpen)
			return;
			
		myBook = StGameManager.MyGameManager().addItem(Eitem.COOKINGBOOK, myBookPosition.x, myBookPosition.y);
		myIsOpen = true;
	}
	
	public function closeBook()
	{
		StGameManager.MyGameManager().delItem(myBook);
		myIsOpen = false;
		myBook = null;
	}
	
	public function moouseEvent(paX:Int, paY:Int)
	{
		if (!myIsOpen)
		{
			if (myButCookingBookOpen != null)
			{
				if (StHelper.IsOverTestBySprite(paX, paY, myButCookingBookOpen))
				{
					this.openBook();
					this.reflashGUI();
				}
			}
		}
		else
		{
			if (myButCookingBookClose != null)
			{
				if (StHelper.IsOverTestBySprite(paX, paY, myButCookingBookClose))
				{
					this.closeBook();
					this.reflashGUI();
				}
			}
		}
	}
	
	
}