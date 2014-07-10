package scripts {
	import flash.text.*;
	import flash.filters.*;
	import fl.motion.Color;
	import flash.geom.Point;
	import flash.display.MovieClip;

	public class VoyageFunctions {
		
		public function VoyageFunctions() {
			// constructor code
		}
		public static function createHitBox(pos:Point, w:Number, h:Number, n:Number):MovieClip{
			var hb:MovieClip = new hitbox();
			hb.x = pos.x;
			hb.y = pos.y;
			hb.width = w;
			hb.height = h;
			hb.num = n;
			if(Main.debug == false){
				hb.alpha = 0;
			}
			return hb;
		}
		//picks a random number in this range
		public static function randomRange(minNum:Number, maxNum:Number):Number {
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
		public static function skillGlow(c:int, size:Number):BitmapFilter{
			return new GlowFilter(c,.5,size,size,3)
		}
		//creates a text field
		public static function createTechnoTextField(x:Number, y:Number, width:Number, height:Number):TextField {
			var result:TextField = new TextField();
			result.x = x;
			result.y = y;
			result.width = width;
			result.height = height;
			
			result.selectable = false;
			var format:TextFormat = new TextFormat();
            format.font = "Patinio Rotulo";
            format.color = 0xFFFFFF;
            format.size = 55;
			format.align = TextFormatAlign.CENTER;

            result.defaultTextFormat = format;

			return result;
        }
		//creates a text field
		public static function createCustomTextField(x:Number, y:Number, width:Number, height:Number):TextField {
			var result:TextField = new TextField();
			result.x = x;
			result.y = y;
			result.width = width;
			result.height = height;
			
			result.selectable = false;
			var format:TextFormat = new TextFormat();
            format.font = "Calibri";
            format.color = 0xFFFFFF;
            format.size = 20;

            result.defaultTextFormat = format;

			return result;
        }

	}
	
}
