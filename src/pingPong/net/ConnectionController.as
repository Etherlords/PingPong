package pingPong.net 
{
	import core.net.commands.UserStatusCommand;
	import core.net.ConnectionManager;
	import core.net.model.DataModel;
	import core.net.model.UserStatusCommandModel;
	import core.net.PeerConnection;
	import core.pingPong.GameIterationCommand;
	import core.pingPong.GameIterationCommandLogic;
	import core.pingPong.PingPongPlatformCommand;
	import core.pingPong.PingPongStatusCommandModel;
	import core.pingPong.PlatformCommandModel;
	import flash.net.registerClassAlias;
	import patterns.strategy.StrategyController;
	/**
	 * ...
	 * @author 
	 */
	public class ConnectionController 
	{
		private var connection:PeerConnection;
		private var connectionManager:ConnectionManager;
		private var connectionHandler:StrategyController;
		
		public function ConnectionController() 
		{
			initilize();
		}
		
		private function initilize():void 
		{
			
			registerClassAlias('DataModel', DataModel);
			registerClassAlias('PlatformCommandModel', PlatformCommandModel);
			registerClassAlias('PingPongStatusCommandModel', PingPongStatusCommandModel);
			registerClassAlias('GameIterationCommand', GameIterationCommand);
			
			
			connectionHandler = new StrategyController
			connectionHandler.crateNewStrategy(UserStatusCommandModel, new UserStatusCommand);
			//connectionHandler.crateNewStrategy(ChatCommandModel, new ChatMessageCommand())
			connectionHandler.crateNewStrategy(PlatformCommandModel, new PingPongPlatformCommand())
			connectionHandler.crateNewStrategy(PingPongStatusCommandModel, new StartRaundCommend())
			connectionHandler.crateNewStrategy(GameIterationCommand, new GameIterationCommandLogic())
			
			connection = new PeerConnection('multiuser/test12345');
			connectionManager = new ConnectionManager(connection, connectionHandler);
		}
		
		public function startRaund():void
		{
			connection.sendData(new PingPongStatusCommandModel);
		}
		
	}

}