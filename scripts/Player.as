package scripts{
	import flash.geom.Point;
	public class Player {
		
		public var shiplist:Vector.<Ship>;
		
		public function Player() {
			shiplist = new Vector.<Ship>();
		}

		//name of custom ship, type of ship (size etc), health, which side the ship is on (default player)
		public function addShip(Name:String, shipType:String, baseHealth:int, loyalty:String):Ship{
			var s:Ship;
			switch(shipType){//create movieclip type
				case "small":
					s = new Ship(Name, new testSpaceship_1(), 5);
					s.setPos(new Point(225+VoyageFunctions.randomRange(-50,50),225+VoyageFunctions.randomRange(-150,150)));
					break;
			}
			if(loyalty == "enemy"){
				s = new Ship(Name, new testESpaceship_1(), 4);
				s.getMC().scaleX *= -1;
				s.setPos(new Point(875+VoyageFunctions.randomRange(-50,50),225+VoyageFunctions.randomRange(-150,150)));
			}
			shiplist.push(s);
			return s;
		}
		
		public function getShipList():Vector.<Ship>{
			return shiplist;
		}
	}
	
}
