package viewer.commands
{
	
	/**
	 * 
	 * 显示或隐藏点击位置界面。
	 * 
	 */
	
	
	import viewer.views.PositionClickView;
	
	
	public final class DisplayPositionClickCommand extends _InternalCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function DisplayPositionClickCommand($display:Boolean = false, $serial:String = null)
		{
			super();
			
			serial = $serial;
			display = $display;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function execute():void
		{
			commandStart();
			
			displayPositionClick();
			
			commandEnd();
		}
		
		
		/**
		 * @private
		 */
		private function displayPositionClick():void
		{
			if (display)
			{
				if(!view.positionClickView)
				{
					view.positionClickView = new PositionClickView;
					view.positionClickView.serial = serial;
					view.application.addElement(view.positionClickView);
				}
			}
			else
			{
				if (view.positionClickView)
				{
					if (view.application.contains(view.positionClickView))
						view.application.removeElement(view.positionClickView);
					view.positionClickView = null;
				}
			}
		}
		
		
		/**
		 * @private
		 */
		private var display:Boolean;
		
		/**
		 * @private
		 */
		private var serial:String;
		
	}
}