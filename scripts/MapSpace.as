package scripts {
	import flash.display.MovieClip;
	import flash.geom.Point;
	import scripts.VoyageFunctions;
	
	//this class is just an object on the map
	public class MapSpace {
		//general data
		var mc:MovieClip;
		var pos:Point;
		var size:Number;
		//specific data
		var enemy:Player = null;
		public function MapSpace() {
			mc = new testPlanet_1();
			size = VoyageFunctions.randomRange(30,90);
			
			pos = new Point(VoyageFunctions.randomRange(0,1200), VoyageFunctions.randomRange(0,800));
			mc.height = size;
			mc.width = size;
			
			mc.x = pos.x;
			mc.y = pos.y;
			
			if(VoyageFunctions.percentChance(100)){
				enemy = new Player();
				enemy.addShip("enemy ship","small", 3, "enemy");
				if(VoyageFunctions.percentChance(15.55)){
					enemy.addShip("enemy ship","small", 3, "enemy");
				}
				if(VoyageFunctions.percentChance(15.55)){
					enemy.addShip("enemy ship","small", 3, "enemy");
				}
			}
		}
		
		public function update(){
			
		}
		//getter
		public function hasEnemy():Boolean{
			if(enemy != null){
				return true;
			}
			
			return false;
		}
		public function getEnemy():Player{
			return enemy;
		}
		public function getPos(){
			return pos;
		}
		public function getMC(){
			return mc;
		}
	}
	
}
