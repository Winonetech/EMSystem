package emap.map3d.finding
{
	
	/**
	 * 
	 * 路径，包含一组节点集合
	 * 
	 */
	
	
	import cn.vision.collections.Map;
	
	import emap.core.em;
	import emap.map3d.interfaces.IE3Node;
	import emap.map3d.vos.E3VORoute;
	import emap.utils.NodeUtil;
	import emap.utils.RouteUtil;
	import emap.vos.VOFloor;
	import emap.vos.VOPosition;
	import emap.vos.VORoute;
	
	
	public final class Path
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function Path($nodes:Vector.<IE3Node>, $start:IE3Node = null, $end:IE3Node = null)
		{
			initialize($nodes, $start, $end);
		}
		
		
		/**
		 * @private
		 */
		private function initialize($nodes:Vector.<IE3Node>, $start:IE3Node, $end:IE3Node):void
		{
			em::nodes = $nodes;
			if (nodes)
			{
				var l:int = nodes.length - 1;
				if (l >= 0)
				{
					em::start = $start ? $start : nodes[0];
					em::end   = $end   ? $end   : nodes[l];
					var end:IE3Node = em::end;
					em::block =!(end == nodes[l]);
					if(!block) resolve();
				}
				else
				{
					em::block = true;
				}
			}
		}
		
		/**
		 * 解析并返回路径所涉及的楼层。
		 * @private
		 */
		private function resolve():void
		{
			em::floors = new Map;
			em::routes = new Map;
			em::distance = 0;
			shows = new Vector.<IE3Node>;
			var l:uint = nodes.length;
			var i:uint = 0;
			var last:IE3Node;
			while (i < l)
			{
				var node:IE3Node = nodes[i];
				if (node)
				{
					var next:IE3Node = (i + 1 < l) ? nodes[i + 1] : null;
					//如果next不为空，则尚未遍历至路径终点，获取路径与计算路径长度。
					if (next)
					{
						var key:String = RouteUtil.getKey(node, next);
						var route:E3VORoute = routes[key] = nodes[i].routes[key];
						if(route==null)
						{
							trace("xxxxxxxxxxx");
						}
						em::distance += route.distance;
					}
					//如果是关键节点，需要验证接下一个节点是否同一类型，
					//如果是，则为连续跨过几层手扶电梯或楼梯的情况，这时会
					//省略中间的几个节点
					if(!(last && validateSameCode(last, node) && 
						(next && validateSameCode(last, next))))
					{
						last = NodeUtil.validateKeyNode(node) ? node : null;
						floors[node.floorID] = node.floorID;
						shows[shows.length] = node;
					}
				}
				i++;
			}
		}
		
		/**
		 * 验证两个节点是否为同一类型的关键节点。
		 * @private
		 */
		private function validateSameCode($node1:IE3Node, $node2:IE3Node):Boolean
		{
			if (NodeUtil.validateKeyNode($node1) && NodeUtil.validateKeyNode($node2))
			{
				var p1:VOPosition = $node1 as VOPosition;
				var p2:VOPosition = $node2 as VOPosition;
				return p1.typeCode == p2.typeCode;
			}
			return false;
		}
		
		
		/**
		 * 
		 * 路径是否是通的。
		 * 
		 */
		
		public function get block():Boolean
		{
			return em::block as Boolean;
		}
		
		
		/**
		 * 
		 * 路径键值索引。
		 * 
		 */
		
		public function get key():String
		{
			return RouteUtil.getKey(start, end);
		}
		
		
		/**
		 * 
		 * 路径长度。
		 * 
		 */
		
		public function get distance():Number
		{
			return em::distance;
		}
		
		
		/**
		 * 
		 * 终点。
		 * 
		 */
		
		public function get end():IE3Node
		{
			return nodes && nodes.length ? nodes[nodes.length - 1] : null;
		}
		
		/**
		 * 
		 * 起点。
		 * 
		 */
		
		public function get start():IE3Node
		{
			return nodes && nodes.length ? nodes[0] : null;
		}
		
		
		/**
		 * 
		 * 节点集合。
		 * 
		 */
		
		public function get nodes():Vector.<IE3Node>
		{
			return em::nodes;
		}
		
		
		/**
		 * 
		 * 路径集合。
		 * 
		 */
		
		public function get routes():Map
		{
			return em::routes;
		}
		
		
		/**
		 * 
		 * 路径包含的楼层ID集合。
		 * 
		 */
		
		public function get floors():Map
		{
			return em::floors;
		}
		
		
		/**
		 * @private
		 */
		private var finder:Finder;
		
		
		/**
		 * 存储省略了连续手扶梯或电梯过程的路径节点集合。
		 * @private
		 */
		internal var shows:Vector.<IE3Node>;
		
		
		/**
		 * @private
		 */
		em var block:Boolean = false;
		
		/**
		 * @private
		 */
		em var nodes:Vector.<IE3Node>;
		
		/**
		 * @private
		 */
		em var routes:Map;
		
		/**
		 * @private
		 */
		em var floors:Map;
		
		/**
		 * @private
		 */
		em var distance:Number;
		
		/**
		 * @private
		 */
		em var start:IE3Node;
		
		/**
		 * @private
		 */
		em var end:IE3Node;
		
	}
}