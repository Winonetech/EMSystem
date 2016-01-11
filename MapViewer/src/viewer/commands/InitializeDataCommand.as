package viewer.commands
{
	
	/**
	 * 
	 * 初始化数据命令。
	 * 
	 */
	
	
	import cn.vision.collections.Map;
	import cn.vision.system.VSFile;
	import cn.vision.utils.FileUtil;
	
	import emap.interfaces.INode;
	import emap.map3d.core.E3Config;
	import emap.map3d.vos.E3VONode;
	import emap.map3d.vos.E3VOPosition;
	import emap.map3d.vos.E3VORoute;
	import emap.vos.VOFloor;
	import emap.vos.VOPositionType;
	
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	
	public final class InitializeDataCommand extends _InternalCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function InitializeDataCommand()
		{
			super();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function execute():void
		{
			commandStart();
			
			initializeData();
			
			commandEnd();
		}
		
		
		/**
		 * @private
		 */
		private function initializeData():void
		{
			var xml:XML = getXML("cache/data/emporium.xml");
			var e3Config:E3Config = new E3Config(xml);
			config.config = e3Config;
			
			xml = getXML("cache/data/floors.xml");
			var list:XMLList = xml.children();
			var floorsMap:Map = new Map;
			for each (var item:XML in list)
			{
				var floor:VOFloor = store.registData(item, VOFloor);
				floorsMap[floor.id] = floor;
			}
			config.floors = floorsMap;
			xml = getXML("cache/data/positionTypes.xml");
			list = xml.children();
			var positionTypesMap:Map = new Map;
			for each (item in list)
			{
				var positionType:VOPositionType =store.registData(item, VOPositionType);
				positionTypesMap[positionType.id] = positionType;
			}
			config.positionTypes = positionTypesMap;
			xml = getXML("cache/data/positions.xml");
			list = xml.children();
			var positionsArr:Array = [];
			var serialsMap:Map = new Map;
			for each (item in list)
			{
				var position:E3VOPosition = store.registData(item, E3VOPosition);
				store.registData(position, INode, "serial");
				positionsArr[positionsArr.length] = position;
				position.floor = floorsMap[position.floorID];
				position.positionType = positionTypesMap[position.positionTypeID];
				serialsMap[position.serial] = position;
			}
			
			config.positions = positionsArr;
			
			xml = getXML("cache/data/nodes.xml");
			list = xml.children();
			var nodesMap:Map = new Map;
			for each (item in list)
			{
				var node:E3VONode = store.registData(item, E3VONode);
				store.registData(node, INode, "serial");
				nodesMap[node.id] = node;
				node.floor = floorsMap[node.floorID];
				serialsMap[node.serial] = node;
			}
			config.nodes = nodesMap;
			
			xml = getXML("cache/data/routes.xml");
			list = xml.children();
			var routesMap:Map = new Map;
			for each (item in list)
			{
				var route:E3VORoute = store.registData(item, E3VORoute);
				routesMap[route.id] = route;
				route.node1 = serialsMap[route.serial1];
				route.node2 = serialsMap[route.serial2];
			}
			config.serials = serialsMap;
			config.routes = routesMap;
		}
		/**
		 * @private
		 */
		private function getXML(path:String):XML
		{
			var file:VSFile = new VSFile(FileUtil.resolvePathApplication(path));
			var stream:FileStream = new FileStream;
			stream.open(file, FileMode.READ);
			return XML(stream.readUTFBytes(stream.bytesAvailable));
		}
		
	}
}