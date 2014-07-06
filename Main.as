package {
	import scripts.*;
	import flash.events.*;
	import flash.display.*;
	import flash.geom.Point;
	import flash.utils.*;
	import flash.sampler.Sample;
	import flash.errors.ScriptTimeoutError;
	
	public class Main extends MovieClip{
		//
		public var playerShips:Vector.<Ship> = new Vector.<Ship>();
		public var enemyShips:Vector.<Ship> = new Vector.<Ship>();
		public var i;//lazy 
		//
		var combatScript:Combat;
		//testy stuff
		var playerShipCountTest = 1;
		//main constructor
		public function Main(){
			//add listeners
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			stage.addEventListener(Event.ENTER_FRAME, main_loop);
			//set up combat
			combatScript = new Combat(stage);
			//create ui
			
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
		}

		//constant loop
		function main_loop(e:Event):void {//main loop
			var s:Ship;
			//update players
			for(var i:int = 0;i<playerShips.length;i++){
				s = playerShips[i];
				s.update();
			}
			//update enemies
			for(var i:int = 0;i<enemyShips.length;i++){
				s = enemyShips[i];
				s.update();
			}
		}
		
		//interface
		
		public function initInterface(){
			var shipSymb = new test_ship_symbol();
			shipSymb.x = 90;
			shipSymb.y = 525;
			addChild(shipSymb);
		}
		//creates a small ship for testing right now
		public function createSmallShip(group:String):Ship{
			var s:Ship = new Ship();
			s.setVel(new Point(0,0));
			s.reset();
			switch(group){
				case "player":
					s.setMC(new testSpaceship_1());
					s.setPos(new Point(225,225));
					playerShips.push(s);
					break;
				case "enemy":
					s.setMC(new testESpaceship_1());
					s.setPos(new Point(925,225));
					enemyShips.push(s);
					break;
			}
			trace("made "+group+" ship");
			return s;
		}
	}
}