package scripts{
	
	public class Weapon {
		var weaponName;
		var shots:int;
		
		var baseCooldown:int;
		var currCooldown:int;
		
		var basePower:Number;
		
		public function Weapon(weaponNameParam:String) {
			weaponName = weaponNameParam;
			switch(weaponName){
				case "laser beam":
					baseCooldown = 0;
					basePower = 1;
					shots = 3;
					break;
				case "laser beam II":
					baseCooldown = 1;
					basePower = 2;
					shots = 4;
					break;
				case "laser beam III":
					baseCooldown = 2;
					basePower = 3;
					shots = 5;
					break;
			}
		}
		public function goOnCooldown(){
			currCooldown = baseCooldown;
		}
		public function cooldown(){
			if(currCooldown > 0){
				currCooldown --;
			}
		}
		public function init(){
			currCooldown = 0;
		}
		
		//getters
		public function getCurrCooldown():int{
			return currCooldown;
		}
		public function getCooldownString():String{
			return ""+currCooldown +"/"+baseCooldown;
		}
		public function getReverseCooldownString():String{
			return ""+(baseCooldown-currCooldown) +"/"+baseCooldown;
		}
		public function getShots():int{
			return shots;
		}
		public function getPower():int{
			return basePower;
		}
		public function isUseable():Boolean{
			if(currCooldown == 0){
				return true;
			}
			return false;
		}
		public function getName():String{
			return weaponName;
		}
	}
	
}
