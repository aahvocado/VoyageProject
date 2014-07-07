package  scripts{
	import flash.geom.Point;
	import flash.events.*;
	import flash.display.MovieClip;
	
	public class Projectile{
		var mc:MovieClip;
		var life:int;
		var maxLife:int;//how long before this disappears
		
		var origin:Point;
		var destination:Point;
		var speed:Number;
		var velocity:Point;
		
		public function Projectile(o:Point, d:Point, spd:Number) {
			mc = new laser_beam_projectile();
			life = 0;
			maxLife = 100;
			
			origin = o;
			destination = d;
			speed = spd;
			
			velocity = new Point(0,0);
			velocity.x = Math.cos(d.x - o.x)*spd;
			velocity.y = Math.sin(d.y - o.y)*spd;
						
			mc.x = o.x;
			mc.y = o.y;
						
		}
		public function update(e:Event){
			trace("quite " + velocity);
			mc.x += velocity.x;
			mc.y += velocity.y;

		}
		public function getMC():MovieClip{
			return mc;
		}
		
	
	}
	
}
