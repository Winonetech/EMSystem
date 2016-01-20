package viewer.commands
{
	
	/**
	 * 
	 * 初始化视图命令。
	 * 
	 */
	
	
	import mx.binding.utils.BindingUtils;
	
	import viewer.views.MapView;
	
	
	public final class InitializeViewCommand extends _InternalCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function InitializeViewCommand()
		{
			super();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function execute():void
		{
			commandStart();
			
			initializeView();
			
			commandEnd();
		}
		
		
		/**
		 * @private
		 */
		private function initializeView():void
		{
				var map:MapView = new MapView;
				
				BindingUtils.bindProperty(map, "width" , view.application, "width");
				BindingUtils.bindProperty(map, "height", view.application, "height");
				
				map.background    = new MapBg;
				map.config        = config.config;
				map.floors        = config.floors;
				map.positionTypes = config.positionTypes;
				map.positions     = config.positions;
				map.nodes         = config.nodes;
				map.routes        = config.routes;
				view.mapView = map;
				
				view.application.addElement(map);
		}
		
		
		/**
		 * @private
		 */
		[Embed(source="images/mapBg.jpg")]
		private var MapBg:Class;
		
	}
}