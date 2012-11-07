package ui 
{
	import core.view.skin.Skin;
	
	/**
	 * ...
	 * @author 
	 */
	public class DetectorShape extends Skin 
	{

	
		public function DetectorShape() 
		{
			
			graphics.lineStyle(2, 0xAAAAAA);
			graphics.beginFill(0xDDDDDD);
			graphics.drawRect(0, 0, 4, 480);
			
		}
		
		
	}

}