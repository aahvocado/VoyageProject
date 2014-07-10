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
		public var selected:Boolean;
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
			if(hasTarget() && !selected){
				mc.filters = [VoyageFunctions.skillGlow(0x00FF00,7)];
			}else if(!hasTarget() && !selected){
				mc.filters = null;
			}
		}
		//execute this ship's turn
		public function takeTurn(){
			//trace("-- current weapon is "+currWeaponNum);
			if(getCurrWeapon().isUseable()){
				target.takeDamage(getCurrWeapon().getPower());
				cooldownAllWeapons();
				getCurrWeapon().goOnCooldown();
				//trace("TEST "+getCurrWeapon().getCooldownString());
			}else{
				trace("---error: should not be able to use this weapon");
			}
			target = null;
			active = true;
		}
		//take damage
		public function takeDamage(damage:int){
			currHealth = currHealth - damage;
			trace("- taking "+damage+" damage");
		}
		//lower the cooldown on all weapons by one
		public function cooldownAllWeapons(){
			for(var i=0;i<weapons.length;i++){
				weapons[i].cooldown();
			}
		}
		//
		public function reset(){
			weapons = new Vector.<Weapon>();
			currHealth = baseHealth;
			active = true;
			//give everyone a laser
			giveWeapon("laser beam");
			giveWeapon("laser beam II");
			giveWeapon("laser beam III");
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
