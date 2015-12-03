package viewer.commands
{
	
	/**
	 * 
	 * 设定当前位置。
	 * 
	 */
	
	
	public final class SetInitializePositionCommand extends _InternalCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function SetInitializePositionCommand($serial:String)
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
			
			setInitializePosition();
			
			commandEnd();
		}
		
		
		/**
		 * @private
		 */
		private function setInitializePosition():void
		{
			view.mapView.initializePosition = serial;
		}
		
		
		/**
		 * @private
		 */
		private var serial:String;
		
	}
}