package ;
import kha.Sprite;

/**
 * ...
 * @author Daniel Rachtan
 */

 //daniel To do: Wertesystem Kosten? und Gesundheit?, cancel? und ok button, 
 //brauche noch ein paar Rezeptbeispiele!
 //Sounds? Blättern, Bestätigung, Buch Öffnen - Schließen
class CookingBook 
{
	public var myBookPosition : Position;
	public var myIsOpen : Bool = false;
	public var myBook : Sprite = null;
	public var myButCookingBookOpen : Item;
	public var myButCookingBookClose : Item;
	
	private var myButNext : Item;
	private var myButNextPosition : Position;
	private var myButBack : Item;
	private var myButBackPosition : Position;
	private var myAnzPages:Int = 0;
	private var myRezeptSprites : Array<Sprite>;
	private var myRezeptPicPos : Array<Position>;
	private var myCurrentRecept : Int = 0;
	
	public var myRezepte : Array<Rezept>;
	
	public function new() 
	{
		
		myBookPosition = new Position(400, 100);
		myRezepte = new Array<Rezept>();
		myRezepte.push(new Rezept().Create1("Tomatensalat", EZutat.TOMATE));
		myRezepte.push(new Rezept().Create2("Spaghetti", EZutat.TOMATE, EZutat.SPAGHETTI));
		myRezepte.push(new Rezept().Create3("Tomatensuppe", EZutat.TOMATE, EZutat.TOMATE, EZutat.TOMATE));
		myRezepte.push(new Rezept().Create4("SpaghettiExtra", EZutat.TOMATE, EZutat.TOMATE, EZutat.SPAGHETTI, EZutat.SPAGHETTI));
		myRezepte.push(new Rezept().Create5("Grosser Tomatensalat", EZutat.TOMATE, EZutat.TOMATE, EZutat.TOMATE, EZutat.TOMATE, EZutat.TOMATE));
		myRezepte.push(new Rezept().Create6("Grosse Tomatensuppe", EZutat.TOMATE, EZutat.TOMATE, EZutat.TOMATE, EZutat.TOMATE, EZutat.TOMATE, EZutat.TOMATE));
		
		myAnzPages = myRezepte.length;
		myRezeptPicPos = new Array<Position>();
		myRezeptPicPos.push(new Position(myBookPosition.x + 60, myBookPosition.y +40 ));
		myRezeptPicPos.push(new Position(myBookPosition.x + 60, myBookPosition.y +140 ));
		myRezeptPicPos.push(new Position(myBookPosition.x + 60, myBookPosition.y +240 ));
		myRezeptPicPos.push(new Position(myBookPosition.x + 140, myBookPosition.y +40 ));
		myRezeptPicPos.push(new Position(myBookPosition.x + 140, myBookPosition.y +140 ));
		myRezeptPicPos.push(new Position(myBookPosition.x + 140, myBookPosition.y +240 ));
		
		myButBackPosition = new Position(myBookPosition.x + 50, myBookPosition.y +320 );
		myButNextPosition = new Position(myBookPosition.x + 410, myBookPosition.y +320 );
			
	}
	
	public function reflashGUI()
	{
		this.GUIOFF();
		
		if (myIsOpen)
		{
			myButCookingBookClose = StGameManager.MyGameManager().addItem(Eitem.BUTCOOKINGBOOKCLOSE, 400, 0);
			ShowRezept();
			ShowBookButtons();
		}
		else
		{
			myButCookingBookOpen = StGameManager.MyGameManager().addItem(Eitem.BUTCOOKINGBOOKOPEN, 400, 0);
			ShowRezept();
			CloseBookButtons();
		}
			
	}
	private function ShowBookButtons()
	{
		myButBack = StGameManager.MyGameManager().addItem(Eitem.BUTBOOKBACK, myButBackPosition.x, myButBackPosition.y);
		myButNext = StGameManager.MyGameManager().addItem(Eitem.BUTBOOKNEXT, myButNextPosition.x, myButNextPosition.y);
	}
	
	private function CloseBookButtons()
	{
		if (myButBack != null)
		{
			StGameManager.MyGameManager().delItem(myButBack);
			myButBack = null;
		}
		
		if (myButNext != null)
		{
			StGameManager.MyGameManager().delItem(myButNext);
			myButNext = null;
		}
		
	}
	
	private function ShowRezept()
	{
		if (myIsOpen)
		{
			myRezeptSprites = new Array<Sprite>();
			var lAnzZutaten = myRezepte[myCurrentRecept].myZutaten.length;
			var lCounter = 0;
			while (lCounter < lAnzZutaten)
			{	
				myRezeptSprites.push(StGameManager.MyGameManager().addItem(myRezepte[myCurrentRecept].myZutaten[lCounter], myRezeptPicPos[lCounter].x, myRezeptPicPos[lCounter].y));
				lCounter++;
			}
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
	
	private function CloseRezept()
	{
		if(myRezeptSprites != null)
				for (daten in myRezeptSprites)
				{
					StGameManager.MyGameManager().delItem(daten);
				}
	}
	
	public function GUION()
	{
		reflashGUI();
	}
	
	private function changePage(paSchalter : Bool)
	{
		if (paSchalter)
			myCurrentRecept++;
		else 
			myCurrentRecept--;

		
		if (myCurrentRecept >= myRezepte.length)
			myCurrentRecept = 0;
			
		if (myCurrentRecept < 0)
			myCurrentRecept = myRezepte.length - 1;
		
		
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
		mouseEventCookingBookIcon(paX, paY);
		mouseEventChangePages(paX, paY);
	}
	
	private function mouseEventCookingBookIcon(paX:Int, paY:Int)
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
	
	private function mouseEventChangePages(paX:Int, paY:Int)
	{
		if (myIsOpen)
		{
			if (myButNext != null)
			{
				if (StHelper.IsOverTestBySprite(paX, paY, myButNext))
				{
					this.changePage(true);
					CloseRezept();
					ShowRezept();
				}
			}
			
			if (myButBack != null)
			{
				if (StHelper.IsOverTestBySprite(paX, paY, myButBack))
				{
					this.changePage(false);
					CloseRezept();
					ShowRezept();
				}
			}
		}
	}
	
	
}