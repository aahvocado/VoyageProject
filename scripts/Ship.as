package scripts {
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	
	public class Ship {
		//data
		var pos:Point;
		var mc:MovieClip;//movieclip parent
		var size:Number;//size of ship, this determines z position
		var velocity:Point;
		var active:Boolean;//is this ship useable
		//stats
		var baseHealth:Number;
		var currHealth:Number;
		
		var baseLaserEnergy:Number;
		var currLaserEnergy:Number;
		
		//var equipment:Array;
		var weapons:Vector.<Weapon>;
		//combat
		var combatNum:int;//number in the array for this combat
		var target:Ship;//ship this one will shoot at
		//var currWeapon:Weapon;
		var currWeaponNum:int;
		
		public function Ship(mcParam:MovieClip, posParam:Point, baseHealthParam:Number) {
			velocity = new Point(0,0);
			mc = mcParam;
			pos = posParam;
			baseHealth = baseHealthParam;
			reset();
			currWeaponNum = 0;
		}
		public function update(){
			pos.x += velocity.x;
			pos.y += velocity.y;
			
			mc.x = pos.x;
			mc.y = pos.y;
			
		}
		public function takeTurn(){
			trace("-- current weapon is "+currWeaponNum);
			target.takeDamage(getCurrWeapon().getPower());
			//animateWeapon();
			//
			target = null;
			active = true;
		}
		
		public function takeDamage(damage:int){
			currHealth = currHealth - damage;
			trace("- taking "+damage+" damage");
		}
		//
		public function reset(){
			weapons = new Vector.<Weapon>();
			currHealth = baseHealth;
			active = true;
			//give everyone a laser
			giveWeapon("laser beam");
			giveWeapon("laser beam II");
			giveWeapon("laser beam II");
		}
		//give this ship a weapon
		public function giveWeapon(weaponName:String){
			var newWeap = new Weapon(weaponName);
			weapons.push(newWeap);
			//trace("--giving "+weaponName);
		}
		//getters
		public function getTarget():Ship{
			return target;
		}
		public function getCurrWeapon():Weapon{
			return weapons[currWeaponNum];
		}
		public function getWeaponNum():int{
			return currWeaponNum;
		}
		public function getWeaponList():Vector.<Weapon>{
			return weapons;
		}
		public function hasTarget():Boolean{
			if(target != null){
				return true;
			}
			return false;
		}
		public function isActive():Boolean{
			return active;
		}
		public function getCurrHealth():Number{
			return currHealth;
		}
		public function getBaseHealth():Number{
			return baseHealth;
		}
		public function getMC():MovieClip{
			return mc;
		}
		public function getPos():Point{
			return pos;
		}
		//setters
		public function setCurrentWeaponNum(num:int){
			currWeaponNum = num;
		}
		public function setTarget(t:Ship){
			target = t;
		}
		public function setActive(a:Boolean){
			active = a;
		}
		public function setCombatNum(num:int){
			combatNum = num;
		}
		public function setVel(newVel:Point){
			velocity = newVel;
		}
		public function setPos(newPos:Point){
			pos = newPos;
		}
		public function setMC(movieclip:MovieClip){
			mc = movieclip;
		}
		
	}
	
}
