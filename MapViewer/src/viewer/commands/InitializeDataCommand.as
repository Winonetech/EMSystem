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
			
			xml = getXML("cache/data/floors.xml");
			var floorsMap:Map = new Map;
			if (xml)
			{
				var list:XMLList = xml.children();
				for each (var item:XML in list)
				{
					var floor:VOFloor = store.registData(item, VOFloor);
					floorsMap[floor.id] = floor;
				}
			}
			
			xml = getXML("cache/data/positionTypes.xml");
			var positionTypesMap:Map = new Map;
			if (xml)
			{
				list = xml.children();
				for each (item in list)
				{
					var positionType:VOPositionType =store.registData(item, VOPositionType);
					positionTypesMap[positionType.id] = positionType;
				}
			}
			
			xml = getXML("cache/data/positions.xml");
			var serialsMap:Map = new Map;
			var positionsArr:Array = [];
			if (xml)
			{
				list = xml.children();
				for each (item in list)
				{
					var position:E3VOPosition = store.registData(item, E3VOPosition);
					store.registData(position, INode, "serial");
					positionsArr[positionsArr.length] = position;
					position.floor = floorsMap[position.floorID];
					position.positionType = positionTypesMap[position.positionTypeID];
					serialsMap[position.serial] = position;
				}
			}
			
			xml = getXML("cache/data/nodes.xml");
			var nodesMap:Map = new Map;
			if (xml)
			{
				list = xml.children();
				for each (item in list)
				{
					var node:E3VONode = store.registData(item, E3VONode);
					store.registData(node, INode, "serial");
					nodesMap[node.id] = node;
					node.floor = floorsMap[node.floorID];
					serialsMap[node.serial] = node;
				}
			}
			
			xml = getXML("cache/data/routes.xml");
			var routesMap:Map = new Map;
			if (xml)
			{
				list = xml.children();
				
				for each (item in list)
				{
					var route:E3VORoute = store.registData(item, E3VORoute);
					routesMap[route.id] = route;
					route.node1 = serialsMap[route.serial1];
					route.node2 = serialsMap[route.serial2];
				}
			}
			
			config.config = e3Config;
			config.floors = floorsMap;
			config.positionTypes = positionTypesMap;
			config.positions = positionsArr;
			config.nodes = nodesMap;
			config.routes = routesMap;
			config.serials = serialsMap;
		}
		/**
		 * @private
		 */
		private function getXML(path:String):XML
		{
			var file:VSFile = new VSFile(FileUtil.resolvePathApplication(path));
			if (file.exists)
			{
				var stream:FileStream = new FileStream;
				stream.open(file, FileMode.READ);
				var xml:XML = XML(stream.readUTFBytes(stream.bytesAvailable));
			}
			return xml;
		}
		
	}
}