package editor.command
{
	import cn.vision.pattern.core.Command;
	
	import editor.core.EDConfig;
	
	import emap.map2d.Node;
	import emap.map2d.core.E2Config;
	import emap.map2d.core.E2Provider;
	import emap.map2d.vos.E2VOFloor;
	import emap.map2d.vos.E2VONode;
	import emap.map2d.vos.E2VOPosition;
	import emap.map2d.vos.E2VORoute;
	
	import mx.states.OverrideBase;
	
	public class SubFloorCommand extends Command
	{
		public function SubFloorCommand()
		{
			super();
		}
		override public function execute():void
		{
			commandStart();
			subFloor();
			commandEnd();
		}
		public function subFloor():void
		{
			if(EDConfig.instance.selectedFloor)
			{
				EDConfig.instance.floorGroup.subFloor();
				var voFloor:E2VOFloor = EDConfig.instance.selectedFloor;
				if(E2Provider.instance.floorArr.indexOf(voFloor)){
					delete E2Provider.instance.floorMap[voFloor.id];
					delete EDConfig.instance.e2Config.floorViewMap[voFloor.id];
					E2Provider.instance.floorArr.splice(E2Provider.instance.floorArr.indexOf(voFloor),1);
					subPositionByFloor(voFloor);
					
				}
			}
		}
		//删除楼层过程 需要删除位置 和节点
		public function subViewByFloor(floorID:String):void
		{
			//先删除位置的
			for(var i:int = 0;i<E2Provider.instance.positionArr.length;i++)
			{
				var voPosition:E2VOPosition = E2Provider.instance.positionArr[i];
				if(voPosition.floorID == floorID)
				{
					E2Provider.instance.positionArr.splice(E2Provider.instance.positionArr.indexOf(voPosition),1);
					
				}
			}
			//删除节点
			for each(var voNode:E2VONode in E2Provider.instance.nodeMap)
			{
				if(voNode.floorID == floorID)
					
				{
					E2Provider.instance.nodeArr.splice(E2Provider.instance.nodeArr.indexOf(voNode),1);
					delete E2Provider.instance.nodeMap[voNode.id];
					//删除节点的时候 同时删除路径
					var node:Node = EDConfig.instance.e2Config.nodeViewMap[voNode.id];
					for each(var voRoute:E2VORoute in node.routeMap)
					{
						delete E2Provider.instance.routeMap[voRoute.id];
					
					}
				}
			}
		}
		//当删除一个楼层的时候就要将该楼层的位置都要删除
		public function subPositionByFloor(floor:E2VOFloor):void
		{
			for each(var voPosition:E2VOPosition in E2Provider.instance.positionArr)
			{
				if(voPosition.floorID == floor.id)
				{
					E2Provider.instance.positionArr.splice(E2Provider.instance.positionArr.indexOf(voPosition),1);
					delete EDConfig.instance.e2Config.positionViewMap[voPosition.id]
				}
			}
		}
	}
}