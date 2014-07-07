package  scripts{
	import flash.geom.Point;
	import flash.events.*;
	import flash.display.MovieClip;
	import scripts.VoyageFunctions;
	
	public class Projectile{
		var mc:MovieClip;
		var life:int;
		var maxLife:int;//how long before this disappears
		
		var origin:Point;
		var destination:Point;
		var speed:Number;
		var velocity:Point;
		
		var rot:Number;//new width and height
		
		public function Projectile(o:Point, d:Point, spd:Number) {
			mc = new laser_beam_projectile();
			life = 0;
			maxLife = 100;

			
			origin = new Point(o.x, o.y);
			destination = new Point(d.x, d.y);
			speed = spd;
			velocity = new Point(0,0);
			
			var spread = 15;
			destination.x = destination.x + VoyageFunctions.randomRange(-spread,spread);//give some variance
			destination.y = destination.y + VoyageFunctions.randomRange(-spread,spread);
			trace(destination + "//" + d);
			
			var dx = destination.x - origin.x;
			var dy = destination.y - origin.y;
			var angle = Math.atan2(dy,dx)/Math.PI*180;
			mc.rotation = angle;
			rot = angle;
									
			mc.x = origin.x;
			mc.y = origin.y;
			
			velocity.x = Math.cos(angle/180*Math.PI)*spd;
			velocity.y = Math.sin(angle/180*Math.PI)*spd;		
		}
		public function update(){
			mc.x += velocity.x;
			mc.y += velocity.y;
			life ++;
			if(life<2){
				mc.height = 35;
				mc.width = 35;
			}else if(life == 2){
				mc.rotation = 0;
				mc.height = 5;
				mc.width = 80;
				mc.rotation = rot;
			}
		}
		
		public function isDead():Boolean{
			var dx = destination.x - mc.x;
			var dy = destination.y - mc.y;
			if(Math.abs(dx) < speed/2 && Math.abs(dy) < speed/2){
				return true;
			}else if(life>maxLife){
				return true;
			}
			return false;
		}
		public function getMC():MovieClip{
			return mc;
		}
		
	
	}
	
}
