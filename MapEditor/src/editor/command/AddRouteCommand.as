package editor.command
{
	import cn.vision.pattern.core.Command;
	
	import editor.core.EDConfig;
	
	import emap.interfaces.INode;
	import emap.map2d.EMap2D;
	import emap.map2d.Node;
	import emap.map2d.Position;
	import emap.map2d.Route;
	import emap.map2d.core.E2Config;
	import emap.map2d.core.E2Provider;

	import emap.map2d.vos.E2VORoute;
	
	import flash.events.MouseEvent;
	
	public class AddRouteCommand extends _InternalCommand
	{
		public function AddRouteCommand($value:Boolean)
		{
			super();
			begin = $value;
		}
		override public function execute():void
		{
			commandStart();
			if(begin)
				EDConfig.instance.routeManager.beginAddRoute();
			else
				EDConfig.instance.routeManager.endAddRoute();
			
			commandEnd();
			
		}
		
		private var begin:Boolean;
		
	}
}