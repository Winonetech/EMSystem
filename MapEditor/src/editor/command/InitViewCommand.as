package editor.command
{
	import editor.core.EDConfig;
	
	import emap.map2d.EMap2D;
	import emap.map2d.MapContainer;
	import emap.map2d.core.E2Config;
	import emap.map2d.core.E2Provider;
	import emap.map2d.vos.E2VOFloor;
	import emap.map2d.vos.E2VORoute;

	public final class InitViewCommand extends _InternalCommand
	{
		public function InitViewCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			commandStart();
			
			initView();
			commandEnd();
//			temp.width = container.width;
//			temp.height = container.height;
//			container.addChild(temp);
			
		}
		protected function initView():void
		{
			mapEditor = EDConfig.instance.editor;
			EDConfig.instance.propertyPanel = mapEditor.property;
			EDConfig.instance.floorGroup = mapEditor.floorGroup;
			//trace(MEConfig.instance.floorGroup==null)
			EDConfig.instance.nodeNC = mapEditor.vn;
			EDConfig.instance.positionNC = mapEditor.vp;
			EDConfig.instance.routeNC = mapEditor.vr;
			EDConfig.instance.positionGroup = mapEditor.pg;
			EDConfig.instance.nodeGroup = mapEditor.ng;
			EDConfig.instance.routeGroup = mapEditor.rg;
			//new InitDataCommand().execute();
			var temp:EMap2D = new EMap2D;
			temp.config = E2Config.instance;
			temp.floors = E2Provider.instance.floorMap;
			temp.positions = E2Provider.instance.positionArr;
			temp.routes = E2Provider.instance.routeMap;
			temp.positionTypes = E2Provider.instance.positionTypeMap;
			temp.nodes = E2Provider.instance.nodeMap;
			temp.y = 20;
			temp.x = 20;
			temp.width = mapEditor.container.width;
			temp.height = mapEditor.container.height;
			
			mapEditor.container.addChild(temp);
			
			//	trace(E2Provider.instance.floorArr);
			mapEditor.positionTool.dataProvider = E2Provider.instance.floorArr;
			mapEditor.nodeTool.dataProvider = E2Provider.instance.floorArr;	
			addFloorGroup();
			addRouteGroup();
			
		}
		public function addFloorGroup():void
		{
			for each(var floor:E2VOFloor in E2Provider.instance.floorMap)
			{
				EDConfig.instance.floorGroup.addfloor(floor);
			}
		}
		public function addRouteGroup():void
		{
			for each(var route:E2VORoute in E2Provider.instance.routeMap)
			{
				EDConfig.instance.routeGroup.addRoute(route);
			}
		}
		private var map:MapContainer;
		public var mapEditor:MapEditor;
	}
}