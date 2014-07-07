package  scripts{
	import flash.geom.Point;
	import flash.events.*;
	import flash.display.MovieClip;
	import scripts.VoyageFunctions;
	
	public class Projectile{
		var mc:MovieClip;
		var life:int;
		var maxLife:int;//how long before this disappears
		var wait:int;//how long this should wait before being visible
		var fireInterval:int;//how long to wait in between shots
		
		var origin:Point;
		var destination:Point;
		var speed:Number;
		var velocity:Point;
		
		var rot:Number;//new width and height
		
		public function Projectile(o:Point, d:Point, spd:Number) {
			mc = new laser_beam_projectile();
			life = 0;
			maxLife = 100;
			wait = 0;
			fireInterval = 6;
			
			origin = new Point(o.x, o.y);
			destination = new Point(d.x, d.y);
			speed = spd;
			velocity = new Point(0,0);
			
			var spread = 15;
			destination.x = destination.x + VoyageFunctions.randomRange(-spread,spread);//give some variance
			destination.y = destination.y + VoyageFunctions.randomRange(-spread,spread);
			//trace(destination + "//" + d);
			
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
			//update
			life ++;
			if(wait > life){
				mc.alpha = 0;
			}else{
				mc.alpha = 1;
				mc.x += velocity.x;
				mc.y += velocity.y;
			}
			//stay invisible if need be
			//have a cool little burst at the beginning of animation
			if(life<2+wait){
				mc.height = 35;
				mc.width = 35;
			}else if(life == 2+wait){
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
		
		public function getFireInterval():int{
			return fireInterval;
		}
		public function setWait(w:int){
			wait = w;
			maxLife = 100+wait;
		}
		public function getMC():MovieClip{
			return mc;
		}
		
	
	}
	
}
