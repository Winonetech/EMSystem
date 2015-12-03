package editor.command
{
	import emap.map2d.core.E2Provider;
	import emap.map2d.vos.E2VOFloor;
	import emap.map2d.vos.E2VONode;
	import emap.map2d.vos.E2VOPosition;
	import emap.map2d.vos.E2VOPositionType;
	import emap.map2d.vos.E2VORoute;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
/**
 * 数据存储 数据生成XML
 * */
	public class DataStoreCommand extends _InternalCommand
	{
		public function DataStoreCommand()
		{
			super();
		}
		override public function execute():void
		{
			commandStart();
			floorDataStore();
			positionDataStore();
			positionTypeDataStore();
			nodeDataStore();
			routeDataStore();
			commandEnd();
			
		}
		protected function floorDataStore():void
		{
			var $xmlFloor:String = "";
			for each(var floor:E2VOFloor in E2Provider.instance.floorArr)
			{
				$xmlFloor  = $xmlFloor+floor.toXML();
			}
			$xmlFloor = "<floors>"+$xmlFloor+"</floors>";
			stringToXML("cache/data","floors.xml",$xmlFloor);
		}
		protected function positionDataStore():void
		{
			var $xmlPosition:String = "";
			for each(var position:E2VOPosition in E2Provider.instance.positionArr)
			{
				$xmlPosition = $xmlPosition +position.toXML();
			}
			$xmlPosition = "<positions>"+$xmlPosition+"</positions>";
			stringToXML("cache/data","positions.xml",$xmlPosition);
		}
		protected function positionTypeDataStore():void
		{
			var $xmlPositionType:String = "";
			for each(var positionType:E2VOPositionType in E2Provider.instance.positionTypeMap)
			{
				$xmlPositionType = $xmlPositionType +positionType.toXML();
			}
			$xmlPositionType = "<positions>"+$xmlPositionType+"</positions>";
			stringToXML("cache/data","positionTypes.xml",$xmlPositionType);
		}
		protected function nodeDataStore():void
		{
			var $xmlNode:String = "";
			for each(var node:E2VONode in E2Provider.instance.nodeArr)
			{
				$xmlNode =$xmlNode+node.toXML();
			}
			$xmlNode = "<nodes>"+$xmlNode+"</nodes>";
			stringToXML("cache/data","nodes.xml",$xmlNode);
		}
		protected function routeDataStore():void
		{
			var $xmlRoute:String = "";
			for each(var route:E2VORoute in E2Provider.instance.routeMap)
			{
				$xmlRoute = $xmlRoute +route.toXML();
			}
			$xmlRoute = "<routes>"+$xmlRoute+"</routes>";
			stringToXML("cache/data","routes.xml",$xmlRoute);
		}
		private function stringToXML($folder:String,$name:String,$xml:String):void
		{
			/**
			 *文件不存在，就创建 
			 **/
			var urlFolder:String = File.applicationDirectory.resolvePath($folder).nativePath;
			var _rootExportDir:File = new File(urlFolder);
			if(!_rootExportDir.exists)
				_rootExportDir.createDirectory();
			var urlFile:String = urlFolder+"\\"+$name;
			var oFile:File = new File(urlFile);
			if(oFile.exists)
				oFile.deleteFile();
			var file:File = new File(urlFile);
			var stream:FileStream = new FileStream();
			stream.open(file,FileMode.WRITE);
			var xml:XML = new XML($xml);
			stream.writeUTFBytes(xml.toXMLString());
			stream.close();
			
		}
	}
}