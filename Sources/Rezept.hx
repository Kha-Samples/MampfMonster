package ;

/**
 * ...
 * @author Daniel Rachtan
 */
class Rezept 
{
	public var myRezeptName : String = "";
	public var myZutaten : Array<Eitem>;
	public var myAnzZutatenListe : Array<AnzZutat>;
	
	public function new() :Void
	{	
		myAnzZutatenListe = new Array<AnzZutat>();
		myZutaten = new Array<Eitem>();
	}
	
	
	public function Create1(paName:String, paZu01:EZutat) : Rezept
	{
		myRezeptName = paName;
		myZutaten = new Array<Eitem>();
		myZutaten.push(changeToEItem(paZu01));
		calcAnzZutaten();
		return this;
	}
	public function Create2(paName:String, paZu01:EZutat , paZu02:EZutat) : Rezept
	{
		myRezeptName = paName;
		myZutaten = new Array<Eitem>();
		myZutaten.push(changeToEItem(paZu01));
		myZutaten.push(changeToEItem(paZu02));
		calcAnzZutaten();
		return this;
	}
	public function Create3(paName:String, paZu01:EZutat , paZu02:EZutat, paZu03:EZutat) : Rezept
	{
		myRezeptName = paName;
		myZutaten = new Array<Eitem>();
		myZutaten.push(changeToEItem(paZu01));
		myZutaten.push(changeToEItem(paZu02));
		myZutaten.push(changeToEItem(paZu03));
		calcAnzZutaten();
		return this;
	}
	public function Create4(paName:String, paZu01:EZutat , paZu02:EZutat, paZu03:EZutat, paZu04:EZutat) : Rezept
	{
		myRezeptName = paName;
		myZutaten = null;
		myZutaten = new Array<Eitem>();
		myZutaten.push(changeToEItem(paZu01));
		myZutaten.push(changeToEItem(paZu02));
		myZutaten.push(changeToEItem(paZu03));
		myZutaten.push(changeToEItem(paZu04));
		calcAnzZutaten();
		return this;
	}
	public function Create5(paName:String, paZu01:EZutat , paZu02:EZutat, paZu03:EZutat, paZu04:EZutat, paZu05:EZutat) : Rezept
	{
		myRezeptName = paName;
		myZutaten = new Array<Eitem>();
		myZutaten.push(changeToEItem(paZu01));
		myZutaten.push(changeToEItem(paZu02));
		myZutaten.push(changeToEItem(paZu03));
		myZutaten.push(changeToEItem(paZu04));
		myZutaten.push(changeToEItem(paZu05));
		calcAnzZutaten();
		return this;
	}
	public function Create6(paName:String, paZu01:EZutat , paZu02:EZutat, paZu03:EZutat, paZu04:EZutat, paZu05:EZutat, paZu06:EZutat) : Rezept
	{
		myRezeptName = paName;
		myZutaten = new Array<Eitem>();
		myZutaten.push(changeToEItem(paZu01));
		myZutaten.push(changeToEItem(paZu02));
		myZutaten.push(changeToEItem(paZu03));
		myZutaten.push(changeToEItem(paZu04));
		myZutaten.push(changeToEItem(paZu05));
		myZutaten.push(changeToEItem(paZu06));
		calcAnzZutaten();
		return this;
	}
	private function calcAnzZutaten()
	{
			var temp :Bool = true;
		
			for (zutatenDaten in myZutaten)
			{
				temp = true;
				if (myAnzZutatenListe.length <= 0)
				{
					myAnzZutatenListe.push(new AnzZutat(Type.createEnum(EZutat, Std.string(zutatenDaten))));
				}
				else//teste ob schon vorhanden
				{
					for (anzDaten in myAnzZutatenListe)
					{
						if (Std.string(zutatenDaten) == Std.string(anzDaten.myZutat))
						{
							anzDaten.myAnzahl++;
							temp = false;
						}
					}
					if(temp)//war nicht vorhanden
						myAnzZutatenListe.push(new AnzZutat(Type.createEnum(EZutat, Std.string(zutatenDaten))));
				}
					
			}
	}
	
	private function changeToEItem(paEItem : EZutat) : Eitem
	{
		
		/*
		//so kann man den Construktor eines Enums finden, mit den vergleich von Strings. Und man kann die Position auslesen
		var temp : Array<String> = Type.getEnumConstructs(Eitem);
		var counter : Int = 0;
		for (daten in temp)
		{
				if (Std.string(paEItem) == daten)
					return Type.createEnum(Eitem, Std.string(paEItem));
			counter++;
		}*/
		
		//besser ;)
		try
		{
			return  Type.createEnum(Eitem, Std.string(paEItem));
		}
		catch( msg : String )
		{
			trace("Error occurred: " + msg);
			return Eitem.NONE;
		}
	
		
		return Eitem.NONE;
	}
	
	public function getAnzZutaten(paZutat : String): Int
	{
		for (zutatDaten in myAnzZutatenListe)
		{
			if (Std.string(zutatDaten.getZutat()) == paZutat)
				return zutatDaten.getAnzahl();
		}
		return -1;
	}
	
}