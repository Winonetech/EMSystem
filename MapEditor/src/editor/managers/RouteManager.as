package editor.managers
{
	import editor.core.EDConfig;
	
	import emap.interfaces.INode;
	import emap.map2d.EMap2D;
	import emap.map2d.Floor;
	import emap.map2d.Node;
	import emap.map2d.Position;
	import emap.map2d.Route;
	import emap.map2d.core.E2Config;
	import emap.map2d.core.E2Provider;
	import emap.map2d.util.CountUtil;
	import emap.map2d.vos.E2VONode;
	import emap.map2d.vos.E2VOPosition;
	import emap.map2d.vos.E2VORoute;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;

	public class RouteManager
	{
		public function RouteManager($emap2d:EMap2D)
		{
			eMap= $emap2d;
		}
		
		public function beginAddRoute():void
		{
			eMap.addEventListener(MouseEvent.CLICK,mouseClickHandle1);
		}
		//添加路径的时候就是 已经点击了一个位置或者节点的时候newRoute为false 当第二个被点的时候一个路径生成完 newRoute改为true
		public function mouseClickHandle1(event:MouseEvent):void
		{
			if((event.target is Node)||(event.target is Position) )
			{
				if(newRoute)
				{
					voRoute = new E2VORoute;
					voRoute.node1 = INode(event.target.data);
					newRoute = false;
					
				}else
				{
					voRoute.node2 = INode (event.target.data);
					voRoute.node2.serial;
					if(getRoute(voRoute.node1,voRoute.node2))
					{}
					else
					{
					
						voRoute.id = CountUtil.instance.routeCount+"";
						var route:Route = new Route(voRoute); 
						if(!voRoute.cross)
							EDConfig.instance.e2Config.floorViewMap[voRoute.node2.floorID].addRoute(route);
						
						voRoute.serial1 = voRoute.node1.serial;
						voRoute.serial2 = voRoute.node2.serial;
						
						E2Provider.instance.routeMap[voRoute.id] = voRoute;
						
						EDConfig.instance.e2Config.serialViewMap[voRoute.node1.serial].addRoute(route);
						EDConfig.instance.e2Config.serialViewMap[voRoute.node2.serial].addRoute(route);
						storeINodeName(voRoute.node1);
						storeINodeName(voRoute.node2);
						newRoute = true;
					}
				}
			}
		}
		/**
		 * 存入INode的名称
		 * 
		 * */ 
		private function storeINodeName($value:Object):void
		{
			if($value is E2VONode)
			{
				EDConfig.instance.e2Config.INodeNameMap[$value.serial] = "节点"+$value.id;
			}
			else
			{
				EDConfig.instance.e2Config.INodeNameMap[$value.serial] = $value.label;
			}
		}
		/**
		 * 判断两点之间是否已经存在路径
		 * */
		private function getRoute($value1:INode,$value2:INode):Boolean
		{

			if($value1 == $value2) return true;
			for each(var route:E2VORoute in E2Provider.instance.routeMap)
			{
				if(((route.node1.serial == $value1.serial) && (route.node2.serial == $value2.serial))||((route.node1.serial == $value2.serial) && (route.node2.serial == $value1.serial)))
				{
					return true;
				}
			}
			return false;
		}
		public function endAddRoute():void
		{
			eMap.removeEventListener(MouseEvent.CLICK,mouseClickHandle1);
		}
		/**
		 * 删除路径开始
		 * */
		public function beginDeleteRoute():void
		{
			if(EDConfig.instance.selectedFloor)
			{
				eMap =  EDConfig.instance.e2Config.eMap;
				floor= EDConfig.instance.e2Config.floorViewMap[EDConfig.instance.selectedFloor.id];
				eMap.addEventListener(MouseEvent.CLICK,mouseClickHandle2);
			}
		}
		protected function mouseClickHandle2(event:MouseEvent):void
		{
			if(event.target is Route)
			{
				route = Route(event.target);
				 Alert.show("是否删除该路径?","确认删除",Alert.YES|Alert.NO,null,deleteRoute);
				
			}
		}
		private function deleteRoute(event:CloseEvent):void
		{
			if(Alert.YES == event.detail)
			{
				if(route)
				{
					floor.subRoute(route);
					EDConfig.instance.e2Config.serialViewMap[route.voRoute.node1.serial].removeRoute(route);
					EDConfig.instance.e2Config.serialViewMap[route.voRoute.node2.serial].removeRoute(route);
					delete E2Provider.instance.routeMap[route.voRoute.id];
					delete EDConfig.instance.e2Config.routeViewMap[route.voRoute.id];
					EDConfig.instance.routeGroup.addRouteByFloorId(route.voRoute.id);
				}
			}else
			{
				return
			}
		}
		/**
		 * 删除路径结束
		 * */
		public function endDeleteRoute():void
		{
			eMap.removeEventListener(MouseEvent.CLICK,mouseClickHandle2);
		}
		private var route:Route;
		private var floor:Floor;
		private var voRoute:E2VORoute;
		private var newRoute:Boolean = true;
		private var eMap:EMap2D;
		
	}
}