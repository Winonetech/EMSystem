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
		
		public function Transform($x:Number = 0, $y:Number = 0, $width:Number = 0, $height:Number = 0, $scale:Number = 1)
		{
			super($x, $y, $width, $height);
			
			scale = $scale;
		}
		
		
		/**
		 * 
		 * 缩放比
		 * 
		 */
		
		public var scale:Number = 1;
		
	}
}