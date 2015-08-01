package emap.vos
{
	
	/**
	 * 
	 * 场馆，区域。
	 * 
	 */
	
	
	import cn.vision.collections.Map;
	
	import com.winonetech.core.VO;
	
	
	public final class VOHall extends VO
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function VOHall($json:Object = null)
		{
			super($json);
		}
		
		
		/**
		 * 
		 * name
		 * 
		 */
		
		public function get name():String
		{
			return getProperty("name");
		}
		
		
		/**
		 * 
		 * order
		 * 
		 */
		
		public function get order():uint
		{
			return getProperty("order", uint);
		}
		
		/**
		 * 
		 */
		public function set order($value:uint):void
		{
			setProperty("order", $value);
		}
		
		
		/**
		 * 
		 * floor collection
		 * 
		 */
		
		public var floorMap:Map;
		
	}
}