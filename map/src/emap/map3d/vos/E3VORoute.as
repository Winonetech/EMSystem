package emap.map3d.vos
{
	
	/**
	 * 
	 * 路径
	 * 
	 */
	
	
	import emap.consts.RouteTypeConsts;
	import emap.core.em;
	import emap.interfaces.INode;
	import emap.map3d.interfaces.IE3Node;
	import emap.utils.NodeUtil;
	import emap.vos.VORoute;
	
	import flash.geom.Point;
	
	
	public final class E3VORoute extends VORoute
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function E3VORoute($data:Object = null)
		{
			super($data);
		}
		
		
		/**
		 * 
		 * 获取当前路径的另外一个节点
		 * 
		 * @node:INode 路径的其中一个节点
		 * 
		 */
		
		public function getAnotherNode($node:INode):INode
		{
			if (node1 == $node || node2 == $node)
			{
				var a:Boolean = ($node == node1);
				var node:INode = a ? node2 : node1;
			}
			return node;
		}
		
		
		/**
		 * 
		 * 距离，
		 * 
		 */
		
		public function get distance():Number
		{
			if (isNaN(em::distance))
			{
				em::distance = NodeUtil.distance(node1, node2);
			}
			return em::distance;
		}
		
		
		/**
		 * @private
		 */
		em var distance:Number;
		
	}
}