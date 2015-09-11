package emap.map2d.vos
{
	
	/**
	 * 
	 * 路径。
	 * 
	 */
	
	
	import emap.consts.RouteTypeConsts;
	import emap.core.em;
	import emap.vos.VONode;
	import emap.vos.VORoute;
	
	import flash.geom.Point;
	
	[Bindable]
	public final class E2VORoute extends VORoute
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function E2VORoute($data:Object = null)
		{
			super($data);
		}
		
		
		/**
		 * 
		 * serial1
		 * 
		 */
		
		public function set serial1($value:String):void
		{
			setProperty("serial1", $value);
			clsRelation(VONode);
		}
		
		
		/**
		 * 
		 * serial2
		 * 
		 */
		
		public function set serial2($value:String):void
		{
			setProperty("serial2", $value);
			clsRelation(VONode);
		}
		
		/**
		 * private
		 * */
		public function set label($value:String):void
		{
			setProperty("label",$value)
		}
		
		/**
		 * private
		 * */
		public function get label():String
		{
			return getProperty("label");
		}
	}
}