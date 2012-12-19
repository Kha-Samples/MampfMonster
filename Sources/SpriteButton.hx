package;

import kha.Animation;
import kha.Image;
import kha.Sprite;
import kha.Loader;



class SpriteButton extends Sprite
{
	//private static var myIDName:String;
	private var isOn : Bool;
	//private var mySpriteButtonFunktion : ESpriteButton;
	private var myCurrentPic : ESpriteButtonPic;
	private var myButtonSizeX : Int;
	private var myButtonSizeY : Int;
	private var myEID : ESpriteButton;
	private var myHaveOrder : Bool;
	private var myAssimilate : Bool;
	
	private function new(paID : String): Void {
			myHaveOrder = false;
			myAssimilate = false;
			var temp : Image = Loader.the.getImage("img_" + paID );
			var x:Int = 0;
			var y:Int = 0;
			if (temp != null) {
				x = Std.int(temp.getWidth() / 3);
				y = temp.getHeight();
			}
			super(temp, x, y, 9);	
			this.myEID = Type.createEnum(ESpriteButton, paID);
			this.accy = 0;
			this.isOn = true;
	}
	
	public static function createByString(paID: String): SpriteButton {		
			return new SpriteButton(paID);		
	}
		
	public static function createByID(paEID: ESpriteButton): SpriteButton {	
		return SpriteButton.createByString(Std.string(paEID));
	}
	
	/*
	public function new(paButtonImage : Image, paWidth : Int, paHeight : Int, paZ : Int, paPosX : Float, paPosY : Float, paSpriteButtonPic : ESpriteButtonPic, paButtonfunktion : EButtonFunktion)
	{
		super(paButtonImage, paButtonImage, paHeight, paZ);
		ButtonFunktion = paButtonfunktion;
		isOn = true;
		this.x = paPosX;
		this.y = paPosY;
		this.setAnimation(Animation.create(0));
		SetStatus(paStatus);
		accy = 0;
	}*/
	
	public function SetPicture(paID : ESpriteButtonPic) : Void
	{
		myCurrentPic = paID;
		this.reflash();
	}
	private function reflash() {
		if (isOn)
		{
			switch(myCurrentPic) {
				case ESpriteButtonPic.MAIN:
					this.setAnimation(Animation.create(1));
				case ESpriteButtonPic.HOVER:
					this.setAnimation(Animation.create(2));
				default:
					this.setAnimation(Animation.create(0));
			}
		}
		else {
			this.setAnimation(Animation.create(0));
		}
	}
	
	public function setVisible(paSchalter : Bool) {
		this.isOn = paSchalter;
		 reflash();
		
	}
	public function getVisible():Bool {
		return this.isOn;
	}
	public function GetButtonFunktion() : ESpriteButton
	{
		return myEID;
	}
	public function setHaveOrder(paSchalter : Bool):Void {
		myHaveOrder = paSchalter;
	}
	public function setOrder():Void {
		myHaveOrder = true;
		myAssimilate = false;
	}
	public function getOrder():Bool
	{
		return myHaveOrder;
	}
	public function assimilateOrder() :Bool {
		myAssimilate = true;
		return myHaveOrder;
	}
	public function resetAssimaltionOrder()
	{
		if (myAssimilate)
		{
			myHaveOrder = false;
			myAssimilate = false;
		}
	}
}
