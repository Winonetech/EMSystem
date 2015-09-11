package emap.consts
{
	
	/**
	 * 
	 * 定义三种路径方向常量，双向，前进和后退。
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	
	
	public final class RouteDirectionConsts extends NoInstance
	{
		
		/**
		 * 
		 * 双向
		 * 
		 */
		
		public static const BIDIRECTIONAL:int = 0;
		
		
		/**
		 * 
		 * 只能从serial1至serial2
		 * 
		 */
		
		public static const FORWARD:int = 1;
		
		
		/**
		 * 
		 * 只能从serial2至serial1
		 * 
		 */
		
		public static const BACKWARD:int = -1;
		
	}
}