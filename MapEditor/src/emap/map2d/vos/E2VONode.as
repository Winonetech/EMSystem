package emap.map2d.vos
{
	import emap.vos.VOFloor;
	import emap.vos.VONode;
	
	[Bindable]
	public final class E2VONode extends VONode
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function E2VONode($data:Object=null)
		{
			super($data);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function set nodeX($value:Number):void
		{
			setProperty("x", $value);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function set nodeY($value:Number):void
		{
			setProperty("y", $value);
		}
		
		
		/**
		 * @private
		 */
		public function set floorID($value:String):void
		{
			setProperty("floor_id", $value);
			clsRelation(VOFloor);
		}
	
		/**
		 * @private
		 */
		public function set label($value:String):void
		{
			setProperty("label",$value);
		}
		public function get label():String
		{
			return getProperty("label");
			
		}
	}
}