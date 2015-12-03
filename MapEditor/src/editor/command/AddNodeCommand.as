package editor.command
{
	import cn.vision.pattern.core.Command;
	
	import editor.core.EDConfig;
	
	import emap.map2d.EMap2D;
	import emap.map2d.Floor;
	import emap.map2d.Node;
	import emap.map2d.core.E2Config;
	import emap.map2d.core.E2Provider;

	import emap.map2d.vos.E2VONode;
	import emap.utils.NodeUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class AddNodeCommand extends Command
	{
		public function AddNodeCommand($value:Boolean)
		{
			super();
			begin = $value;
		}
		override public function execute():void
		{
			commandStart();
			if(begin)
				EDConfig.instance.nodeManager.beginAddNode();
			else
				EDConfig.instance.nodeManager.endAddNode();
			commandEnd();
			
		}
		
		private var begin:Boolean;
		
	}
}