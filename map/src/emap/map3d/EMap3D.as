package emap.map3d
{
	
	/**
	 * 
	 * 电子地图。
	 * 
	 */
	
	
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.events.Event3D;
	import alternativa.engine3d.core.events.MouseEvent3D;
	
	import caurina.transitions.Tweener;
	
	import cn.vision.collections.Map;
	import cn.vision.utils.MathUtil;
	
	import emap.consts.PositionCodeConsts;
	import emap.core.EMConfig;
	import emap.core.em;
	import emap.events.MapEvent;
	import emap.interfaces.IEMap;
	import emap.map3d.core.E3Config;
	import emap.map3d.finding.Finder;
	import emap.map3d.tools.SourceEmap3D;
	import emap.vos.VOEMap;
	import emap.vos.VOFloor;
	import emap.vos.VOPosition;
	
	import flash.events.Event;
	import flash.text.Font;
	
	
	public final class EMap3D extends Viewer3D implements IEMap
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function EMap3D($config:EMConfig = null)
		{
			super();
			
			initialize($config);
		}
		
		
		
		/**
		 * 
		 * 寻路。
		 * 
		 * @param $start:String 起始节点序列号。
		 * @param $end:String 终止节点序列号。
		 * 
		 */
		
		public function find($start:String, $end:String, $tween:Boolean = false):void
		{
			finder.find($start, $end, $tween);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function reset($tween:Boolean = false):void
		{
			super.reset($tween);
			
			initializePosition ? viewPosition(initializePosition, $tween) : viewFloor(1, $tween);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function moveTo($x:Number, $y:Number, $tween:Boolean = true):void
		{
			aimCameraMoveX = $x + offsetX;
			aimCameraMoveY =-$y + offsetY;
			
			if ($tween)
			{
				updateTween();
			}
			else
			{
				cameraMoveX = aimCameraMoveX;
				cameraMoveY = aimCameraMoveY;
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function viewPosition($data:*, $tween:Boolean = false):void
		{
			if ($data is Position)
				var position:Position = $data;
			else if ($data is String)
			{
				if (isNaN(Number($data)) && positionSerialMap) 
					position = positionSerialMap[$data];
				else if (positionsViewMap) 
					position = positionsViewMap[$data];
			}
			
			if (position)
			{
				viewFloor(position.floor, $tween);
				moveTo(position.layout.cenX, position.layout.cenY, $tween);
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function viewFloor($data:*, $tween:Boolean = false):void
		{
			em::viewFloors($data, $tween);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function uploadAllSource():void
		{
			if (mapCreated && contextCreated)
				
				SourceEmap3D.uploadAllSources(main);
		}
		
		
		/**
		 * 
		 * 查看楼层，并返回楼层的Z坐标位置。
		 * 
		 */
		
		em function viewFloors($data:*, $tween:Boolean = false):*
		{
			
			var map:Map = new Map, arr:Array = [];
			var add:Function = function(item:*):void
			{
				var floor:Floor = resolveFloor(item);
				if (floor)
				{
					map[floor.id] = floor;
					arr[arr.length] = floor;
				}
			};
			
			if ($data is Array || $data is Map)
				for each (var item:* in $data) add(item);
			else
				add($data);
			
			arr.sortOn("order", Array.NUMERIC);
			//切换楼层的时候 将上一次路径清空
			if(finder)
				finder.shower.clear();
			//计算需要显示的楼层的目标Z值
			var l:uint = arr.length;
			if (l)
			{
				var m:uint = arr[uint(l * .5)].order;
				var d:Number = cameraDistance;
				var s:Number = -floorSpace * .5 * (l - 1);
				var ends:Object = {};
				for (var i:uint = 0; i < l; i++) ends[arr[i].id] = floorSpace * i + s;
			}
			var t:uint = floorsViewArr.length;
			//遍历所有楼层
			for (i = 0; i < t; i++)
			{
				var floor:Floor = floorsViewArr[i];
				//判断该楼层是否需要显示
				if (map[floor.id])
				{
					if ($tween)
					{
						//判断切换前是否显示
						if (floor.visible)
						{
							//清除缓动
							Tweener.removeTweens(floor);
						}
						else
						{
							//移动至起始目标Z值，设置为显示
							floor.z = (floor.order < m) ? -d :
								(floor.order == m ? (middle < m ? d : -d) : d);
							floor.visible = true;
						}
						//添加缓动至终止目标Z值
						Tweener.addTween(floor, {z:ends[floor.id], time:1});
					}
					else
					{
						Tweener.removeTweens(floor);
						floor.z = ends[floor.id];
						floor.visible = true;
					}
				}
				else
				{
					if ($tween)
					{
						//判断切换前是否显示
						if (floor.visible&&arr.length>0)
						{
							//如果order在范围之内，则直接消失，否则移动至目标位置后消失
							arr[0].order;
							if (arr[0].order < floor.order && floor.order < arr[l - 1].order)
							{
								floor.visible = false;
							}
							else
							{
								Tweener.addTween(floor, {z:(arr[0].order > floor.order ? -d : d),
									time:1, onComplete:floor.reset});
							}
						}
					}
					else
					{
						floor.reset();
					}
				}
			}
			//记录最中间的一个楼层
			middle = m;
			return ends;
			
			
		}
		
		
		/**
		 * @private
		 */
		private function clear():void
		{
			//remove all
			floorsViewArr.length = 0;
			floorsViewMap = new Map;
			positionsViewMap = new Map;
			positionSerialMap = new Map;
			while (floorContainer.numChildren) floorContainer.removeChildAt(0);
			//finder clear
		}
		
		/**
		 * @private
		 */
		private function resolveFloor($data:*):Floor
		{
			if ($data is Floor)
				var floor:Floor = $data;
			else if ($data is VOFloor)
				floor = floorsViewMap[$data.id];
			else if ($data is String)
				floor = floorsViewMap[$data];
			else if ($data is uint)
				floor = floorsViewArr[MathUtil.clamp($data - 1, 0, floorsViewArr.length - 1)];
			return floor;
		}
		
		/**
		 * @private
		 */
		private function initialize($config:EMConfig):void
		{
			config = $config;
			main.addChild(container = new Object3D);
			main.addEventListener(MouseEvent3D.CLICK, handlerClick);
			container.addChild(floorContainer = new Object3D);
			container.addChild(pathContainer  = new Object3D);
			finder = new Finder(this, pathContainer);
			maxCameraDistance = 10000;
		}
		
		/**
		 * @private
		 */
		private function update():void
		{
			if (emConfig && floorsMap && positionsArr && positionTypesMap && (!hallEnabled || (hallEnabled && hallsMap)))
			{
				clear();
				
				updateFloors();
				
				updatePositions();
			}
		}
		
		/**
		 * @private
		 */
		private function updateFloors():void
		{
			for each (var voFloor:VOFloor in floorsMap)
			{
				var floor:Floor = new Floor(emConfig, voFloor);
				floorsViewArr[floorsViewArr.length] = floor;
				floorsViewMap[floor.id] = floor;
				floorContainer.addChild(floor).visible = false;
			}
			
			floorsViewArr.sortOn("order", Array.NUMERIC);
			
			var order:Function = function($floor:Floor, $index:uint, $floors:Array):void
			{
				$floor.data.order = $index + 1;
			};
			floorsViewArr.forEach(order);
		}
		
		/**
		 * @private
		 */
		private function updatePositions():void
		{
			var l:uint = positionsArr.length, f:uint = 0, position:Position;
			var startRender:Function = function($e:Event = null):void
			{
				if (position) 
				{
					position.removeEventListener(Event3D.ADDED, startRender);
					position = null;
				}
				if (f < l)
				{
					var positionVO:VOPosition = positionsArr[f++];
					var floor:Floor = floorsViewMap[positionVO ? positionVO.floorID : null];
					if (positionVO && floor)
					{
						position = new Position(emConfig, positionVO);
						position.addEventListener(Event3D.ADDED, startRender);
						positionSerialMap[positionVO.serial] = position;
						positionsViewMap[position.id] = position;
						if(positionVO.typeCode == PositionCodeConsts.Area )
						{
							position.mouseEnabled =false;
							position.mouseChildren = false;
						}
						floor.addPosition(position);
					}
					else
					{
						startRender();
					}
				}
				else
				{
					updateComplete();
					uploadAllSource();
					
					reset();
				}
			};
			startRender();
		}
		
		/**
		 * @private
		 */
		private function updateComplete():void
		{
			mapCreated = true;
			
			for each (floor in floorsViewMap) floor.completeSteps();
			
			var minxs:Array = [], minys:Array = [], maxxs:Array = [], maxys:Array = [];
			for each (var floor:Floor in floorsViewMap)
			{
				minxs[minxs.length] = floor.layout.minX;
				minys[minys.length] = floor.layout.minY;
				maxxs[maxxs.length] = floor.layout.maxX;
				maxys[maxys.length] = floor.layout.maxY;
			}
			
			var minX:Number = Math.min.apply(null, minxs);
			var minY:Number = Math.min.apply(null, minys);
			var maxX:Number = Math.max.apply(null, maxxs);
			var maxY:Number = Math.max.apply(null, maxys);
			
			container.x = - .5 * (minX + maxX);
			container.y =   .5 * (minY + maxY);
		}
		
		
		/**
		 * @private
		 */
		private function handlerClick($e:MouseEvent3D):void
		{
			if ($e.target is Position)
			{
				var position:Position = $e.target as Position;
				position.selected = !position.selected;
				
				dispatchEvent(new MapEvent(MapEvent.POSITION_CLICK, position.data.serial));
			}
		}
		
		
		/**
		 * 
		 * 字体只能在初始化时设置，设置数据后不可实时更改。
		 * 
		 */
		
		public function get font():String
		{
			return emConfig ? emConfig.font : null;
		}
		
		/**
		 * @private
		 */
		public function set font($value:String):void
		{
			if (emConfig) emConfig.font = $value;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get hallEnabled():Boolean
		{
			return emConfig.hallEnabled;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function set config($value:VOEMap):void
		{
			if ($value)
			{
				if ($value is E3Config)
				{
					emConfig = $value as E3Config;
					initializePosition = emConfig.initializePosition;
				}
				else
					throw new ArgumentError("参数必须为EMConfig类型", 3001);
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function set floors($data:Map):void
		{
			finder.floors = floorsMap = $data;
			
			update();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function set halls($data:Map):void
		{
			hallsMap = $data;
			
			if (hallEnabled) update();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function set positions($data:Array):void
		{
			finder.positions = positionsArr = $data;
			
			update();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function set positionTypes($data:Map):void
		{
			finder.positionTypes = positionTypesMap = $data;
			
			update();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function set nodes($data:Map):void
		{
			finder.nodes = $data;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function set routes($data:Map):void
		{
			finder.routes = $data;
		}
		
		
		/**
		 * @private
		 */
		private function get offsetX():Number
		{
			return container.x;
		}
		
		/**
		 * @private
		 */
		private function get offsetY():Number
		{
			return container.y;
		}
		
		/**
		 * @private
		 */
		private function get floorSpace():Number
		{
			return emConfig && emConfig.floorSpace > 0 ? emConfig.floorSpace : 500;
		}
		
		
		/**
		 * 
		 * 初始位置
		 * 
		 */
		
		public var initializePosition:String;
		
		
		/**
		 * @private
		 */
		private var mapCreated:Boolean;
		
		/**
		 * @private
		 */
		private var middle:uint;
		
		/**
		 * @private
		 */
		private var finder:Finder;
		
		/**
		 * @private
		 */
		private var container:Object3D;
		
		/**
		 * @private
		 */
		private var pathContainer:Object3D;
		
		/**
		 * @private
		 */
		private var floorContainer:Object3D;
		
		/**
		 * @private
		 */
		private var floorsViewArr:Array = [];
		
		/**
		 * @private
		 */
		private var floorsViewMap:Map;
		
		/**
		 * @private
		 */
		private var hallsViewMap:Map;
		
		/**
		 * @private
		 */
		private var positionsViewMap:Map;
		
		/**
		 * @private
		 */
		private var floorsMap:Map;
		
		/**
		 * @private
		 */
		private var hallsMap:Map;
		
		/**
		 * @private
		 */
		private var positionsArr:Array;
		
		/**
		 * @private
		 */
		private var positionTypesMap:Map;
		
		/**
		 * @private
		 */
		private var positionSerialMap:Map;
		
		/**
		 * @private
		 */
		private var emConfig:E3Config;
		
	}
}
