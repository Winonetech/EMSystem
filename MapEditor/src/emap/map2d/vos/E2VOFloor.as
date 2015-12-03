package emap.map2d.vos
{
	import emap.vos.VOFloor;
	[Bindable]
	public final class E2VOFloor extends VOFloor
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function E2VOFloor($data:Object=null)
		{
			super($data);
		}
		
		
		/**
		 * 
		 * color
		 * 
		 */
		
		public function set color($value:uint):void
		{
			setProperty("color", $value);
		}
		
		
		/**
		 * 
		 * description
		 * 
		 */
		
		public function set description($value:String):void
		{
			setProperty("description", $value);
		}
		
		
		/**
		 * 
		 * image
		 * 
		 */
		
		public function set image($value:String):void
		{
			setProperty("image", $value);
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
		
		override public function toXML():String
		{
			if (layout) setProperty("coordinate", layout.build());
			
			return super.toXML();
		}
		
	}
}