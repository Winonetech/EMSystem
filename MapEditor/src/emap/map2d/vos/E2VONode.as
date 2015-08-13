package emap.map2d.vos
{
	import emap.vos.VOFloor;
	import emap.vos.VONode;
	
	
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
			setProperty("nodeX", $value);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function set nodeY($value:Number):void
		{
			setProperty("nodeY", $value);
		}
		
		
		/**
		 * @private
		 */
		public function set floorID($value:String):void
		{
			setProperty("floor_id", $value);
			clsRelation(VOFloor);
		}
		
	}
}