package {
	import scripts.*;
	import flash.events.*;
	import flash.display.*;
	import flash.geom.Point;
	import flash.utils.*;
	
	public class Main extends MovieClip{ 
		public var ships:Vector.<Ship> = new Vector.<Ship>();
		
		public function Main(){
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			stage.addEventListener(Event.ENTER_FRAME, main_loop);
			
			var s = createSmallShip();
			addChild(s.getMC());
		}
		
		function main_loop(e:Event):void {//main loop
			for(var i:int = 0;i<ships.length;i++){
				var s:Ship = ships[i];
				var sPos:Point = s.getPos();
				s.setPos(new Point(sPos.x+5, sPos.y+0));
				s.getMC().x = s.getPos().x;
				s.getMC().y = s.getPos().y;
			}
		}
		
		public function createSmallShip():Ship{
			var s:Ship = new Ship();
			s.setPos(new Point(100,100));
			s.setMC(new testSpaceship_1());
			s.reset();
			ships.push(s);
			return s;
		}
	}
}