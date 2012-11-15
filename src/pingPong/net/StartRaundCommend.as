package pingPong.net 
{
	import core.game.GameProcessor;
	import core.net.commands.AbstractNetCommand;
	import core.services.ServicesLocator;
	
	/**
	 * ...
	 * @author 
	 */
	public class StartRaundCommend extends AbstractNetCommand 
	{
		private var _gameProcessor:GameProcessor;
		public function get gameProcessor():GameProcessor 
		{
			if (!_gameProcessor)
				_gameProcessor = ServicesLocator.instance.getService(GameProcessor) as GameProcessor;
			
			return _gameProcessor;
		}
		public function StartRaundCommend() 
		{
			super();
			
		}
		
		public function execute(data:Object):void
		{
			gameProcessor.startRaund();
		}
		
	}

}