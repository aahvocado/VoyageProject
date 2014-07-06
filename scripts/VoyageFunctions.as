package scripts {
	import flash.text.*;

	public class VoyageFunctions {

		public function VoyageFunctions() {
			// constructor code
		}
		
		public static function createCustomTextField(x:Number, y:Number, width:Number, height:Number):TextField {
			var result:TextField = new TextField();
			result.x = x;
			result.y = y;
			result.width = width;
			result.height = height;
			
			var format:TextFormat = new TextFormat();
            format.font = "Calibri";
            format.color = 0xFFFFFF;
            format.size = 20;

            result.defaultTextFormat = format;

			return result;
        }

	}
	
}
