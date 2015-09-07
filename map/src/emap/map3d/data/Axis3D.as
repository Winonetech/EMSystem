package emap.map3d.data
{
	
	/**
	 * 
	 * 箭头坐标，旋转角度信息。
	 * 
	 */
	
	
	import flash.geom.Vector3D;
	
	
	public final class Axis3D extends Vector3D
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 * @param $x:Number (default = 0) X坐标。
		 * @param $y:Number (default = 0) Y坐标。
		 * @param $z:Number (default = 0) Z坐标。
		 * @param $rotationX:Number (default = 0) X轴旋转角度。
		 * @param $rotationY:Number (default = 0) Y轴旋转角度。
		 * @param $rotationZ:Number (default = 0) Z轴旋转角度。
		 * 
		 */
		
		public function Axis3D(
			$x:Number = 0,
			$y:Number = 0,
			$z:Number = 0,
			$rotationX:Number = 0,
			$rotationY:Number = 0,
			$rotationZ:Number = 0)
		{
			super($x, $y, $z);
			
			initialize($rotationX, $rotationY, $rotationZ);
		}
		
		
		/**
		 * @private
		 */
		private function initialize($rotationX:Number, $rotationY:Number, $rotationZ:Number):void
		{
			rotationX = $rotationX;
			rotationY = $rotationY;
			rotationZ = $rotationZ;
		}
		
		
		/**
		 * 
		 * X轴旋转角度。
		 * 
		 */
		
		public var rotationX:Number;
		
		
		/**
		 * 
		 * Y轴旋转角度。
		 * 
		 */
		
		public var rotationY:Number;
		
		
		/**
		 * 
		 * Z轴旋转角度。
		 * 
		 */
		
		public var rotationZ:Number;
		
	}
}