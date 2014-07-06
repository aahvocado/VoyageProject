package scripts {
	import flash.text.TextField;
	import scripts.VoyageFunctions;
	
	public class Combat {
		var mainStage;//pass in the stage
		var combatPause:Boolean;//is it the player's turn to pause it
		//
		var playerShips:Vector.<Ship> = new Vector.<Ship>();
		var enemyShips:Vector.<Ship> = new Vector.<Ship>();
		var i;//lazy 
		
		public function Combat(stageThing, playerGroup:Vector.<Ship>, enemyGroup:Vector.<Ship>) {
			mainStage = stageThing;//main stage
			playerShips = playerGroup;
			enemyShips = enemyGroup;
			//
			initUI();
		}
		//initialize the combat ui
		public function initUI(){
			var s:Ship;

			//player
			var playerHealthDisplay:TextField = VoyageFunctions.createCustomTextField(50, 10, 220, 350);
			playerHealthDisplay.text = "";
			
			for(i = 0;i<playerShips.length;i++){
				s = playerShips[i];
				playerHealthDisplay.text = playerHealthDisplay.text + " Ship "+i+ " ||| hp: "+s.getCurrHealth()+"/"+s.getBaseHealth()+"\n";
			}
			//enemy
			var enemyHealthDisplay:TextField = VoyageFunctions.createCustomTextField(950, 10, 220, 350);
			enemyHealthDisplay.text = "";
			
			for(i = 0;i<enemyShips.length;i++){
				s = enemyShips[i];
				enemyHealthDisplay.text = enemyHealthDisplay.text + " Ship "+i+ " ||| hp: "+s.getCurrHealth()+"/"+s.getBaseHealth()+"\n";
			}
			
			mainStage.addChild(playerHealthDisplay);
			mainStage.addChild(enemyHealthDisplay);

		}
		//called by main to constantly update this
		public function update(){
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
	}
	
}
