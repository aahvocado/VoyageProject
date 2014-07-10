package scripts {
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
		var playerSelections:Vector.<int> = new Vector.<int>();

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
			addListeners();
			//
			if(playerShips.length > 0){
				activeShip = 0;
			}
			
			switchToShip(activeShip);
		}
		public function addListeners(){
			var s:Ship;
			var i:int;
			var hb:MovieClip;//hitbox that the player clicks on 
			//make player clickable
			for(i = 0;i<playerShips.length;i++){
				s = playerShips[i];
				s.setCombatNum(i);
				hb = VoyageFunctions.createHitBox(s.getPos(), s.getMC().width, s.getMC().height, i);
				Main.stage.addChild(hb);
				hb.addEventListener(MouseEvent.CLICK, selectPlayerShip);
				hb.addEventListener(MouseEvent.MOUSE_OVER, rolloverPlayerShip);
				hb.addEventListener(MouseEvent.MOUSE_OUT, rolloutPlayerShip);
			}
			//check enemies
			for(i = 0;i<enemyShips.length;i++){
				s = enemyShips[i];
				s.setCombatNum(i);
				hb = VoyageFunctions.createHitBox(s.getPos(), s.getMC().width, s.getMC().height, i);
				Main.stage.addChild(hb);
				hb.addEventListener(MouseEvent.CLICK, selectEnemyShip);
				hb.addEventListener(MouseEvent.MOUSE_OVER, rolloverEnemyShip);
				hb.addEventListener(MouseEvent.MOUSE_OUT, rolloutEnemyShip);
			}
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
				//change selected skill to something useable
				if(!s.getCurrWeapon().isUseable()){
					switchToSkill(0);
				}
			}
			//update enemies
			for(i = 0;i<enemyShips.length;i++){
				s = enemyShips[i];
				animateWeapon(s);
				s.takeTurn();
				//change selected skill to something useable
				if(!s.getCurrWeapon().isUseable()){
					s.setCurrentWeaponNum(0);
				}
			}
			refreshShipUI();
			trace("turn resolution over ");
			combatMode = "animating";
		}
		//pick the current weapon type and create it
		function animateWeapon(s:Ship):void{
			var anim:MovieClip;
			switch (s.getCurrWeapon().getName()){
				case "laser beam":
					laserBeam(s.getPos(), s.getTarget().getPos(), s.getCurrWeapon());
					break;
				case "laser beam II":
					laserBeam(s.getPos(), s.getTarget().getPos(), s.getCurrWeapon());
					break;
				case "laser beam III":
					laserBeam(s.getPos(), s.getTarget().getPos(), s.getCurrWeapon());
					break;
			}
		}
		function laserBeam(origin:Point, destination:Point, w:Weapon):void{
			var a;
			for(var i:int;i<w.getShots();i++){
				a = new Projectile(origin, destination, 60);//
				a.setWait(i*a.getFireInterval()+VoyageFunctions.randomRange(0,7));
				Main.stage.addChild(a.getMC());
				effectsList.push(a);
				if(w.getName() == "laser beam III"){
					a.getMC().filters = [VoyageFunctions.skillGlow(0xFF3300,20)];
				}else{
					a.getMC().filters = [VoyageFunctions.skillGlow(0xFFCC66,10)];
				}
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
			if(s.getCurrWeapon().isUseable()){
				if(enemySelected != null && s.isActive()){
					s.setActive(false);
					s.setTarget(enemySelected);
					enemySelected = null;
					if(!allShipsReady()){
						nextActiveShip();
						refreshShipUI();
					}
				}
			}else{
				trace("--- error: cannon use this weapon!");
				switchToSkill(0);
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
		public function selectEnemyShip(e:MouseEvent):void{
			var s:Ship;
			if(combatMode == "player selection"){
				trace("- targeted enemy ");
				enemySelected = enemyShips[e.currentTarget.num];
				/*for(var i:int = 0;i<enemyShips.length;i++){
					s = enemyShips[i];
					if(e.currentTarget == s.getMC()){
						enemySelected = s;
						
						//return s;
					}
				}*/
			}
			//return null;
		}
		//mouse events on player ship
		public function rolloverPlayerShip(e:MouseEvent){
			targetingReticle.alpha = 1;
			targetingReticle.x = e.currentTarget.x;
			targetingReticle.y = e.currentTarget.y;
			var s:Ship = playerShips[e.currentTarget.num];
			s.getMC().filters = [VoyageFunctions.skillGlow(0x0000FF,15)];
			s.selected = true;
		}
		public function rolloutPlayerShip(e:MouseEvent){
			var s:Ship = playerShips[e.currentTarget.num];
			s.getMC().filters = null;
			s.selected = false
		}
		//mouse events on enemy ship
		public function rolloverEnemyShip(e:MouseEvent){
			targetingReticle.alpha = 1;
			targetingReticle.x = e.currentTarget.x;
			targetingReticle.y = e.currentTarget.y;
			var s:Ship = enemyShips[e.currentTarget.num];
			s.getMC().filters = [VoyageFunctions.skillGlow(0xFF0000,15)];
			s.selected = true;
		}
		public function rolloutEnemyShip(e:MouseEvent){
			var s:Ship = enemyShips[e.currentTarget.num];
			s.getMC().filters = null;
			s.selected = false;
		}
		//constant checking of certain ui elements
		public function updateUI(){
			var s:Ship;
			if(activeShip > -1){
				s = playerShips[activeShip];
				activeShipReticle.x = s.getPos().x;
				activeShipReticle.y = s.getPos().y;
				activeShipReticle.filters = [VoyageFunctions.skillGlow(0x3AD4E2,9)];
			}
		}
		//one time update of the Ship UI
		public function refreshShipUI():void{
			if(activeShipUI != null){
				Main.stage.removeChild(activeShipUI);
			}
			activeShipUI = new MovieClip();
			activeShipUI.x = 0; 
			activeShipUI.y = 0;
			drawShipCombatBar();
			Main.stage.addChild(activeShipUI);
		}
		//clicked on a player ship
		public function selectPlayerShip(e:Event){
			switchToShip(e.currentTarget.num);
		}
		
		//switch to a ship and refresh ui
		public function switchToShip(shipNumber:int):void{
			enemySelected = null;
			activeShip = shipNumber;
			refreshShipUI();
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
				var glowFilter:BitmapFilter = VoyageFunctions.skillGlow(0x4FE23A,9);
				if(s.getWeaponNum() == i){
					skillButton.filters = [glowFilter];
				}
				skillButton.num = i;
				skillButton.power_txt.text = ""+w.getPower();
				if(w.isUseable()){
					skillButton.cooldown_txt.text = "READY";
				}else{
					skillButton.cooldown_txt.text = "charging: "+w.getReverseCooldownString();
				}
				skillButton.addEventListener(MouseEvent.CLICK, selectSkill);
				activeShipUI.addChild(skillButton);
				//
				
				/*var powerText:TextField = VoyageFunctions.createTechnoTextField(newpos.x, newpos.y-65, 30, 75);
				powerText.text = w.getPower()+"";
				activeShipUI.addChild(powerText);*/
			}
		}
		public function selectSkill(e:MouseEvent):void{//num:int
			var w:Weapon = playerShips[activeShip].getWeaponList()[e.currentTarget.num];
			if(w.isUseable()){
				trace("- selected skill "+ e.currentTarget.num);
				switchToSkill(e.currentTarget.num);
			}else{
				trace("- skill  "+ e.currentTarget.num + " has cooldown "+w.getCooldownString());
			}
		}
		public function switchToSkill(num:int):void{
			var s:Ship = playerShips[activeShip];
			var w:Weapon = s.getWeaponList()[num];
			if(w.isUseable()){
				s.setCurrentWeaponNum(num);
				playerSelections[activeShip] = num;
				refreshShipUI();
			}else{
				trace("- skill  "+ num + " has cooldown "+w.getCooldownString());
			}
		}
		//initialize the combat ui
		public function initUI(){
			if(debugUI != null){
				Main.stage.removeChild(debugUI);
			}
			playerSelections = new Vector.<int>(playerShips.length);
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
			//Main.stage.addChild(targetingReticle);
			Main.stage.addChild(activeShipReticle);
		}
		//getters
		public function nextActiveShip(){
			activeShip ++;
			if(activeShip >= playerShips.length){
				activeShip = 0;
			}
			if(!playerShips[activeShip].isActive()){
				nextActiveShip();
			}
		}
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
