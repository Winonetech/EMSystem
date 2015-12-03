package emap.map2d.vos
{
	import emap.vos.VOHall;
	
	
	public final class E2VOHall extends VOHall
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function E2VOHall($data:Object=null)
		{
			super($data);
		}
		
		
		/**
		 * 
		 * 颜色
		 * 
		 */
		
		public function set color($value:uint):void
		{
			setProperty("color", $value);
		}
		 
		
		/**
		 * 
		 * label
		 * 
		 */
		
		public function set label($value:String):void
		{
			setProperty("label", $value);
		}
		
	}
}