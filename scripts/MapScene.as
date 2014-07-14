package scripts {
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.events.*;
	
	public class MapScene {
		var travelShip:MovieClip;
		var travelPos:Point;
		var spaceList:Vector.<MapSpace> = new Vector.<MapSpace>();
		
		public function MapScene() {
			resetPlayerShip();
			spaceList = new Vector.<MapSpace>();
			initSpace();
		}
		

		public function initSpace():void{
			var TESTNUMBER:int = 5;
			var ms:MapSpace;
			for(var i=0;i<TESTNUMBER;i++){
				ms = new MapSpace();
				spaceList.push(ms);
			}
		}
		public function selectSpace(e:Event):void{
			var spaceNum = e.currentTarget.num;
			
		}
		//addchild on to the stage
		public function drawSpace():void{
			var ms:MapSpace;
			for(var i=0;i<spaceList.length;i++){
				ms = spaceList[i];
				Main.stage.addChild(ms.getMC());
			}
		}
		public function addListeners():void{
			var ms:MapSpace;
			var hb:MovieClip;//hitbox that the player clicks on 
			for(var i=0;i<spaceList.length;i++){
				ms = spaceList[i];
				hb = VoyageFunctions.createHitBox(ms.getPos(), ms.getMC().width, ms.getMC().height, i);
				Main.stage.addChild(hb);
				hb.addEventListener(MouseEvent.CLICK, selectSpace);
				hb.addEventListener(MouseEvent.MOUSE_OVER, rolloverSpace);
				hb.addEventListener(MouseEvent.MOUSE_OUT, rolloutSpace);
			}
		}
		//update if on the mode
		public function update():void{
			travelShip.x = travelPos.x;
			travelShip.y = travelPos.y;
		}
		//mouse events on planet
		public function rolloverSpace(e:MouseEvent){
			var ms:MapSpace = spaceList[e.currentTarget.num];
			ms.getMC().filters = [VoyageFunctions.skillGlow(0x7CD4E9,15)];
		}
		public function rolloutSpace(e:MouseEvent){
			var ms:MapSpace = spaceList[e.currentTarget.num];
			ms.getMC().filters = null;
		}
		//called when the scene switches this mode
		public function initMode():void{
			drawSpace();
			addListeners();
			Main.stage.addChild(travelShip);
		}
		public function endMode():void{
			//removeListeners();_
			Main.stage.removeChild(travelShip);
		}
		public function resetPlayerShip():void{
			travelShip = new playerShip();
			travelPos = new Point(Main.stage.stageWidth/2,Main.stage.stageHeight/2);
		}
		
	}
	
}
