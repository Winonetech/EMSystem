package editor.command
{
	import editor.core.EDConfig;
	
	import emap.map2d.EMap2D;
	import emap.map2d.Floor;
	import emap.map2d.Route;
	import emap.map2d.core.E2Config;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class SubRouteCommand extends _InternalCommand
	{
		public function SubRouteCommand($value:Boolean)
		{
			begin = $value;
			super();
		}
		override public function execute():void
		{
			commandStart();
			if(begin)
				EDConfig.instance.routeManager.beginDeleteRoute();
			else
				EDConfig.instance.routeManager.endDeleteRoute();
			
			commandEnd();
		}
		
		private var begin:Boolean;
		private var floor:Floor;
		private var nodeLayer:Sprite;
		private var eMap:EMap2D;
	}
}