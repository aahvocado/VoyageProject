package scripts {
	import flash.display.MovieClip;
	import flash.geom.Point;
	import scripts.VoyageFunctions;
	
	//this class is just an object on the map
	public class MapSpace {
		var mc:MovieClip;
		var pos:Point;
		var size:Number;
		public function MapSpace() {
			mc = new testPlanet_1();
			size = VoyageFunctions.randomRange(30,50);
			
			pos = new Point(VoyageFunctions.randomRange(0,1200), VoyageFunctions.randomRange(0,800));
			mc.height = size;
			mc.width = size;
			
			mc.x = pos.x;
			mc.y = pos.y;
		}
		
		public function update(){
			
		}
		//getter
		public function getPos(){
			return pos;
		}
		public function getMC(){
			return mc;
		}
	}
	
}
