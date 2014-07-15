package scripts {
	import flash.text.*;
	import flash.filters.*;
	import fl.motion.Color;
	import flash.geom.*;
	import flash.display.*;

	public class VoyageFunctions {
		
		public function VoyageFunctions() {
			// constructor code
		}
		//takes in a percent chance and rolls to determine if it hit within that range
		public static function percentChance(pc:Number):Boolean{
			var n:Number = Math.random()*100;
			//trace(pc+"/"+n);
			if(pc>=n){
				return true;
			}
			return false;
			
		}
		//creates a vertical hp bar
		public static function createHPBar(pos:Point, w:Number, h:Number, currHP:Number, maxHP:Number):MovieClip{
			var hpbar:MovieClip = new MovieClip();//main movieclip
			var hpPercent:Number = currHP/maxHP;
			
			var maxhpbar:Sprite = new Sprite();
			maxhpbar.graphics.beginFill(0x666666, 1);
			maxhpbar.graphics.drawRect(pos.x, pos.y, w, h);
			maxhpbar.graphics.endFill();
			
			var currhpbar:Sprite = new Sprite();//graphics
			currhpbar.graphics.beginFill(0x61C995, 1);
			var yOffset:Number = h*(1-hpPercent);
			currhpbar.graphics.drawRect(pos.x, pos.y+yOffset, w, h*hpPercent);
			currhpbar.graphics.endFill();
			
			var currShipDisplay:TextField = VoyageFunctions.createCustomTextField(pos.x, pos.y, 220, 350);//text
			currShipDisplay.text = currHP+"/"+maxHP+"\n";// Ship " + " ||| "hp: "+
			
			hpbar.addChild(maxhpbar);
			hpbar.addChild(currhpbar);
			hpbar.addChild(currShipDisplay);
			return hpbar;
		}
		//creates a hitbox which contains a number, typically used to match the id with ship number
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
