﻿package scripts {
	import flash.text.TextField;
	import Main;
	import scripts.VoyageFunctions;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.filters.*;
	import flash.events.Event;

	public class Combat {
		//var Main.stage;//pass in the stage
		var combatMode:String;//is it the player's turn to pause it
		var debugUI:MovieClip;
		//var combatBarUI:MovieClip;
		//
		var playerShips:Vector.<Ship> = new Vector.<Ship>();
		var enemyShips:Vector.<Ship> = new Vector.<Ship>();
		var effectsList:Array = new Array();
		//
		var activeShipUI:MovieClip;//ship ui holder movieclip
		var skillButtonFunctions:Array;//holds the function for the current skill buttons
		var targetingReticle:MovieClip = new TargetingReticle_1();//targeting reticle movieclip
		var activeShipReticle:SelectionReticle_1 = new SelectionReticle_1();
		var activeShip:int = -1;
		
		var combatPause:int = 0;
		var defaultCombatPause:int = 20;
		
		var enemySelected:Ship = null;
		//constructor
		public function Combat(stageThing, playerGroup:Vector.<Ship>, enemyGroup:Vector.<Ship>) {
			Main.stage = stageThing;//main stage
			playerShips = playerGroup;
			enemyShips = enemyGroup;
			combatMode = "player selection";
			//
			initUI();
			var s:Ship;
			//
			if(playerShips.length > 0){
				activeShip = 0;
			}
			//check enemies
			for(var i:int = 0;i<enemyShips.length;i++){
				s = enemyShips[i];
				s.setCombatNum(i);
				s.getMC().addEventListener(MouseEvent.CLICK, selectEnemyShip);
				s.getMC().addEventListener(MouseEvent.MOUSE_OVER, rolloverEnemyShip);
			}
			switchToShip(activeShip);
		}
		//called by main to constantly update this
		public function update(){
			switch (combatMode){
				case "player selection":
					animationUpdate();
					playerSelecting();
					enemySelecting();
					break;
				case "resolve turn":
					resolveTurn();
					break;
				case "animating":
					if(combatPause > 0){
						combatPause --;
					}else if(combatPause == 0){
						trace("done animating");
						combatMode = "player selection";
					}
					animationUpdate();
					break;
			}
			var i:int;
			var s:Ship;
			//update players
			for(i = 0;i<playerShips.length;i++){
				s = playerShips[i];
				s.update();
			}
			//update enemies
			for(i = 0;i<enemyShips.length;i++){
				s = enemyShips[i];
				s.update();
			}
			//
			updateUI();
			
		}
		//after player is done and all targets are made
		public function resolveTurn(){
			trace("resolving turn");
			combatPause = defaultCombatPause;
			var s:Ship;
			var i:int;
			//update players
			for(i = 0;i<playerShips.length;i++){
				s = playerShips[i];
				trace("- player using "+s.getCurrWeapon().getName());
				animateWeapon(s);
				s.takeTurn();
			}
			//update enemies
			for(i = 0;i<enemyShips.length;i++){
				s = enemyShips[i];
				animateWeapon(s);
				s.takeTurn();
			}
			trace("turn resolution over");
			initUI();
			combatMode = "animating";
		}
		//pick the current weapon type and create it
		function animateWeapon(s:Ship){
			switch (s.getCurrWeapon().getName()){
				case "laser beam":
					laserBeam(s.getPos(), s.getTarget().getPos(), s.getCurrWeapon());
					break;
				case "laser beam II":
					laserBeam(s.getPos(), s.getTarget().getPos(), s.getCurrWeapon());
					break;
			}
		}
		function laserBeam(origin:Point, destination:Point, w:Weapon){
			var a;
			for(var i:int;i<w.getShots();i++){
				a = new Projectile(origin, destination, 60);//
				a.setWait(i*a.getFireInterval()+VoyageFunctions.randomRange(0,7));
				Main.stage.addChild(a.getMC());
				effectsList.push(a);
			}
		}
		//animate stuff
		function animationUpdate():void{
			for(var i=0;i<effectsList.length;i++){
				var e;
				e = effectsList[i];
				e.update();
				if(e.isDead()){
					Main.stage.removeChild(e.getMC());
					effectsList.splice(i,1);
					animationUpdate();
					break;
				}
			}

		}
		//player's turn where they select their weapons and targets
		public function playerSelecting(){
			var s:Ship;
			//check for targeting
			s = playerShips[activeShip];
			if(enemySelected != null && s.isActive()){
				s.setActive(false);
				s.setTarget(enemySelected);
				enemySelected = null;
			}
			//check if all player ships have a target
			if(allShipsReady()){
				combatMode = "resolve turn";
			}
		}
		//weird ai to select targets for the enemy
		public function enemySelecting(){
			for(var i = 0;i<enemyShips.length;i++){
				var s:Ship = enemyShips[i];
				if(!s.hasTarget()){
					s.setTarget(playerShips[0]);
					s.setActive(false);
				}
			}
		}

		//select an enemy ship
		public function selectEnemyShip(e:MouseEvent){
			var s:Ship;
			if(combatMode == "player selection"){
				for(var i:int = 0;i<enemyShips.length;i++){
					s = enemyShips[i];
					if(e.currentTarget == s.getMC()){
						enemySelected = s;
						trace("- targeted enemy ");
						//return s;
					}
				}
			}
			//return null;
		}
		//
		public function rolloverEnemyShip(e:MouseEvent){
			targetingReticle.alpha = 1;
			targetingReticle.x = e.currentTarget.x;
			targetingReticle.y = e.currentTarget.y;
		}
		public function updateUI(){
			var s:Ship;
			if(activeShip > -1){
				s = playerShips[activeShip];
				activeShipReticle.x = s.getPos().x;
				activeShipReticle.y = s.getPos().y;
				activeShipReticle.filters = [VoyageFunctions.skillGlow(0x3AD4E2)];
			}
		}
		public function switchToShip(shipNumber){
			if(activeShipUI != null){
				Main.stage.removeChild(activeShipUI);
			}
			activeShipUI = new MovieClip();
			activeShipUI.x = 0; 
			activeShipUI.y = 0;
			drawShipCombatBar();
			Main.stage.addChild(activeShipUI);
		}
		public function drawShipCombatBar(){
			trace("drawing combat bar");
			var i:int;
			var s:Ship = playerShips[activeShip];
			var currShipDisplay:TextField = VoyageFunctions.createCustomTextField(40, 600, 220, 350);
			currShipDisplay.text = " Ship " + " ||| hp: "+s.getCurrHealth()+"/"+s.getBaseHealth()+"\n";
			activeShipUI.addChild(currShipDisplay);
			//draw skill icons
			var pos = new Point(280, 675);
			skillButtonFunctions = new Array(s.getWeaponList().length);
							

			for(i=0;i<s.getWeaponList().length;i++){
				var newpos:Point = new Point((pos.x + i*195), pos.y);
				var w:Weapon = s.getWeaponList()[i];
				var skillButton:MovieClip = new skill_icon();
				skillButton.x = newpos.x;
				skillButton.y = newpos.y;
				var glowFilter:BitmapFilter = VoyageFunctions.skillGlow(0x4FE23A);
				if(s.getWeaponNum() == i){
					skillButton.filters = [glowFilter];
				}
				skillButton.num = i;
				skillButton.addEventListener(MouseEvent.CLICK, selectSkill);
						/*skillButton.addEventListener("click", 
													function(){
														trace(this);
														selectSkill(this.num);
													},
											false);*/
				activeShipUI.addChild(skillButton);
				//
				var powerText:TextField = VoyageFunctions.createTechnoTextField(newpos.x-175/2, newpos.y-65, 175, 75);
				powerText.text = w.getPower()+"";
				activeShipUI.addChild(powerText);
			}
		}
		public function selectSkill(e:MouseEvent){//num:int
			trace("selected skill "+ e.currentTarget.num);
			var s:Ship = playerShips[activeShip];
			s.setCurrentWeaponNum(e.currentTarget.num);
			trace(s.getCurrWeapon().getName());
			switchToShip(activeShip);
		}
		//initialize the combat ui
		public function initUI(){
			if(debugUI != null){
				Main.stage.removeChild(debugUI);
			}
			debugUI = new MovieClip();
			var s:Ship;
			var i:int;
			//basic debug text
			//--player
			var playerHealthDisplay:TextField = VoyageFunctions.createCustomTextField(50, 10, 220, 350);
			playerHealthDisplay.text = "";
			
			for(i = 0;i<playerShips.length;i++){
				s = playerShips[i];
				playerHealthDisplay.text = playerHealthDisplay.text + " Ship "+i+ " ||| hp: "+s.getCurrHealth()+"/"+s.getBaseHealth()+"\n";
			}
			//--enemy
			var enemyHealthDisplay:TextField = VoyageFunctions.createCustomTextField(950, 10, 220, 350);
			enemyHealthDisplay.text = "";
			
			for(i = 0;i<enemyShips.length;i++){
				s = enemyShips[i];
				enemyHealthDisplay.text = enemyHealthDisplay.text + " Ship "+i+ " ||| hp: "+s.getCurrHealth()+"/"+s.getBaseHealth()+"\n";
			}
			
			debugUI.addChild(playerHealthDisplay);
			debugUI.addChild(enemyHealthDisplay);
			Main.stage.addChild(debugUI);
			//active ship selector
			targetingReticle.alpha = 0;
			Main.stage.addChild(targetingReticle);
			Main.stage.addChild(activeShipReticle);
		}
		//getters
		//--checks if all ships have made their target and can fire
		public function allShipsReady():Boolean{
			for(var i=0;i<playerShips.length;i++){
				var s:Ship = playerShips[i];
				if(!s.isActive() && s.hasTarget()){
					
				}else{
					return false;
				}
			}
			return true;
		}
	}
	
}
