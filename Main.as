package {
	import scripts.*;
	import flash.events.*;
	import flash.display.*;
	import flash.geom.Point;
	import flash.utils.*;
	import flash.sampler.Sample;
	import flash.errors.ScriptTimeoutError;
	import flash.display3D.IndexBuffer3D;

	public class Main extends MovieClip{
		var mode = "combat";//current mode (state machine)
		public static var stage:Stage;
		public static var debug:Boolean = false;
		public static var switchMode:String = null;
		//
		var player:Player = new Player();
		var enemy:Player = new Player();
		//state machine stuffs
		var combatScript:Combat;
		var mapScript:MapScene;
		//main constructor
		public function Main(){
			Main.stage = stage;
			//add listeners
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			stage.addEventListener(Event.ENTER_FRAME, main_loop);
			initTest();	
			//
			switchToMode("map");
		}
		//constant loop
		function main_loop(e:Event):void {//main loop
			if(switchMode != null){
				switchToMode(switchMode);
				switchMode = null;
			}
			switch(mode){
				case "combat":
					combatScript.update();
					break;
				case "map":
					mapScript.update();
					break;
			}	
		}
		public function switchToMode(m:String){
			switch(m){
				case "combat":
					gotoAndStop(1,"Combat");
					enemy = mapScript.getEnemy();
					combatScript = new Combat(player, enemy);
					combatScript.initMode();
					break;
				case "map":
					gotoAndStop(1,"Map");
					mapScript.initMode();
					break;
			}	
			mode = m;
		}
		public function initTest(){
			var i:int;
			var ps:Ship;
			var es:Ship;
			//test
			ps = player.addShip("test", "small", 5, "player");
			es = enemy.addShip("enemy", "small", 5, "enemy");
			
			combatScript = new Combat(player, enemy);
			mapScript = new MapScene();
			initInterface();
			
		}

		//interface
		public function initInterface(){
			var shipSymb = new test_ship_symbol();
			shipSymb.x = 90;
			shipSymb.y = 525;
			addChild(shipSymb);
		}
	}
}