package scripts {
	import flash.text.*;

	public class VoyageFunctions {

		public function VoyageFunctions() {
			// constructor code
		}
		//picks a random number in this range
		public static function randomRange(minNum:Number, maxNum:Number):Number {
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
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
