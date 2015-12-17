package emap.data
{
	
	/**
	 * 
	 * 加载图标时的缩放，以及宽高比例。
	 * 
	 */
	
	
	import flash.geom.Rectangle;
	
	
	public final class Transform extends Rectangle
	{
		
		/**
		 * 
		 * 构造函数
		 * 
		 */
		
		public function Transform($x:Number = 0, $y:Number = 0, $width:Number = 0, $height:Number = 0, $scaleX:Number = 1, $scaleY:Number = 1)
		{
			super($x, $y, $width, $height);
			
			scaleX = $scaleX;
			scaleY = $scaleY;
		}
		
		
		/**
		 * 
		 * 缩放比X
		 * 
		 */
		
		public var scaleX:Number = 1;
		
		
		/**
		 * 
		 * 缩放比X
		 * 
		 */
		
		public var scaleY:Number = 1;
		
	}
}