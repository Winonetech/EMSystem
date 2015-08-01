package emap.vos
{
	
	/**
	 * 
	 * 商场数据结构。
	 * 
	 */
	
	
	import cn.vision.collections.Map;
	
	import com.winonetech.core.VO;
	
	
	public final class VOEMap extends VO
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function VOEMap($json:Object = null)
		{
			super($json);
		}
		
		
		/**
		 * 
		 * logo
		 * 
		 */
		
		public function get logo():String
		{
			return getProperty("logo");
		}
		
		
		/**
		 * 
		 * 启用场馆。
		 * 
		 */
		
		public function get hallEnabled():Boolean
		{
			return getProperty("hallEnabled");
		}
		
		
		/**
		 * 
		 * hall 集合。
		 * 
		 */
		
		public var hallMap:Map;
		
		
		/**
		 * 
		 * floor 集合，在没有馆的情况下，使用该集合。
		 * 
		 */
		
		public var floorMap:Map;
		
	}
}