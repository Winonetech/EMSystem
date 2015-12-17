package editor.command
{
	import cn.vision.system.VSFile;
	import cn.vision.utils.FileUtil;
	
	import editor.core.EDConfig;
	import editor.managers.NodeManager;
	import editor.managers.RouteManager;
	
	import emap.map2d.EMap2D;
	import emap.map2d.MapContainer;
	import emap.map2d.core.E2Config;
	import emap.map2d.core.E2Provider;
	import emap.map2d.vos.E2VOFloor;
	import emap.map2d.vos.E2VORoute;
	
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

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
			
		}
		protected function initView():void
		{
			//将地图各个控件赋值给配置类 以便后面对控件的操作
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
			EDConfig.instance.positionTypeGroup = mapEditor.ptg;
			EDConfig.instance.tabBar= mapEditor.tabs;
			EDConfig.instance.positionTool = mapEditor.positionTool;
			EDConfig.instance.nodeTool = mapEditor.nodeTool;
			var e2Config : E2Config = new E2Config(getXML("cache/data/emporium.xml"));
			var temp:EMap2D = new EMap2D(e2Config);
			
			EDConfig.instance.e2Config = e2Config;
			//temp.config = e2Config;
			temp.floors = E2Provider.instance.floorMap;
			temp.positions = E2Provider.instance.positionArr;
			temp.routes = E2Provider.instance.routeMap;
			temp.positionTypes = E2Provider.instance.positionTypeMap;
			temp.nodes = E2Provider.instance.nodeMap;
			temp.y = 15;
			temp.x = 20;
			temp.width = mapEditor.container.width;
			temp.height = mapEditor.container.height; 
			temp.viewFloor(0);
			
			mapEditor.container.addChild(temp);
			e2Config.eMap = temp;
			
			//	trace(E2Provider.instance.floorArr);
			mapEditor.positionTool.dataProvider = E2Provider.instance.floorArr;
			mapEditor.nodeTool.dataProvider = E2Provider.instance.floorArr;	
			mapEditor.routeTool.dataProvider = E2Provider.instance.floorArrC;
			EDConfig.instance.nodeManager = new NodeManager(temp);
			EDConfig.instance.routeManager = new RouteManager(temp);
			//addFloorGroup();
			EDConfig.instance.floorGroup.addAllFloor();
			EDConfig.instance.positionTypeGroup.addAllPositionType();
			//addRouteGroup();
			
			
		}
		private function getXML(path:String):XML
		{
			var file:VSFile = new VSFile(FileUtil.resolvePathApplication(path));
			if(file.exists)
			{
				var stream:FileStream = new FileStream;
				stream.open(file, FileMode.READ);
				var temp:String = stream.readUTFBytes(stream.bytesAvailable);
				return XML(temp);
			}
			return null;
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