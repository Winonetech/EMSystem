package emap.map3d.finding
{
	
	/**
	 * 
	 * 路径寻找
	 * 
	 */
	
	
	import alternativa.engine3d.core.Object3D;
	
	import cn.vision.collections.Map;
	import cn.vision.core.VSObject;
	
	import emap.consts.RouteDirectionConsts;
	import emap.interfaces.INode;
	import emap.map3d.EMap3D;
	import emap.map3d.interfaces.IE3Node;
	import emap.map3d.vos.E3VORoute;
	import emap.utils.PositionUtil;
	import emap.utils.RouteUtil;
	import emap.vos.VONode;
	import emap.vos.VOPosition;
	
	
	public final class Finder extends VSObject
	{
		
		/**
		 * 
		 * 构造函数
		 * 
		 */
		
		public function Finder($emap3d:EMap3D, $container:Object3D)
		{
			super();
			
			initialize($emap3d, $container);
		}
		
		
		/**
		 * 
		 * 寻路。
		 * 
		 */
		public function find($start:*, $end:*, $tween:Boolean = false):void
		{
			if ($start is IE3Node)
				var node1:IE3Node = $start;
			else if ($start is String)
				node1 = totalNetwork[$start];
			
			if ($end is IE3Node)
				var node2:IE3Node = $end;
			else if ($end is String)
				node2 = totalNetwork[$end];
			
			if (node1 && node2 && node1 != node2)
			{
				if (node1.floorID == node2.floorID)
				{
					var network:Network = floorNetwork[node1.floorID];
					if (network) var path:Path = network.find(node1, node2);
				}
				else	
				{
					path = keyNetwork.find(node1, node2);
				}
				shower.show(path, $tween);
			}
		}
		
		
		/**
		 * @private
		 */
		private function update():void
		{
			if (floorsMap && positionTypesMap && positionsArr && nodesMap && routesMap)
			{
				clear();
				
				setupPositions();
				
				setupNodes();
				
				setupRoutes();
			}
		}
		
		/**
		 * @private
		 */
		private function clear():void
		{
			totalNetwork = new Map;
			floorNetwork = new Map;
			pathesMap    = new Map;
			keyNetwork   = new Keywork(floorNetwork);
		}
		
		/**
		 * @private
		 */
		private function initialize($emap3d:EMap3D, $container:Object3D):void
		{
			shower = new Shower($emap3d, $container);
			shower.toEnd = false;
		}
		
		/**
		 * @private
		 */
		private function setupPositions():void
		{
			for each (var position:VOPosition in positionsArr)
			{
				totalNetwork[position.serial] = position;
				floorNetwork[position.floorID] = floorNetwork[position.floorID] || new Network;
				floorNetwork[position.floorID].addNode(position);
				
				if (PositionUtil.validateCrossFloor(position.typeCode))
					keyNetwork.addNode(position);
			}
		}
		
		/**
		 * @private
		 */
		private function setupNodes():void
		{
			for each (var node:VONode in nodesMap)
			{
				totalNetwork[node.serial] = node;
				floorNetwork[node.floorID] = floorNetwork[node.floorID] || new Network;
				floorNetwork[node.floorID].addNode(node);
			}
		}
		
		/**
		 * @private
		 */
		private function setupRoutes():void
		{
			for each (var route:E3VORoute in routesMap)
			{
				var node1:INode = totalNetwork[route.serial1];
				var node2:INode = totalNetwork[route.serial2];
				if (node1 && node2)
				{
					if (route.direction == RouteDirectionConsts.FORWARD || 
						route.direction == RouteDirectionConsts.BIDIRECTIONAL)
						node1.routes[RouteUtil.getKey(node1, node2)] = route;
					
					if (route.direction == RouteDirectionConsts.BACKWARD || 
						route.direction == RouteDirectionConsts.BIDIRECTIONAL)
						node2.routes[RouteUtil.getKey(node2, node1)] = route;
					
					if (node1.floorID == node2.floorID)
						floorNetwork[node1.floorID].addRoute(route);
					else
						keyNetwork.addRoute(route);
				}
			}
		}
		
		
		/**
		 * @private
		 */
		public function set floors($value:Map):void
		{
			floorsMap = $value;
			
			update();
		}
		
		/**
		 * @private
		 */
		public function set positionTypes($value:Map):void
		{
			positionTypesMap = $value;
			
			update();
		}
		
		/**
		 * @private
		 */
		public function set positions($value:Array):void
		{
			positionsArr = $value;
			
			shower.positionArr = positionsArr;
			
			update();
		}
		
		/**
		 * @private
		 */
		public function set nodes($value:Map):void
		{
			nodesMap = $value;
			
			update();
		}
		
		/**
		 * @private
		 */
		public function set routes($value:Map):void
		{
			routesMap = $value;
			
			update();
		}
		
		
		/**
		 * @private
		 */
		public var shower:Shower;
		
		/**
		 * @private
		 */
		private var keyNetwork:Keywork;
		
		/**
		 * @private
		 */
		private var totalNetwork:Map;
		
		/**
		 * @private
		 */
		private var floorNetwork:Map;
		
		/**
		 * @private
		 */
		private var pathesMap:Map;
		
		/**
		 * @private
		 */
		private var floorsMap:Map;
		
		/**
		 * @private
		 */
		private var positionTypesMap:Map;
		
		/**
		 * @private
		 */
		private var positionsArr:Array;
		
		/**
		 * @private
		 */
		private var nodesMap:Map;
		
		/**
		 * @private
		 */
		private var routesMap:Map;
		
	}
}