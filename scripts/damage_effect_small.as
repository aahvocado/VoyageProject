package scripts{
	import flash.display.MovieClip;
  import flash.display.DisplayObjectContainer;
  import flash.display.DisplayObject;
	public class damage_effect_small extends MovieClip{
		var speed = 3;
		  var dir = Math.random() * 360;
		  var exist = 0;
		  var liveTo = 4;
		  var xSpeed = Math.cos(dir) * speed;
		  var ySpeed = Math.sin(dir) * speed;
		public function damage_effect_small(){  
    	this.addEventListener('enterFrame', frameListener);
	  }
  	private function frameListener(event):void{
     	exist++;
     	if(exist >= liveTo){
      	    this.killParticle();
    	}
 	 	}
    public function fadeParticle():void{
      this.alpha -= .15;
    }
	  public function killParticle(){
      this.removeEventListener('enterFrame', frameListener)
        // What do I need to put here to remove the particle?
        if (this.parent != null)
        {
            this.parent.removeChild(this);
         }
  	}
	}
}