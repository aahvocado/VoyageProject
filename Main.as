package {
	import scripts.*;
	import flash.events.*;
	import flash.display.*;
	import flash.geom.Point;
	import flash.utils.*;
	import flash.sampler.Sample;
	import flash.errors.ScriptTimeoutError;

	public class Main extends MovieClip{
		var mode = "combat";//current mode
		public static var stage:Stage;
		//
		var playerShips:Vector.<Ship> = new Vector.<Ship>();
		var enemyShips:Vector.<Ship> = new Vector.<Ship>();
		//
		var combatScript:Combat;
		//testy stuff
		var playerShipCountTest = 1;
		//main constructor
		public function Main(){
			Main.stage = stage;
			//add listeners
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			stage.addEventListener(Event.ENTER_FRAME, main_loop);
			
			initTest();			
		}
		public function initTest(){
			var i:int;
			//test
			for(i=0;i<playerShipCountTest;i++){
				createSmallShip("player");
			}
			createSmallShip("enemy");
			
			//less test
			var s:Ship;
			for(i=0;i<playerShips.length;i++){
				s = playerShips[i];
				addChild(s.getMC());
			}
			for(i=0;i<enemyShips.length;i++){
				s = enemyShips[i];
				s.getMC().scaleX *= -1;
				addChild(s.getMC());
			}
			initInterface();
			//set up combat
			combatScript = new Combat(stage, playerShips, enemyShips);
		}

		//constant loop
		function main_loop(e:Event):void {//main loop
			switch(mode){
				case "combat":
					combatScript.update();
					break;
			}			
		}
		//aaa
		//public static function addProjectile():Projectile{
			
		//}
		//interface
		public function initInterface(){
			var shipSymb = new test_ship_symbol();
			shipSymb.x = 90;
			shipSymb.y = 525;
			addChild(shipSymb);
		}
		//creates a small ship for testing right now
		public function createSmallShip(group:String):Ship{
			var s:Ship;
			switch(group){
				case "player":
					s = new Ship(new testSpaceship_1(), new Point(225+VoyageFunctions.randomRange(-50,50),225+VoyageFunctions.randomRange(-150,150)), 5);
					playerShips.push(s);
					break;
				case "enemy":
					s = new Ship(new testESpaceship_1(), new Point(925+VoyageFunctions.randomRange(-50,50),225+VoyageFunctions.randomRange(-150,150)), 3);
					enemyShips.push(s);
					break;
			}
			//s.giveWeapon("laser beam");
			s.setVel(new Point(0,0));
			s.reset();
			trace("made "+group+" ship");
			return s;
		}
	}
}