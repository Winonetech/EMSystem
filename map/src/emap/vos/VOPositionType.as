package emap.vos
{
	
	/**
	 * 
	 * 位置类别。
	 * 
	 */
	
	
	import cn.vision.collections.Map;
	
	import com.winonetech.core.VO;
	
	
	public final class VOPositionType extends VO
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function VOPositionType($json:Object = null)
		{
			super($json);
		}
		
		
		/**
		 * 
		 * 代码数据。
		 * 
		 */
		
		public function get code():String
		{
			return getProperty("code");
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
		 * 排序。
		 * 
		 */
		
		public function get order():uint
		{
			return getProperty("order", uint);
		}
		
		/**
		 * @private
		 */
		public function set order($value:uint):void
		{
			setProperty("order", $value);
		}
		
		
		/**
		 * 
		 * position 集合。
		 * 
		 */
		
		public var positionMap:Map;
		
	}
}