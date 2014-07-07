package  scripts{
	import flash.geom.Point;
	import flash.events.*;
	
	public class laser_beam_projectile{
		//var mc:MovieClip;
		var life:int;
		var maxLife:int;//how long before this disappears
		
		var origin:Point;
		var destination:Point;
		var speed:Number;
		var velocity:Point;
		
		public function laser_beam_projectile(o:Point, d:Point, spd:Number) {//
			trace("pooop");
			//mc = new laser_beam_projectile();
			life = 0;
			maxLife = 100;
			
			origin = o;
			destination = d;
			speed = spd;
			
			velocity = new Point(0,0);
			velocity.x = Math.cos(d.x - o.x)*spd;
			velocity.y = Math.sin(d.y - o.y)*spd;
						
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		public function update(e:Event):void{
			trace("quite " + velocity);
			this.x += velocity.x;
			this.y += velocity.y;

		}
		
		
	
	}
	
}
