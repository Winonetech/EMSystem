package emap.vos
{
	
	/**
	 * 
	 * 位置类别。
	 * 
	 */
	
	
	import cn.vision.collections.Map;
	
	import com.winonetech.core.VO;
	
	
	public class VOPositionType extends VO
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function VOPositionType($data:Object = null)
		{
			super($data, "positionType");
		}
		
		
		/**
		 * 
		 * code
		 * 
		 * 
		 */
		
		public function get code():String
		{
			return getProperty("code");
		}
		
		
		/**
		 * 
		 * icon
		 * 
		 */
		
		public function get icon():String
		{
			return getProperty("icon");
		}
		
		
		/**
		 * 
		 * label
		 * 
		 */
		
		public function get label():String
		{
			return getProperty("label");
		}
		
		
		/**
		 * 
		 * 排序
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
		 * 是否可见
		 * 
		 */
		
		public function get visible():Boolean
		{
			return getProperty("visible", Boolean);
		}
		
		
		/**
		 * 
		 * position 集合。
		 * 
		 */
		
		public var positionMap:Map;
		
	}
}