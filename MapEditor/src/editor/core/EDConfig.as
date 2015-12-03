package editor.core
{
	import cn.vision.errors.SingleTonError;
	
	import editor.components.PropertyPanel;
	import editor.components.floor.FloorGroup;
	import editor.components.node.NodeGroup;
	import editor.components.node.ToolThree;
	import editor.components.position.PositionGroup;
	import editor.components.position.ToolTwo;
	import editor.components.positionType.PositionTypeGroup;
	import editor.components.route.RouteGroup;
	import editor.managers.NodeManager;
	import editor.managers.RouteManager;
	
	import emap.map2d.MapContainer;
	import emap.map2d.core.E2Config;
	import emap.map2d.vos.E2VOFloor;
	import emap.map2d.vos.E2VONode;
	import emap.map2d.vos.E2VOPosition;
	import emap.map2d.vos.E2VOPositionType;
	import emap.map2d.vos.E2VORoute;
	
	import mx.skins.Border;
	
	import spark.components.BorderContainer;
	import spark.components.NavigatorContent;
	import spark.components.TabBar;
	
	[Bindable]
	public class EDConfig
	{
		public function EDConfig()
		{
			if(!instance)
			{
			}
			else throw SingleTonError;
		}
		
		public var editor:MapEditor;
		
		public var map:MapContainer;
		public static const instance:EDConfig = new EDConfig;
		public var propertyPanel:PropertyPanel;
		public var selectedFloor:E2VOFloor;
		public var selectedPosition:E2VOPosition;
		
		public var selectedNode:E2VONode;
		public var selectedPositionType:E2VOPositionType;
		public var selectedRoute:E2VORoute;
		public var floorGroup:FloorGroup;
		public var positionGroup:PositionGroup;
		public var nodeGroup:NodeGroup;
		public var tabBar:TabBar;
		public var nodeTool:ToolThree;
		public var positionTool:ToolTwo;
		public var routeGroup:RouteGroup;
		public var positionTypeGroup:PositionTypeGroup;
		public var positionNC:NavigatorContent;
		public var nodeNC:NavigatorContent;
		public var routeNC:NavigatorContent;
		public var nodeManager:NodeManager;
		public var routeManager:RouteManager;
		public var e2Config:E2Config;
	}
	
}