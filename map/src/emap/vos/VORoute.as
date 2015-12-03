package emap.vos
{
	
	/**
	 * 
	 * 路径。
	 * 
	 */
	
	
	import com.winonetech.core.VO;
	
	import emap.consts.RouteTypeConsts;
	import emap.interfaces.INode;
	
	
	public class VORoute extends VO
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function VORoute($data:Object = null)
		{
			super($data, "route");
		}
		
		
		/**
		 * 
		 * 方向，
		 * 
		 */
		
		public function get direction():int 
		{
			return getProperty("direction", int);
		}
		
		
		/**
		 * 
		 * 是否为跨层路径，true为跨层，false为同层或无效路径。
		 * 
		 */
		
		public function get cross():Boolean
		{
			return (node1 && node2) ? node1.floorID != node2.floorID : false;
		}
		
		
		/**
		 * 
		 * node1ID。
		 * 
		 */
		
		public function get serial1():String
		{
			return getProperty("serial1");
		}
		
		
		/**
		 * 
		 * node2ID。
		 * 
		 */
		
		public function get serial2():String
		{
			return getProperty("serial2");
		}
		
		
		/**
		 * 
		 * node1。
		 * 
		 */
		
		public var node1:INode;
		
		
		/**
		 * 
		 * node2。
		 * 
		 */
		
		public var node2:INode;
		
	}
}