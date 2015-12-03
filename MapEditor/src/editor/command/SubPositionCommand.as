package editor.command
{
	import editor.core.EDConfig;
	
	import emap.map2d.Floor;
	import emap.map2d.Position;
	import emap.map2d.Route;
	import emap.map2d.core.E2Config;
	import emap.map2d.core.E2Provider;
	import emap.map2d.vos.E2VOFloor;
	import emap.map2d.vos.E2VOPosition;

	public class SubPositionCommand extends _InternalCommand
	{
		public function SubPositionCommand()
		{
			super();
		}
		override public function execute():void
		{
			commandStart();
			deletePosition();
			commandEnd();
		}
		public function deletePosition():void
		{
			if(EDConfig.instance.selectedPosition)
			{
				EDConfig.instance.positionGroup.subPosition();
				var voPosition:E2VOPosition = EDConfig.instance.selectedPosition;
				if(E2Provider.instance.positionArr.indexOf(voPosition)>=0)
				{
					
					E2Provider.instance.positionArr.splice(E2Provider.instance.positionArr.indexOf(voPosition),1);
					var position:Position = EDConfig.instance.e2Config.positionViewMap[voPosition.id];
					var floor:Floor = EDConfig.instance.e2Config.floorViewMap[voPosition.floorID];
					floor.removePosition(position);
					for each(var route:Route in position.getRouteMap())
					{
						EDConfig.instance.e2Config.floorViewMap[voPosition.floorID].subRoute(route);	
						delete EDConfig.instance.e2Config.routeViewMap[route.voRoute.id]
						delete	E2Provider.instance.routeMap[route.voRoute.id]
						
					}
					delete EDConfig.instance.e2Config.positionViewMap[voPosition.id];
				}
			}
		}
	}
}