package editor.command
{
	import cn.vision.collections.Map;
	import cn.vision.system.VSFile;
	import cn.vision.utils.FileUtil;
	
	import com.winonetech.controls.Field;
	import com.winonetech.core.Store;
	
	import editor.core.EDConfig;
	
	import emap.map2d.core.E2Config;
	import emap.map2d.core.E2Provider;
	import emap.map2d.util.CountUtil;
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
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.utils.object_proxy;
	
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
			var file:File = new File( File.applicationDirectory.resolvePath("cache/data/floors.xml").nativePath);
			if(file.exists){
				
				
				var xml:XML = getXML("cache/data/floors.xml");
				var list:XMLList = xml.children();
				for each(var item:XML in list)
				{
					var floor:E2VOFloor = store.registData(item, E2VOFloor);
				//	trace(MEConfig.instance.floorGroup==null)
				//	EDConfig.instance.floorGroup.addfloor(floor);
				
					E2Provider.instance.floorMap[floor.id] = floor;
					E2Provider.instance.floorArr.push(floor);
					E2Provider.instance.floorArrC.push(floor);
					CountUtil.instance.floorCount = floor.order;
					if(floor.image&&floor.image!="")
						E2Provider.instance.imageMap[floor.image] = floor.image;
			
				}
				E2Provider.instance.floorArr.sortOn("order", Array.NUMERIC);
				E2Provider.instance.floorArrC.sortOn("order", Array.NUMERIC);
			}
			
			var file1:File = new File( File.applicationDirectory.resolvePath("cache/data/positionTypes.xml").nativePath);
			if(file1.exists){
				xml = getXML("cache/data/positionTypes.xml"); 
				list = xml.children();
				
				for each(item in list)
				{
					var positionType:E2VOPositionType = store.registData(item,E2VOPositionType);
					E2Provider.instance.positionTypeMap[positionType.id] = positionType;
					E2Provider.instance.positionTypeArr.push(positionType);
					CountUtil.instance.positionTypeCount = Number(positionType.id);
				}
			}
			var file2:File = new File( File.applicationDirectory.resolvePath("cache/data/positions.xml").nativePath);
			if(file2.exists){
				xml = getXML("cache/data/positions.xml");
				list = xml.children();
				E2Provider.instance.positionArr = [];
				for each(item in list)
				{
					var position:E2VOPosition  = store.registData(item,E2VOPosition);
					
					position.positionType = E2Provider.instance.positionTypeMap[position.positionTypeID]
				
					E2Provider.instance.positionArr[E2Provider.instance.positionArr.length]=position;
					E2Provider.instance.serialMap[position.serial] = position;
					if(position.icon&&position.icon!="")
						E2Provider.instance.imageMap[position.icon] = position.icon;
					if(position.realImage&&position.realImage!="")
						E2Provider.instance.imageMap[position.realImage] = position.realImage;
					CountUtil.instance.positionCount = Number(position.id);
				}
			}
			var file3:File = new File( File.applicationDirectory.resolvePath("cache/data/halls.xml").nativePath);
			if(file3.exists){	
				xml = getXML("cache/data/halls.xml");
				list = xml.children();
				E2Provider.instance.hallMap = new Map;
				for each(item in list)
				{  
					var hall:E2VOHall = store.registData(item,E2VOHall);
					E2Provider.instance.hallMap[hall.id] = hall;
				}
			}
			var file4:File = new File( File.applicationDirectory.resolvePath("cache/data/nodes.xml").nativePath);
			if(file4.exists){	
				xml = getXML("cache/data/nodes.xml");
				list = xml.children();
				
				for each(item in list)
				{
					var node:E2VONode = store.registData(item,E2VONode);
					
					E2Provider.instance.nodeMap[node.id] = node;
					E2Provider.instance.nodeArr.push(node);
					E2Provider.instance.serialMap[node.serial] = node;
					CountUtil.instance.nodeCount = Number(node.id);
				}
			}
			var file5 :File = new File(File.applicationDirectory.resolvePath("cache/data/routes.xml").nativePath);
			if(file5.exists)
			{
				xml = getXML("cache/data/routes.xml");
				list = xml.children();
				E2Provider.instance.routeMap = new Map;
				for each(item in list)
				{
					var route:E2VORoute = store.registData(item,E2VORoute);
					
					E2Provider.instance.routeMap[route.id] = route;
					CountUtil.instance.routeCount = Number(route.id);
					route.node1 = E2Provider.instance.serialMap[route.serial1];
					route.node2 = E2Provider.instance.serialMap[route.serial2];
				//	EDConfig.instance.routeGroup.addRoute(route);
				}
			}
			clearCache();
		
		}
		//遍历图片数组删除没用的图片
		private function clearCache():void
		{
			var file:File = new File(File.applicationDirectory.resolvePath("cache/image").nativePath);
			if(file.exists)
			{
				var imageArr:Array = file.getDirectoryListing();
				for each(var f:File in imageArr)
				{
					var ary :Array = f.url.split("/");;
					var imageUrl:String = "cache/image/"+ary[ary.length-1];
					//imageMap中存在的都是被使用了
					if(!E2Provider.instance.imageMap.contains(imageUrl))
					{
							if(f.exists)
								f.deleteFile();
					}
				
			
				}
			}
		
		}
		private function getXML(path:String):XML 
		{
			var file:VSFile = new VSFile(FileUtil.resolvePathApplication(path));
			
			var stream:FileStream = new FileStream;
			stream.open(file, FileMode.READ);
			var temp:String = stream.readUTFBytes(stream.bytesAvailable);
			return XML(temp);
		}
		private var store:Store = Store.instance;
	}
	
}