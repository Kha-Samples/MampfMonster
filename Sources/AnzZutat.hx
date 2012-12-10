package ;

/**
 * ...
 * @author Daniel Rachtan
 */

class AnzZutat 
{
	public var myZutat : EZutat;
	public var myAnzahl = 0;
	
	public function new(paEZutat : EZutat) :Void
	{
		myAnzahl = 1;
		myZutat = paEZutat;
	}
	
	public function getAnzahl() : Int {
		return myAnzahl;
	}
	public function getZutat() : EZutat {
		return myZutat;
	}
	
	
}