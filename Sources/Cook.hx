package;

import kha.*;

class Cook extends Sprite {
	public function new() {
		super(Loader.the.getImage("yolk.png"), 15 * 3, 17 * 3, 1);
		accy = 0;
		direction = Direction.DOWN;
		speed = new Vector2();
		leftHand = new Hand();
		Scene.the.addHero(leftHand);
		
		leftFoot = new Foot();
		Scene.the.addHero(leftFoot);
		rightFoot = new Foot();
		Scene.the.addHero(rightFoot);
	}
	
	public var up   : Bool = false;
	public var down : Bool = false;
	public var left : Bool = false;
	public var right: Bool = false;
	
	override public function update(): Void {
		super.update();
		if (up) {
			speed.y = -1;
			setAnimation(Animation.create(2));
			direction = Direction.UP;
		}
		else if (down) {
			speed.y = 1;
			setAnimation(Animation.create(0));
			direction = Direction.DOWN;
		}
		else speed.y = 0;
		if (left) {
			speed.x = -1;
			setAnimation(Animation.create(3));
			direction = Direction.LEFT;
		}
		else if (right) {
			speed.x = 1;
			setAnimation(Animation.create(1));
			direction = Direction.RIGHT;
		}
		else speed.x = 0;
		speed.length = absoluteSpeed;
		speedx = speed.x;
		speedy = speed.y;
		
		leftHand.x = x + 10;
		leftHand.y = y + 10;
		
		
		switch (direction) {
		case UP:
			leftFoot.setAim(x, y + 40); leftFoot.z = 0;
			rightFoot.setAim(x + width - rightFoot.width, y + 40); rightFoot.z = 0;
		case DOWN:
			leftFoot.setAim(x + width - leftFoot.width, y + 40); leftFoot.z = 2;
			rightFoot.setAim(x, y + 40); rightFoot.z = 2;
		case LEFT:
			leftFoot.setAim(x + width - leftFoot.width - 6, y + 40); leftFoot.z = 0;
			rightFoot.setAim(x + 6, y + 40); rightFoot.z = 2;
		case RIGHT:
			leftFoot.setAim(x + 6, y + 40); leftFoot.z = 2;
			rightFoot.setAim(x + width - rightFoot.width - 6, y + 40); rightFoot.z = 0;
		}
	}
	
	private static var absoluteSpeed: Float = 2;
	private var speed: Vector2;
	private var leftHand: Hand;
	private var rightHand: Hand;
	private var leftFoot: Foot;
	private var rightFoot: Foot;
	private var direction: Direction;
}