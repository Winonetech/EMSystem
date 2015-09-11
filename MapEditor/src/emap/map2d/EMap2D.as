package emap.map2d
{
	import cn.vision.collections.Map;
	import cn.vision.utils.MathUtil;
	
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
		public function EMap2D()
		{
			super();
			initialize();
			content = new MapContainer;
			//addFloor();
			utilLayer = E2Config.instance.utilLayer;
			content.addChild(utilLayer);
			map = content;
			//map = new Map
		}
		
		
		public function clear():void
		{
			floorsViewMap = new Map;
			floorsViewArr.length = 0;
			positionsViewMap = new Map;
		//	content.clear();
		}
		
		public function viewPosition($data:*, $tween:Boolean=false):void
		{
			
		}
		
		public function viewFloor($data:*, $tween:Boolean=false):void
		{
			if ($data is Floor)
				var floor:Floor = $data;
			else if ($data is VOFloor)
				floor = floorsViewMap[$data.id];
			else if ($data is String)
				floor = floorsViewMap[$data];
			else if ($data is uint)
				floor = floorsViewArr[MathUtil.clamp($data - 1, 0, floorsViewArr.length - 1)];
			
			if (floor && floor!= floorNext)
			{
				floorPrev = floorNext;
				floorNext = floor;
				floorNext.visible = true;
			
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
		protected function updateRoute():void
		{
			for each(var voRoute:E2VORoute in E2Provider.instance.routeMap)
			{
				if (!voRoute.cross)
				{
					var route:Route = new Route(voRoute);
					content.addChild(route);
				}
				//E2Config.instance.routeViewMap[voRoute.id] = route; 
			}
		}
		protected function updateNode():void
		{
			for each(var voNode:E2VONode in E2Provider.instance.nodeMap)
			{
				var node:Node = new Node(voNode);
				
				var floor:Floor = floorsViewMap[voNode.floorID]
				floor.addChild(node);
				E2Config.instance.nodeViewMap[voNode.id] = node;
				//content.addChild(node);
			}
		}
		protected function updateFloor():void
		{
			
			for each(var voFloor:E2VOFloor in E2Provider.instance.floorArr)
			{
				var floor:Floor = new Floor(voFloor);
				floor.visible = false;
				floorsViewMap[voFloor.id] = floor;
				content.addFloor(floor);
				
			}
		}
		protected function updatePosition():void
		{
			for each(var voPosition:E2VOPosition in positionArr )
			{
				trace(voPosition.label)
				var position:Position = new Position(_config,voPosition);
				var floor:Floor = floorsViewMap[voPosition.floorID]
				floor.addChild(position);
				E2Config.instance.positionMap[voPosition.id] = position;
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
			//maxScale = (maxScale<4) ? 4 : maxScale;
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
			for each(var node:Node in E2Config.instance.nodeViewMap)
			{
				node.scale = value;
			}
			for each (var route:Route in E2Config.instance.routeViewMap)
			{
				route.scale = value;	
			}
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
		public function createAidLine(style:String, value:Number):void
		{
			
			if (style=="x") {
				hLine.graphics.clear();
				hLine.graphics.lineStyle(.1, 0x33FF00);
				hLine.graphics.moveTo(value, 0);
				hLine.graphics.lineTo(value, MAX_H);
			} else {
				vLine.graphics.clear();
				vLine.graphics.lineStyle(.1, 0x33FF00);
				vLine.graphics.moveTo(0    , value);
				vLine.graphics.lineTo(MAX_W, value);
			}
		}
		
		public function clearAidLine (style:String=null):void
		{
			if (style=="x") {
				hLine.graphics.clear();
			} else if (style=="y") {
				vLine.graphics.clear();
			} else {
				hLine.graphics.clear();
				vLine.graphics.clear();
			}
		}
		
		private function initialize():void
		{
			addChild(ruleLayer = new Sprite);
			ruleLayer.addChild(hRule = new Rule);
			hRule.direction = "horizontal";
			ruleLayer.addChild(vRule = new Rule);
			vRule.direction = "vertical";
			
			var shape:Sprite = new Sprite;
			ruleLayer.addChild(shape);
			shape.graphics.beginFill(0xFFFFFF);
			shape.graphics.drawRect(-15,-15,15,15)
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