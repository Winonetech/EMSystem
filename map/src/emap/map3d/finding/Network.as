package emap.map3d.finding
{
	
	/**
	 * 
	 * 网格
	 * 
	 */
	
	
	import cn.vision.collections.Map;
	import cn.vision.core.VSObject;
	import cn.vision.utils.ArrayUtil;
	
	import emap.consts.RouteDirectionConsts;
	import emap.core.em;
	import emap.interfaces.INode;
	import emap.map3d.Floor;
	import emap.map3d.interfaces.IE3Node;
	import emap.map3d.vos.E3VORoute;
	import emap.utils.NodeUtil;
	import emap.utils.RouteUtil;
	import emap.vos.VOFloor;
	
	
	public class Network extends VSObject
	{
		
		/**
		 * 
		 * 构造函数
		 * 
		 */
		
		public function Network()
		{
			super();
			
			initialize();
		}
		
		
		/**
		 * 
		 * 添加节点
		 * 
		 */
		
		public function addNode($node:INode):void
		{
			nodes[$node.serial] = $node;
		}
		
		
		/**
		 * 
		 * 添加路径
		 * 
		 */
		
		public function addRoute($route:E3VORoute):void
		{
			var node1:IE3Node = nodes[$route.serial1];
			var node2:IE3Node = nodes[$route.serial2];
			if (node1 && node2)
			{
				if ($route.direction == RouteDirectionConsts.FORWARD || 
					$route.direction == RouteDirectionConsts.BIDIRECTIONAL)
					routes[RouteUtil.getKey(node1, node2)] = $route;
				
				if ($route.direction == RouteDirectionConsts.BACKWARD || 
					$route.direction == RouteDirectionConsts.BIDIRECTIONAL)
					routes[RouteUtil.getKey(node2, node1)] = $route;
			}
		}
		
		
		/**
		 * 
		 * 寻路
		 * 
		 */
		
		public function find($node1:IE3Node, $node2:IE3Node):Path
		{
			if ($node1 && $node2)
			{
				var key:String = RouteUtil.getKey($node1, $node2);
				if(!pathes[key])
				{
					setup($node1, $node2);
					pathes[key] = new Path(findPath(), start, end);
				}
			}
			return pathes[key];
		}
		
		
		/**
		 * @private
		 */
		private function compare($a:IE3Node, $b:IE3Node):Number
		{
			return NodeUtil.distance($a, end) - NodeUtil.distance($b, end);
		}
		
		/**
		 * @private
		 */
		private function findPath($node:IE3Node = null, $path:Vector.<IE3Node> = null):Vector.<IE3Node>
		{
			$node = $node || start;
			$path = $path || new Vector.<IE3Node>;
			if(!finded)
			{
				finded = $node == end;
				ArrayUtil.push($path, $node);
				if (!finded)
				{
					var neighbors:Vector.<IE3Node> = findNeighbors($node);
					if (neighbors && neighbors.length)
					{
						for each (var neighbor:IE3Node in neighbors) 
						{
							findPath(neighbor, $path);
						}
					}
				}
			}
			if(!finded)
			{
				$path.pop();
			}
			return $path;
		}
		
		/**
		 * @private
		 */
		private function findNeighbors($node:IE3Node):Vector.<IE3Node>
		{
			for each (var route:E3VORoute in $node.routes)
			{
				var other:IE3Node = route.getAnotherNode($node) as IE3Node;
				if(other && !ergodic[other.serial] && nodes[other.serial])
				{
					ergodic[other.serial] = other;
					var temp:Vector.<IE3Node> = temp || new Vector.<IE3Node>;
					ArrayUtil.push(temp, other);
				}
			}
			if (temp) temp.sort(compare);
			return temp;
		}
		
		/**
		 * @private
		 */
		protected function getRoute($start:INode, $end:INode):E3VORoute
		{
			return RouteUtil.getRoute($start, $end) as E3VORoute;
		}
		
		/**
		 * @private
		 */
		protected function setup($node1:IE3Node, $node2:IE3Node):void
		{
			ergodic.clear();
			finded = false;
			start = $node1;
			end = $node2;
			ergodic[start.serial] = start;
		}
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			nodes   = new Map;
			routes  = new Map;
			pathes  = new Map;
			ergodic = new Map;
		}
		
		
		/**
		 * @private
		 */
		protected var start:IE3Node;
		
		/**
		 * @private
		 */
		protected var end:IE3Node;
		
		/**
		 * @private
		 */
		protected var finded:Boolean;
		
		/**
		 * @private
		 */
		protected var ergodic:Map;
		
		/**
		 * @private
		 */
		protected var nodes:Map;
		
		/**
		 * @private
		 */
		protected var routes:Map;
		
		/**
		 * @private
		 */
		protected var pathes:Map;
		
	}
}