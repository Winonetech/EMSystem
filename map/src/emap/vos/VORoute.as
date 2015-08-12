package emap.vos
{
	
	/**
	 * 
	 * 路径。
	 * 
	 */
	
	
	import com.winonetech.core.VO;
	
	import emap.consts.RouteTypeConsts;
	import emap.core.em;
	
	
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
		 * 类型，如果是曲线时，ctrlX与ctrlY属性可用。
		 * 
		 */
		
		public function get type():String
		{
			return getProperty("type");
		}
		
		
		/**
		 * 
		 * 控制X，只在类型为曲线时该值可用
		 * 
		 */
		
		public function get ctrlX():Number
		{
			return type == RouteTypeConsts.CURVE ? getProperty("ctrlX", Number) : NaN;
		}
		
		
		/**
		 * 
		 * 控制Y，只在类型为曲线时该值可用
		 * 
		 */
		
		public function get ctrlY():Number
		{
			return type == RouteTypeConsts.CURVE ? getProperty("ctrlY", Number) : NaN;
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
		
		em function get node1():VONode
		{
			return getRelation(VONode, serial1);
		}
		
		
		/**
		 * 
		 * node2。
		 * 
		 */
		
		em function get node2():VONode
		{
			return getRelation(VONode, serial2);
		}
		
	}
}