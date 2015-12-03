package emap.map2d.vos
{
	import emap.vos.VOPositionType;
	
	[Bindable]
	public final class E2VOPositionType extends VOPositionType
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function E2VOPositionType($data:Object=null)
		{
			super($data);
		}
		
		
		/**
		 * 
		 * code
		 * 
		 */
		
		public function set code($value:String):void
		{
			setProperty("code", $value);
		}
		
		
		/**
		 * 
		 * icon
		 * 
		 */
		
		public function set icon($value:String):void
		{
			setProperty("icon", $value);
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
		
		
		/**
		 * 
		 * 是否可见
		 * 
		 */
		
		public function set visible($value:Boolean):void
		{
			setProperty("visible", $value);
		}
		
	}
}