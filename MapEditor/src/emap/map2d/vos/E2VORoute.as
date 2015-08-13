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
		 * type
		 * 
		 */
		
		public function set type($value:String):void
		{
			if (type!= $value)
			{
				$value = ($value == RouteTypeConsts.CURVE) ? $value : RouteTypeConsts.LINE;
				setProperty("type", $value);
				if ($value == RouteTypeConsts.CURVE)
				{
					if (em::node1 && em::node2)
					{
						var point:Point = Point.interpolate(new Point(em::node1.nodeX, em::node1.nodeY), new Point(em::node2.nodeX, em::node2.nodeY), .5);
						ctrlX = point.x;
						ctrlY = point.y;
					}
				}
			}
		}
		
		
		/**
		 * 
		 * ctrlX
		 * 
		 */
		
		public function set ctrlX($value:Number):void
		{
			if (type == RouteTypeConsts.CURVE) setProperty("ctrlX", $value);
		}
		
		
		/**
		 * 
		 * ctrlY
		 * 
		 */
		
		public function set ctrlY($value:Number):void
		{
			if (type == RouteTypeConsts.CURVE) setProperty("ctrlY", $value);
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
		
	}
}