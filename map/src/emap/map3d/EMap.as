package emap.map3d
{
	
	/**
	 * 
	 * 电子地图
	 * 
	 */
	
	
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.events.Event3D;
	
	import cn.vision.collections.Map;
	import cn.vision.utils.MathUtil;
	
	import emap.core.EMConfig;
	import emap.interfaces.IEMap;
	import emap.map3d.utils.Map3DUtil;
	import emap.tools.SourceManager;
	import emap.vos.VOFloor;
	import emap.vos.VOPosition;
	
	import flash.events.Event;
	
	
	public final class EMap extends Viewer3D implements IEMap
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function EMap()
		{
			super();
			
			initialize();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function find($start:String, $end:String):void
		{
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function reset($tween:Boolean = false):void
		{
			super.reset($tween);
			
			initializePosition ? viewPosition(initializePosition) : viewFloor(1);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function moveTo($x:Number, $y:Number, $tween:Boolean=false):void
		{
			cameraMoveX = $x + offsetX;
			cameraMoveY = $y + offsetY;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function viewPosition($data:*, $tween:Boolean = false):void
		{
			if ($data is Position)
			{
				var position:Position = $data;
			}
			else if ($data is String)
			{
				if (positionsViewMap) position = positionsViewMap[$data];
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
			if ($data is Floor)
				var floor:Floor = $data;
			else if ($data is VOFloor)
				floor = floorsViewMap[$data.id];
			else if ($data is String)
				floor = floorsViewMap[$data];
			else if ($data is uint)
				floor = floorsViewArr[MathUtil.clamp($data - 1, 0, floorsViewArr.length - 1)];
			
			if (floor && floor!= floorCurrent)
			{
				floorCurrent && (floorCurrent.visible = false);
				floorCurrent = floor;
				floorCurrent.visible = true;
				/*if ($tween)
				{
					
				}
				else
				{
					floorCurrent && (floorCurrent.visible = false);
					floorCurrent = floor;
					floorCurrent.visible = true;
				}*/
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function uploadAllSource():void
		{
			if (mapCreated && contextCreated)
			{
				SourceManager.uploadAllSources(main);
			}
		}
		
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			main.addChild(container = new Object3D);
		}
		
		/**
		 * @private
		 */
		private function update():void
		{
			if (floorsMap && positionsMap && positionTypesMap && (!hallEnabled || (hallEnabled && hallsMap)))
			{
				//remove all
				floorsViewMap = new Map;
				floorsViewArr.length = 0;
				positionsViewMap = new Map;
				
				for each (var voFloor:VOFloor in floorsMap)
				{
					var floor:Floor = new Floor(config, voFloor);
					floorsViewArr[floorsViewArr.length] = floor;
					floorsViewMap[floor.id] = floor;
					container.addChild(floor).visible = false;
				}
				floorsViewArr.sortOn("order", Array.NUMERIC);
				
				var order:Function = function($floor:Floor, $index:uint, $floors:Array):void
				{
					$floor.data.order = $index + 1;
				};
				floorsViewArr.forEach(order);
				
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
							position = new Position(config, positionVO);
							position.addEventListener(Event3D.ADDED, startRender);
							positionsViewMap[position.id] = position;
							floor.addPosition(position);
						}
						else
						{
							startRender();
						}
					}
					else
					{
						complete();
					}
				};
				
				startRender();
			}
		}
		
		/**
		 * @private
		 */
		private function complete():void
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
			container.y = - .5 * (minY + maxY);
			
			reset();
			
			uploadAllSource();
		}
		
		
		/**
		 * 
		 * 字体只能在初始化时设置，设置数据后不可实时更改。
		 * 
		 */
		
		public function set font($value:String):void
		{
			config.font = $value;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get hallEnabled():Boolean
		{
			return false;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function set hallEnabled($value:Boolean):void
		{
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function set floors($data:Map):void
		{
			floorsMap = $data;
			
			update();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function set halls($data:Map):void
		{
			hallsMap = $data;
			
			update();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function set positions($data:Array):void
		{
			if ($data)
			{
				positionsArr = $data.concat();
				positionsMap = Map3DUtil.analyzeArr(positionsArr);
				
				update();
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function set positionTypes($data:Map):void
		{
			positionTypesMap = $data;
			
			update();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function set nodes($data:Map):void
		{
			nodesMap = $data;
			
			update();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function set routes($data:Map):void
		{
			routesMap = $data;
			
			update();
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
		private var container:Object3D;
		
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
		private var floorCurrent:Floor;
		
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
		private var positionsMap:Map;
		
		/**
		 * @private
		 */
		private var positionTypesMap:Map;
		
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
		private const config:EMConfig = new EMConfig;
		
	}
}
