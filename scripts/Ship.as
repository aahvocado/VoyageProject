package scripts {
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class Ship {
		//data
		var pos:Point;
		var mc:MovieClip;//movieclip parent
		//stats
		var baseHealth:Number;
		var currHealth:Number;
		
		var equipment:Array;
		
		public function Ship() {
			// constructor code
		}
		public function reset(){
			currHealth = baseHealth;
		}
		//getters
		public function getMC(){
			return mc;
		}
		public function getPos(){
			return pos;
		}
		//setters
		public function setPos(newPos:Point){
			pos = newPos;
		}
		public function setMC(movieclip:MovieClip){
			mc = movieclip;
		}
		
	}
	
}
