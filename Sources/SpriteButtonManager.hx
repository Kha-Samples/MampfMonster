package ;

import kha.Animation;
import kha.Game;
import kha.Image;
import kha.Sprite;
import kha.Scene;

/**
 * ...
 * @author Daniel Rachtan
 */

class SpriteButtonManager 
{
	var myButtonList : Array<SpriteButton>;
	private var MyScene: Scene;
	
	public function new(paScene : Scene) :Void{
		MyScene = paScene;
		myButtonList = new Array<SpriteButton>();
	}
	
	public function createButton(paSpriteButton : ESpriteButton, paPosition : Position) : SpriteButton{
		var l_SpriteButton : SpriteButton = SpriteButton.createByID(paSpriteButton);
		l_SpriteButton.SetPicture(ESpriteButtonPic.MAIN);
		l_SpriteButton.x = paPosition.x;
		l_SpriteButton.y = paPosition.y;
		myButtonList.push(l_SpriteButton);
		MyScene.addEnemy(l_SpriteButton);
		return l_SpriteButton;
	}
	
	public function update(paX: Int, paY: Int) : Void {
		for(daten in myButtonList){
			if (StHelper.IsOverTestBySprite(paX, paY, daten)) {
				daten.SetPicture(ESpriteButtonPic.HOVER);
			}
			else {
				daten.SetPicture(ESpriteButtonPic.MAIN);
			}
		}
	}
	
	public function onMouseKlick(paX: Int, paY: Int) : Void {
		var daten : SpriteButton;
		for(daten in myButtonList){
			if (StHelper.IsOverTestBySprite(paX, paY, daten)) {

				if(daten.getVisible())
					daten.setOrder();
			}
		}
	}
	public function haveButtonOrder(paButtonFunktion : ESpriteButton) : Bool
	{
		var daten : SpriteButton;
		for(daten in myButtonList){
			if (daten.GetButtonFunktion() == paButtonFunktion) {
				return daten.assimilateOrder();
			}
		}
		return false;
	}
	public function resetAssimailatenOrder()
	{
		var daten : SpriteButton;
		for(daten in myButtonList){
			daten.resetAssimaltionOrder();
		}
		
	}
	
}