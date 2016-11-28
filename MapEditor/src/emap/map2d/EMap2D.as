package emap.map2d
{
	import cn.vision.collections.Map;
	import cn.vision.utils.MathUtil;
	
	import editor.core.E2Presenter;
	import editor.core.EDConfig;
	
	import emap.core.em;
	import emap.interfaces.IEMap;
	import emap.map2d.core.E2Config;
	import emap.map2d.core.E2Provider;
	import emap.map2d.vos.E2VOFloor;
	import emap.map2d.vos.E2VONode;
	import emap.map2d.vos.E2VOPosition;
	import emap.map2d.vos.E2VORoute;
	import emap.vos.VOEMap;
	import emap.vos.VOFloor;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class EMap2D extends Viewer2D implements IEMap
	{
		public function EMap2D(e2Config:E2Config)
		{
			super(); 
			initialize();
			content = new MapContainer;
			//addFloor();
			_config = e2Config;
			_config.utilLayer = new UtilLayer(e2Config);
			utilLayer = _config.utilLayer;
			content.addChild(utilLayer);
			map = content;
			
		}
		
		
		public function clear():void
		{
			floorsViewMap = new Map;
			floorsViewArr.length = 0;
			positionsViewMap = new Map;
		
		}
		
		public function viewPosition($data:*, $tween:Boolean=false):void
		{
			
		}
		
		public function viewFloor($data:*, $tween:Boolean=false):void
		{
			viewFloorUpdate();
			if ($data is Floor)
				var floor:Floor = $data;
			else if ($data is VOFloor)
				floor = floorsViewMap[$data.id];
			else if ($data is String)
			{
				floor = floorsViewMap[$data];
			//	trace("length",floorsViewMap[floorsViewMap.length+""].id);
			}
			else if ($data is uint)
				floor = floorsViewArr[MathUtil.clamp($data - 1, 0, floorsViewArr.length - 1)];
			
			if (floor && floor!= floorNext)
			{
				floorPrev = floorNext;
				if(floorPrev)
					floorPrev.visible = false;
				floorNext = floor;
				floorNext.visible = true;
			
			} 
		
		}
		//切换楼层的需要对 楼层 节点  位置三个不同属性板切换
		public function viewFloorUpdate():void
		{
			//对楼层floorGroup更新
		//	EDConfig.instance.floorGroup.addAllFloor();
			//对节点nodeGroup更新
			if(EDConfig.instance.selectedFloor)
			{
				EDConfig.instance.nodeGroup.addNodeByFloor(EDConfig.instance.selectedFloor);
				//对位置positionGroup 更新
				EDConfig.instance.positionGroup.addPositionByFloor(EDConfig.instance.selectedFloor);
				//将楼层进行保存 防止楼层还在编辑
				EDConfig.instance.routeGroup.addRouteByFloorId(EDConfig.instance.selectedFloor.id);
				var map:Map = EDConfig.instance.e2Config.groundViewMap;
				
				EDConfig.instance.e2Config.groundViewMap[EDConfig.instance.selectedFloor.id].editSteps = false;
				if(EDConfig.instance.e2Config.floorViewMap[EDConfig.instance.selectedFloor.id])
					EDConfig.instance.e2Config.floorViewMap[EDConfig.instance.selectedFloor.id].childVisible = true;
				//反正位置还在编辑状态
				if(EDConfig.instance.selectedPosition)
				{
					EDConfig.instance.e2Config.utilLayer.clear();
					//防止在刚刚删除时候就切换到其他的 
					if(EDConfig.instance.e2Config.positionViewMap[EDConfig.instance.selectedPosition.id])
					{
						EDConfig.instance.e2Config.positionViewMap[EDConfig.instance.selectedPosition.id].update(); 
						EDConfig.instance.e2Config.positionViewMap[EDConfig.instance.selectedPosition.id].editStep = false;
					}
				}
			}
		}
		public function update():void
		{
			
			if(_config && floorsMap && positionArr && positionTypeMap && nodesMap && routesMap)
			{
				clear();
				updateFloor();
				updatePosition();
				updateNode();
				updateRoute();
				map = content;
			}
		}
		//更新路径
		protected function updateRoute():void
		{
			for each(var voRoute:E2VORoute in E2Provider.instance.routeMap)
			{
				if ( !voRoute.cross )
				{
					var route:Route = new Route(voRoute);
					EDConfig.instance.e2Config.routeViewMap[voRoute.id] = route;
					if(_config.serialViewMap[voRoute.serial1]&&_config.serialViewMap[voRoute.serial2])
					{
						_config.serialViewMap[voRoute.serial1].addRoute(route);
						_config.serialViewMap[voRoute.serial2].addRoute(route);
						storeINodeName(voRoute.node1);
						storeINodeName(voRoute.node2);
						var floor:Floor = floorsViewMap[route.floorID]
						floor.addRoute(route);
						
					}else
					{
						delete E2Provider.instance.routeMap[voRoute.id];
					}
					
				}
				//E2Config.instance.routeViewMap[voRoute.id] = route; 
				
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
		protected function updateNode():void
		{
			for each(var voNode:E2VONode in E2Provider.instance.nodeMap)
			{
				var node:Node = new Node(voNode,_config);
				
				var floor:Floor = floorsViewMap[voNode.floorID]
				if(floor)
				{
					floor.addNode(node);
					_config.nodeViewMap[voNode.id] = node;
					_config.serialViewMap[voNode.serial] = node;
				}
				//content.addChild(node);
			}
		}
		protected function updateFloor():void
		{
			
			for each(var voFloor:E2VOFloor in E2Provider.instance.floorArr)
			{
				var floor:Floor = new Floor(voFloor,_config);
				floor.visible = false;
				floorsViewMap[voFloor.id] = floor;
				content.addFloor(floor);
				
			}
		}
		public function addViewFloor(s:String,floor:Floor):void
		{
			content.addFloor(floor);
		  
			floorsViewMap[s] = floor;	
		}
		protected function updatePosition():void
		{
			for each(var voPosition:E2VOPosition in positionArr )
			{
				var position:Position = new Position(_config,voPosition);
				var floor:Floor = floorsViewMap[voPosition.floorID]
				if(floor)
				{
					floor.addPosition(position);
					_config.positionViewMap[voPosition.id] = position;
					_config.serialViewMap[voPosition.serial] = position;
				}
			}
		}
	
		public function set config($value:E2Config):void
		{
			if($value)
			{
				if($value is E2Config)
				{
					_config = $value;
				}
			}
		}
		public function get config():E2Config
		{
			return _config;
		}
		public function get font():String
		{
			return null;
		}
		public function set font($value:String):void
		{
			
		}
		
		public function get hallEnabled():Boolean
		{
			return false;
		}
		
		public function set hallEnabled($value:Boolean):void
		{
		}
		
		public function set floors($data:Map):void
		{
			floorsMap = $data;
			update();
		}
		
		public function set halls($data:Map):void
		{
			hallsMap = $data;
			update();
		}
		
		public function set positions($data:Array):void
		{
			positionArr = $data;
			update();
		}
		
		public function set positionTypes($data:Map):void
		{
			positionTypeMap = $data;
			update();
		}
		
		public function set nodes($data:Map):void
		{
			nodesMap = $data;
			update();	
		}
		
		public function set routes($data:Map):void
		{
			routesMap = $data;
			update();
		}
		
		override protected function caculateScale():void
		{
			super.caculateScale();
			maxScale = (maxScale<8) ? 8 : maxScale;
		}
		

		override public function set mapScale(value:Number):void
		{
			super.mapScale = value;
			if (floorNext) {
				floorNext.scale = value
			}
			//content.scale = value;
			utilLayer.scale = value;
			hRule.scale = vRule.scale = value;
			for each(var node:Node in _config.nodeViewMap)
			{
				node.scale = value;
			}
//			for each (var route:Route in _config.routeViewMap)
//			{
//				route.scale = value;	
//			}
		}
		override public function set mapX(value:Number):void
		{
			super.mapX = value;
			hRule.x = mapX;
		}
		override public function set mapY(value:Number):void
		{
			super.mapY = value;
			vRule.y = mapY;
		}
		
		//数字加刻度线
		private function initialize():void
		{
			
			addChild(ruleLayer = new Sprite);
			ruleLayer.addChild(hRule = new Rule);
			hRule.direction = "horizontal";
			ruleLayer.addChild(vRule = new Rule);
			vRule.direction = "vertical";
			
			var shape:Sprite = new Sprite;
			ruleLayer.addChild(shape);
			shape.graphics.beginFill(0xdce1e8);
			shape.graphics.drawRect(-20,-70,20,50);
			shape.graphics.beginFill(0xffffff);
			shape.graphics.drawRect(-20,-20,20,20);
			shape.graphics.endFill();
			
		} 
		public function get scale():Number
		{
			return _scale;
		}
		public function set scale(value:Number):void
		{
			if(value==scale) return;
			_scale = value;
			
			//gridLayer.scale = value;
			
			if (floorNext) {
				floorNext.scale = scale
			}
		}
		private var _scale:Number;
		public static const MAX_W:Number = 5000;
		public static const MAX_H:Number = 5000;
		private var ruleLayer:Sprite;
		private var hRule:Rule;
		private var vRule:Rule;
		private var hLine :Shape;
		private var vLine :Shape; 
		/**
		 * @private
		 */
		private var floorsViewArr:Array = []; 
		
		/**
		 * @private
		 */
		private var floorsMap:Map;
		
		/**
		 * @private
		 */
		private var floorsViewMap:Map;
		
		/**
		 * @private
		 */
		private var hallsMap:Map;
		
		/**
		 * @private
		 */
		private var hallsViewMap:Map;
		
		/**
		 * @private
		 */
		private var positionArr:Array;
		
		/**
		 * @private
		 */
		private var positionsMap:Map;
	
		/**
		 * @private
		 */
		private var positionsViewMap:Map;
		
		/**
		 * @private
		 */
		private var positionTypeMap:Map;
		
		/**
		 * @private
		 */
		private var floorNext:Floor;
		
		/**
		 * @private
		 */
		private var floorPrev:Floor;
		
		/**
		 * @private
		 */
		private var nodesMap:Map;
		
		/**
		 * @private
		 */
		private var routesMap:Map;
		
	
		/**
		 * @private
		 */
		em var font:String;
		private var content :MapContainer;
		
		private var utilLayer:UtilLayer;
		private var _config:E2Config;
	}
}