package editor.managers
{
	import editor.core.EDConfig;
	
	import emap.map2d.EMap2D;
	import emap.map2d.Floor;
	import emap.map2d.Node;
	import emap.map2d.core.E2Config;
	import emap.map2d.core.E2Provider;
	import emap.map2d.util.CountUtil;

	import emap.map2d.vos.E2VONode;
	import emap.utils.NodeUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class NodeManager
	{
		public function NodeManager($emap2d:EMap2D)
		{
			eMap = $emap2d;
		}
		/**
		 *增加节点开始
		 * */
		public function beginAddNode():void
		{
			if(EDConfig.instance.selectedFloor)
			{
				eMap =  EDConfig.instance.e2Config.eMap;
				floor= EDConfig.instance.e2Config.floorViewMap[EDConfig.instance.selectedFloor.id];
				eMap.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandle);
			}
		}
		protected function mouseDownHandle(event:MouseEvent):void
		{
			
			//1.生成新的数据结构
			var voNode:E2VONode = new E2VONode;
			voNode.serial = NodeUtil.generateSerial();
			voNode.floorID = EDConfig.instance.selectedFloor.id;
			voNode.id = CountUtil.instance.nodeCount+"";
			
			voNode.nodeX =floor.mouseX;
			voNode.nodeY = floor.mouseY; 
			voNode.label = "节点"+voNode.id;
			//2.生成节点图形
			var node:Node = new Node(voNode,EDConfig.instance.e2Config);
			EDConfig.instance.e2Config.nodeViewMap[voNode.id] = node;
			EDConfig.instance.e2Config.serialViewMap[voNode.serial] = node;
			E2Provider.instance.nodeMap[voNode.id] = voNode;
			E2Provider.instance.nodeArr.push(voNode);
			
			floor.addNode(node);
			EDConfig.instance.nodeGroup.addNodeByFloor(EDConfig.instance.selectedFloor);
		}
		/**
		 *增加节点结束
		 **/
		public function endAddNode():void
		{
			eMap.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandle);
		}
		
		private var floor:Floor;
		private var nodeLayer:Sprite;
		private var eMap:EMap2D;
	}
}