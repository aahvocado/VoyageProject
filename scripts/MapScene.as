package scripts {
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class MapScene {
		var travelShip:MovieClip;
		var travelPos:Point;
		
		public function MapScene() {
			resetPlayerShip();
		}
		
		public function resetPlayerShip():void{
			travelShip = new playerShip();
			travelPos = new Point(Main.stage.stageWidth/2,Main.stage.stageHeight/2);
			
		}
		public function initMode():void{
			Main.stage.addChild(travelShip);
		}
		
		//update if on the mode
		public function update():void{
			travelShip.x = travelPos.x;
			travelShip.y = travelPos.y;
		}
		
	}
	
}
