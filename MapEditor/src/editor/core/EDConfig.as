package editor.core
{
	import cn.vision.errors.SingleTonError;
	
	import editor.components.PropertyPanel;
	import editor.components.floor.FloorGroup;
	import editor.components.node.NodeGroup;
	import editor.components.position.PositionGroup;
	import editor.components.route.RouteGroup;
	
	import emap.map2d.MapContainer;
	import emap.map2d.vos.E2VOFloor;
	import emap.map2d.vos.E2VONode;
	import emap.map2d.vos.E2VOPosition;
	import emap.map2d.vos.E2VORoute;
	
	import spark.components.NavigatorContent;
	

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
		[Bindable]
		public var selectedNode:E2VONode;
		public var selectedRoute:E2VORoute;
	//	public static const instance:MEConfig = new MEConfig;
		public var floorGroup:FloorGroup;
		public var positionGroup:PositionGroup;
		public var nodeGroup:NodeGroup;
		public var routeGroup:RouteGroup;
		public var positionNC:NavigatorContent;
		public var nodeNC:NavigatorContent;
		public var routeNC:NavigatorContent;
	
		
	}
	
}