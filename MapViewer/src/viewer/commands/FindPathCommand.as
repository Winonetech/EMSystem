package viewer.commands
{
	
	/**
	 * 
	 * 寻路。
	 * 
	 */
	
	
	public final class FindPathCommand extends _InternalCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function FindPathCommand($serial:String)
		{
			super();
			
			serial = $serial;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function execute():void
		{
			commandStart();
			
			findPath();
			
			commandEnd();
		}
		
		
		/**
		 * @private
		 */
		private function findPath():void
		{
			view.mapView.find(serial, true);
		}
		
		
		/**
		 * @private
		 */
		private var serial:String;
		
	}
}