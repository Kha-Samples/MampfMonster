package ;

import kha.Game;
/**
 * ...
 * @author Daniel Rachtan
 */

class StGameManager
{
	private static var INSTANCE : StGameManager;
	private var myGame : YolkfolkRestaurant;
	private var myCookingBook : CookingBook;
	
	private function new() 
	{
		
	}
	
	public static function  InitGame(paMyGame : YolkfolkRestaurant)
	{
		if (INSTANCE == null)
		{
			INSTANCE = new StGameManager();
		}
		INSTANCE.myGame = paMyGame;
	}
	public static function  InitCookingBook(paMyCookingBook : CookingBook)
	{
		if (INSTANCE == null)
		{
			INSTANCE = new StGameManager();
		}
		INSTANCE.myCookingBook = paMyCookingBook;
	}
	
	public static function MyGameManager(): YolkfolkRestaurant
	{
		if (INSTANCE == null)
		{
			INSTANCE = new StGameManager();
		}
		return INSTANCE.myGame;
	}
	public static function MyCookingBookManager(): CookingBook
	{
		if (INSTANCE == null)
		{
			INSTANCE = new StGameManager();
		}
		return INSTANCE.myCookingBook;
	}
	}