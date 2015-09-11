package emap.map2d
{
	import emap.map2d.core.E2Provider;
	import emap.map2d.vos.E2VONode;
	import emap.map2d.vos.E2VORoute;
	
	import flash.display.Sprite;
	
	public class Route extends Sprite
	{
		public function Route($value:E2VORoute)
		{
			super();
			initialize($value);
		}
		protected function  initialize($value:E2VORoute):void
		{
			voRoute = $value;
			getNodeByRoute(voRoute);
			updateLineTo();
		}
		public function updateLineTo():void
		{
			while(this.numChildren) this.removeChildAt(0);
			graphics.lineStyle(10,0x0000FF,1);

			graphics.moveTo(node1.nodeX,node1.nodeY);
			graphics.lineTo(node2.nodeX,node2.nodeY);
			graphics.endFill();
		}
		public function getNodeByRoute($value:E2VORoute):void
		{
			node1 = getNodeByRouteSerial($value.serial1);
			node2 = getNodeByRouteSerial($value.serial2);
		}
		public function getNodeByRouteSerial(s:String):E2VONode
		{
			for each(var node:E2VONode in E2Provider.instance.nodeMap)
			{
				if(node.serial == s)
					return node;
			}
			return null;
		}
		public function get scale():Number
		{
			return __scale;
		}
		public function set scale(value:Number):void
		{
			if (value==scale) return;
			__scale = value;
			this.scaleX = this.scaleY = 1/scale
		}
		private var __scale:Number;
		private var node1:E2VONode;
		private var node2:E2VONode;
		private var voRoute:E2VORoute;
	}
}