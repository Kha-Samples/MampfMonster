package ;

/**
 * ...
 * @author Daniel Rachtan
 */

class Rezept 
{
	public var myRezeptName : String = "";
	public var myZutaten : Array<Eitem>;
	
	public function new() 
	{		
	}
	public function Create1(paName:String, paZu01:Eitem , paZu02:Eitem) : Rezept
	{
		myRezeptName = paName;
		myZutaten = new Array<Eitem>();
		myZutaten.push(paZu01);
		myZutaten.push(paZu02);
		
		return this;
	}
	public function Create2(paName:String, paZu01:Eitem , paZu02:Eitem) : Rezept
	{
		myRezeptName = paName;
		myZutaten = new Array<Eitem>();
		myZutaten.push(paZu01);
		myZutaten.push(paZu02);
		
		return this;
	}
	
}