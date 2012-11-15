package pingPong.settings 
{
	import core.services.ServicesLocator;
	import core.scene.AbstractSceneController;
	import core.ui.KeyBoardController;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import pingPong.SharedObjectService;
	import starling.display.DisplayObjectContainer;
	import utils.GlobalUIContext;
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class PingPongSettingsController extends AbstractSceneController 
	{
		private var sceneView:SettingsView;
		private var shared:SharedObjectService;
		private var settingsModel:PingPongSettingsModel;
		private var keyContoller:KeyBoardController;
		
		public function PingPongSettingsController() 
		{
			super();
			
		}
		
		override protected function initilize():void 
		{
			super.initilize();
			
			shared = ServicesLocator.instance.getService(SharedObjectService) as SharedObjectService;
			settingsModel = shared.settings;
			
			if (settingsModel.playerName.length > 0)
				requestGamesInfo();
		}
		
		private function onEndTypingName(e:Event):void 
		{
			requestGamesInfo();
		}
		
		private function requestGamesInfo():void
		{
			
			return;
			var rq:URLRequest = new URLRequest('http://st.depositphotos.net:8080/ametisten-stat/game/games/' + settingsModel.playerName);
			var loader:URLLoader = new URLLoader(rq);
			loader.addEventListener(Event.COMPLETE, onStatisticRecived);
			
			if(sceneView)
				sceneView.freezeInput = true;
		}
		
		private function onStatisticRecived(e:Event):void 
		{
			var loader:URLLoader = e.target as URLLoader;
			var data:String = loader.data as String;
			var responce:Object = JSON.parse(data);
			var gameStatistic:Array = responce.gamesStatistic as Array;
			sceneView.freezeInput = false;
			
			var toPrint:Array = [' ', "W" ,'', "S", "R"]
			var postStirng:String = '';// toPrint.join(String.fromCharCode(9));
			
			for (var i:int = 0; i < gameStatistic.length; i++)
			{
				//statistic":{"winner":"shi","maxBallSpeed":8,"ricoshets":2}
				var line:Array = [i, gameStatistic[i].statistic.winner, gameStatistic[i].statistic.maxBallSpeed, gameStatistic[i].statistic.ricoshets];
				postStirng += String.fromCharCode(10);
				postStirng += line.join(String.fromCharCode(9));
			}
			
			sceneView.printStatistic(postStirng);
		}
		
		override protected function createUI():void 
		{
			super.createUI();
			
			
		}
		
		override public function deactivate():void 
		{
			shared.uploadSettings();
			keyContoller.destroy();
			GlobalUIContext.vectorUIContainer.removeChild(sceneView);
			
			isActivated = false;
		}
		
		override public function activate(instance:DisplayObjectContainer):void 
		{
			if (isActivated)
				return;
				
			sceneView = new SettingsView(settingsModel);
			
			keyContoller = new KeyBoardController(GlobalUIContext.vectorStage);
			keyContoller.registerKeyDownReaction(Keyboard.SPACE, onExit);
			
			currentViewContainer = instance;
			isActivated = true;
			GlobalUIContext.vectorUIContainer.addChild(sceneView);
			sceneView.visible = true;
			
			postInitilize();
		}
		
		private function postInitilize():void 
		{
			sceneView.addEventListener('exit', onExit);
			sceneView.addEventListener('endTypingName', onEndTypingName);
			
		}
		
		private function onExit(e:* = null):void 
		{
			exit();
		}
		
	}

}