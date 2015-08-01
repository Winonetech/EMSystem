package emap.data
{
	import flash.geom.Rectangle;
	
	public final class Transform extends Rectangle
	{
		public function Transform($x:Number=0, $y:Number=0, $width:Number=0, $height:Number=0, $scale:Number = 1)
		{
			super($x, $y, $width, $height);
			
			scale = $scale;
		}
		
		public var scale:Number = 1;
		
	}
}