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
	private var myLager : Lager;
	private var mySpriteButtonManager : SpriteButtonManager;
	
	private function new() : Void
	{
		
	}
	
	
	public static function  InitGame(paValue : YolkfolkRestaurant)
	{
		if (INSTANCE == null)
		{
			INSTANCE = new StGameManager();
		}
		INSTANCE.myGame = paValue;
	}
	public static function  InitCookingBook(paValue : CookingBook)
	{
		if (INSTANCE == null)
		{
			INSTANCE = new StGameManager();
		}
		INSTANCE.myCookingBook = paValue;
	}
	public static function  InitLager(paValue : Lager)
	{
		if (INSTANCE == null)
		{
			INSTANCE = new StGameManager();
		}
		INSTANCE.myLager = paValue;
	}
	public static function  InitSpriteButtonManager(paValue : SpriteButtonManager)
	{
		if (INSTANCE == null)
		{
			INSTANCE = new StGameManager();
		}
		INSTANCE.mySpriteButtonManager = paValue;
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
	public static function MyLagerManager(): Lager
	{
		if (INSTANCE == null)
		{
			INSTANCE = new StGameManager();
		}
		return INSTANCE.myLager;
	}
	public static function MySpriteButtonManager(): SpriteButtonManager
	{
		if (INSTANCE == null)
		{
			INSTANCE = new StGameManager();
		}
		return INSTANCE.mySpriteButtonManager;
	}
	}