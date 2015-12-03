package editor.command
{
	import editor.core.EDConfig;
	
	import emap.map2d.EMap2D;
	import emap.map2d.Floor;
	import emap.map2d.Node;
	import emap.map2d.core.E2Config;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class SubNodeCommand extends _InternalCommand
	{
		public function SubNodeCommand()
		{
			super();
		}
		override public function execute():void
		{
			commandStart();
			subNode();
			commandEnd();
			
		}
		
		protected function subNode():void
		{
			
			if(EDConfig.instance.e2Config.subNode)
				EDConfig.instance.e2Config.subNode = false;
			else
				EDConfig.instance.e2Config.subNode = true;
		}
//		protected function mouseDownHandle(event:MouseEvent):void
//		{
//			if(event.target is Node)
//			{
//				var node:Node = Node(event.target);
//				floor.subNode(node);
//			}
//		}
	
	}
}