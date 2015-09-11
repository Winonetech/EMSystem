package editor.command
{
	import cn.vision.collections.Map;
	import cn.vision.system.VSFile;
	import cn.vision.utils.FileUtil;
	
	import com.winonetech.core.Store;
	
	import editor.core.EDConfig;
	
	import emap.map2d.core.E2Provider;
	
	import emap.map2d.vos.E2VOFloor;
	import emap.map2d.vos.E2VOHall;
	import emap.map2d.vos.E2VONode;
	import emap.map2d.vos.E2VOPosition;
	import emap.map2d.vos.E2VOPositionType;
	import emap.map2d.vos.E2VORoute;
	import emap.vos.VOFloor;
	import emap.vos.VOHall;
	import emap.vos.VONode;
	import emap.vos.VOPosition;
	import emap.vos.VOPositionType;
	import emap.vos.VORoute;
	
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	public class InitDataCommand extends _InternalCommand
	{
		public function InitDataCommand()
		{
			super();
		}
		override public function execute():void
		{
			commandStart();
			
			initializeData()
			
			commandEnd();
		}
		private function initializeData():void
		{
			var xml:XML = getXML("data/floors.xml");
			var list:XMLList = xml.children();
			E2Provider.instance.floorMap = new Map;
			E2Provider.instance.floorArr = new Array;
			for each(var item:XML in list)
			{
				var floor:E2VOFloor = store.registData(item, E2VOFloor);
			//	trace(MEConfig.instance.floorGroup==null)
			//	EDConfig.instance.floorGroup.addfloor(floor);
				E2Provider.instance.floorMap[floor.id] = floor;
				E2Provider.instance.floorArr.push(floor);
			}
			E2Provider.instance.floorArr.sortOn("order", Array.NUMERIC);
			xml = getXML("data/positions.xml");
			list = xml.children();
			E2Provider.instance.positionArr = [];
			for each(item in list)
			{
				var position:E2VOPosition  = store.registData(item,E2VOPosition);
				E2Provider.instance.positionArr[E2Provider.instance.positionArr.length]=position;
				
			}
			xml = getXML("data/positionTypes.xml"); 
			list = xml.children();
			E2Provider.instance.positionTypeMap = new Map;
			E2Provider.instance.positionTypeArr = new Array;
			for each(item in list)
			{
				var positionType:E2VOPositionType = store.registData(item,E2VOPositionType);
				E2Provider.instance.positionTypeMap[positionType.id] = positionType;
				E2Provider.instance.positionTypeArr.push(positionType);
			}
			xml = getXML("data/halls.xml");
			list = xml.children();
			E2Provider.instance.hallMap = new Map;
			for each(item in list)
			{  
				var hall:E2VOHall = store.registData(item,E2VOHall);
				E2Provider.instance.hallMap[hall.id] = hall;
			}
			xml = getXML("data/nodes.xml");
			list = xml.children();
			E2Provider.instance.nodeMap = new Map;
			E2Provider.instance.nodeArr = new Array;
			for each(item in list)
			{
				var node:E2VONode = store.registData(item,E2VONode);
				
				E2Provider.instance.nodeMap[node.id] = node;
				E2Provider.instance.nodeArr.push(node);
			}
			xml = getXML("data/routes.xml");
			list = xml.children();
			E2Provider.instance.routeMap = new Map;
			for each(item in list)
			{
				var route:E2VORoute = store.registData(item,E2VORoute);
				E2Provider.instance.routeMap[route.id] = route;
			//	EDConfig.instance.routeGroup.addRoute(route);
			}
			
			
			
		}
		private function getXML(path:String):XML 
		{
			var file:VSFile = new VSFile(FileUtil.resolvePathApplication(path));
			trace(file.url)
			var stream:FileStream = new FileStream;
			stream.open(file, FileMode.READ);
			var temp:String = stream.readUTFBytes(stream.bytesAvailable);
			return XML(temp);
		}
		private var store:Store = Store.instance;
	}
	
}