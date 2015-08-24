package emap.utils
{
	
	/**
	 * 
	 * 定义常用路径函数。
	 * 
	 */
	
	
	import cn.vision.collections.Map;
	import cn.vision.core.NoInstance;
	
	import emap.interfaces.INode;
	import emap.vos.VORoute;
	
	
	public final class RouteUtil extends NoInstance
	{
		
		/**
		 * 
		 * 获取两个节点之间的路径键值。
		 * 
		 * @param $start:INode 起始节点。
		 * @param $end:INode 终止节点。
		 * 
		 * @return String 键值。
		 * 
		 */
		
		public static function getKey($start:INode, $end:INode):String
		{
			if ($start && $end)
				var result:String = $start.serial + "," + $end.serial;
			return result;
		}
		
		
		/**
		 * 
		 * 获取两个节点之间的路径
		 * 
		 * @param $start:INode 起始节点。
		 * @param $end:INode 终止节点。
		 * @param $routes:Map 路径字典。
		 * 
		 * @return VORoute 节点之间路径。
		 * 
		 */
		
		public static function getRoute($start:INode, $end:INode):VORoute
		{
			return $start.routes[getKey($start, $end)];
		}
		
	}
}