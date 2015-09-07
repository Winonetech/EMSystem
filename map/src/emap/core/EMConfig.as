package emap.core
{
	
	
	import emap.vos.VOEMap;
	
	
	public class EMConfig extends VOEMap
	{
		
		/**
		 * 
		 * 构造函数
		 * 
		 */
		
		public function EMConfig($data:Object = null)
		{
			super($data);
		}
		
		
		/**
		 * 
		 * 字体
		 * 
		 */
		
		public function get font():String
		{
			return getProperty("font", String);
		}
		
		/**
		 * @private
		 */
		public function set font($value:String):void
		{
			setProperty("font", $value);
		}
		
	}
}