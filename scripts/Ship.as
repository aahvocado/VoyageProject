package scripts {
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class Ship {
		//data
		var pos:Point;
		var mc:MovieClip;//movieclip parent
		
		var velocity:Point;
		//stats
		var baseHealth:Number;
		var currHealth:Number;
		
		var equipment:Array;
		
		public function Ship() {
			velocity = new Point(0,0);
		}
		public function update(){
			pos.x += velocity.x;
			pos.y += velocity.y;
			
			mc.x = pos.x;
			mc.y = pos.y;
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
