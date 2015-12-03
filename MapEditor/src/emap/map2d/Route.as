package emap.map2d
{
	import editor.core.EDConfig;
	
	import emap.interfaces.INode;
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
			mouseChildren = false;
			voRoute = $value;
			
			updateLineTo();
			if(!voRoute.cross &&voRoute.node1) floorID = voRoute.node1.floorID; 
		}
		public function updateLineTo():void
		{
			graphics.clear();
			node1 = voRoute.node1;
			node2 = voRoute.node2;
			if(node1 && node2)
			{
				graphics.lineStyle(20,0x0000FF,1);
				graphics.moveTo(node1.nodeX,node1.nodeY);
				graphics.lineTo(node2.nodeX,node2.nodeY);
				graphics.endFill();
			}
		}
		public function set selected($bool:Boolean):void
		{
			if($bool )
			{
				if(!_selected)
				{
					cRoute = new Sprite;
					cRoute.graphics.clear();
					cRoute.graphics.lineStyle(40,0xFF00CC,1);
					cRoute.graphics.moveTo(node1.nodeX,node1.nodeY);
					cRoute.graphics.lineTo(node2.nodeX,node2.nodeY);
					cRoute.graphics.endFill();
					this.addChild(cRoute);
					_selected = $bool;
					//属性框
					EDConfig.instance.propertyPanel.setCurrentState("route",true);
					EDConfig.instance.tabBar.selectedItem = EDConfig.instance.routeNC;
					EDConfig.instance.selectedRoute = voRoute;
					//重新加载一次route框
					EDConfig.instance.routeGroup.addRouteByFloorId(voRoute.node1.floorID);
					EDConfig.instance.propertyPanel.route.route = EDConfig.instance.selectedRoute;
				}
			}else
			{
				if(cRoute && this.contains(cRoute))
					this.removeChild(cRoute);
				_selected = $bool;
			}
		
		}
//		public function oclick():void
//		{
//			if(cRoute && this.contains(cRoute))
//				this.removeChild(cRoute);
//			cRoute = new Sprite;
//			cRoute.graphics.clear();
//			cRoute.graphics.lineStyle(40,0xFF00CC,1);
//			cRoute.graphics.moveTo(node1.nodeX,node1.nodeY);
//			cRoute.graphics.lineTo(node2.nodeX,node2.nodeY);
//			cRoute.graphics.endFill();
//			this.addChild(cRoute);
//		}
//		public function removeClicked():void
//		{
//			if(cRoute && this.contains(cRoute))
//				this.removeChild(cRoute);
//		}
		public function getNodeByRouteSerial(s:String):INode
		{
			return E2Provider.instance.serialMap[s];
		}
		public function get scale():Number
		{
			return __scale;
		}
		public function set scale(value:Number):void
		{
			if (value==scale) return;
			__scale = value;
			this.scaleX = this.scaleY = 1/scale;
		}
		public var floorID:String;
		private var __scale:Number;
		private var cRoute:Sprite;
		public var voRoute:E2VORoute;
		private var  node1:INode;
		private var node2:INode;
		private var _selected:Boolean;
	}
}