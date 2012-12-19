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
	//public var myButCookingBookOpen : Item;
	//public var myButCookingBookClose : Item;
	
	private var myButSpriteCookingBookOpen : SpriteButton;
	private var myButSpriteCookingBookClose : SpriteButton;
	
	private var myButNext : SpriteButton;
	private var myButNextPosition : Position;
	private var myButBack : SpriteButton;
	private var myButBackPosition : Position;
	private var myAnzPages:Int = 0;
	private var myRezeptSprites : Array<Sprite>;
	private var myRezeptPicPos : Array<Position>;
	private var myCurrentRecept : Int = 0;
	
	public var myRezepte : Array<Rezept>;
	
	public function new() 
	{
		
		myBookPosition = new Position(500, 100);
		myRezepte = new Array<Rezept>();
		myRezepte.push(new Rezept().Create1("Tomatensalat", EZutat.TOMATE));
		myRezepte.push(new Rezept().Create2("Spaghetti", EZutat.TOMATE, EZutat.SPAGHETTI));
		myRezepte.push(new Rezept().Create3("Tomatensuppe", EZutat.TOMATE, EZutat.TOMATE, EZutat.TOMATE));
		myRezepte.push(new Rezept().Create4("SpaghettiExtra", EZutat.TOMATE, EZutat.TOMATE, EZutat.SPAGHETTI, EZutat.SPAGHETTI));
		//myRezepte.push(new Rezept().Create5("Grosser Tomatensalat", EZutat.TOMATE, EZutat.TOMATE, EZutat.TOMATE, EZutat.TOMATE, EZutat.TOMATE));
		myRezepte.push(new Rezept().Create6("SpaghettiExtra mit Tomatensalat", EZutat.TOMATE, EZutat.TOMATE, EZutat.SPAGHETTI, EZutat.SPAGHETTI, EZutat.TOMATE, EZutat.TOMATE));
		
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
			if(myButSpriteCookingBookClose == null)
				myButSpriteCookingBookClose = StGameManager.MySpriteButtonManager().createButton(ESpriteButton.BUTCOOKINGBOOKOPEN, new Position(500, 0 ));
			else
				myButSpriteCookingBookClose.setVisible(true);
			
			ShowRezept();
			ShowBookButtons();
			
		}
		else
		{	
			if(myButSpriteCookingBookOpen == null)
				myButSpriteCookingBookOpen = StGameManager.MySpriteButtonManager().createButton(ESpriteButton.BUTCOOKINGBOOKCLOSE, new Position(500, 0 ));
			else
				myButSpriteCookingBookOpen.setVisible(true);
				
			ShowRezept();
			CloseBookButtons();
			
		}
			
	}
	private function ShowBookButtons()
	{
		if(myButBack == null)
			myButBack = StGameManager.MySpriteButtonManager().createButton(ESpriteButton.BUTBOOKBACK, new Position( myButBackPosition.x,  myButBackPosition.y ));
		else
			myButBack.setVisible(true);
			
		if(myButNext == null)	
			myButNext =  StGameManager.MySpriteButtonManager().createButton(ESpriteButton.BUTBOOKNEXT, new Position( myButNextPosition.x,  myButNextPosition.y ));
		else
			myButNext.setVisible(true);
		
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
		if(myButSpriteCookingBookOpen != null)
			myButSpriteCookingBookOpen.setVisible(false);
			
		if(myButSpriteCookingBookClose != null)
			myButSpriteCookingBookClose.setVisible(false);
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
	
	public function checkButtonEventOnMouseDown(paX:Int, paY:Int) {	
		moouseEventOpenBook();
		mouseEventChangePages(paX, paY);
	}
	private function moouseEventOpenBook()
	{
		if (!myIsOpen)
		{
			if (StGameManager.MySpriteButtonManager().haveButtonOrder(ESpriteButton.BUTCOOKINGBOOKCLOSE)){
					this.openBook();
					this.reflashGUI();
			}
		}
		else
		{
			if (StGameManager.MySpriteButtonManager().haveButtonOrder(ESpriteButton.BUTCOOKINGBOOKOPEN)) {
				this.closeBook();
				this.reflashGUI();
			}
		}
	}
	
	private function mouseEventChangePages(paX:Int, paY:Int)
	{
		if (myIsOpen)
		{
			if (myButNext != null)
			{
				if (myButNext.assimilateOrder()){
					this.changePage(true);
					CloseRezept();
					ShowRezept();
					
					//change Rezept for scratchpad
					//StGameManager.MyLagerManager().closeWindow();
					//StGameManager.MyLagerManager().showRezeptWindow(myRezepte[myCurrentRecept]);
				}
			}
			
			if (myButBack != null)
			{
				if (myButBack.assimilateOrder()){
					this.changePage(false);
					CloseRezept();
					ShowRezept();
					
					//change Rezept for scratchpad
					//StGameManager.MyLagerManager().closeWindow();
					//StGameManager.MyLagerManager().showRezeptWindow(myRezepte[myCurrentRecept]);
				}
			}
		}
	}
	
	public function getCurrentRezept() : Rezept {
		return myRezepte[myCurrentRecept];
	}
	
}