package scripts{
	
	public class Weapon {
		var weaponName;
		
		var baseCooldown:int;
		var currCooldown:int;
		
		var basePower:Number;
		
		public function Weapon(weaponNameParam:String) {
			weaponName = weaponNameParam;
			switch(weaponName){
				case "laser beam":
					baseCooldown = 1;
					basePower = 1;
					break;
			}
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
