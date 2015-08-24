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
	import emap.utils.RouteUtil;
	
	
	public final class Path
	{
		
		/**
		 * 
		 * 构造函数
		 * 
		 */
		
		public function Path($nodes:Vector.<IE3Node>, $routes:Map)
		{
			initialize($nodes, $routes);
		}
		
		
		/**
		 * @private
		 */
		private function initialize($nodes:Vector.<IE3Node>, $routes:Map):void
		{
			em::nodes = $nodes;
			em::routes = $routes;
			if (nodes)
			{
				var l:uint = nodes.length - 1;
				if (l > 0)
				{
					em::distance = 0;
					for each (var route:E3VORoute in routes)
						em::distance += route.distance;
				}
			}
		}
		
		
		/**
		 * 
		 * 路径键值索引
		 * 
		 */
		
		public function get key():String
		{
			return RouteUtil.getKey(start, end);
		}
		
		
		/**
		 * 
		 * 路径长度
		 * 
		 */
		
		public function get distance():Number
		{
			return em::distance;
		}
		
		
		/**
		 * 
		 * 终点
		 * 
		 */
		
		public function get end():IE3Node
		{
			return nodes && nodes.length ? nodes[nodes.length - 1] : null;
		}
		
		/**
		 * 
		 * 起点
		 * 
		 */
		
		public function get start():IE3Node
		{
			return nodes && nodes.length ? nodes[0] : null;
		}
		
		
		/**
		 * 
		 * 节点集合
		 * 
		 */
		
		public function get nodes():Vector.<IE3Node>
		{
			return em::nodes;
		}
		
		
		/**
		 * 
		 * 路径集合
		 * 
		 */
		
		public function get routes():Map
		{
			return em::routes;
		}
		
		
		/**
		 * @private
		 */
		private var finder:Finder;
		
		
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
		em var distance:Number;
		
	}
}