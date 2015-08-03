package emap.utils
{
	import cn.vision.core.NoInstance;
	
	import emap.consts.PositionCodeConsts;
	import emap.data.Layout;
	import emap.data.Transform;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	public final class PositionUtil extends NoInstance
	{
		
		/**
		 * 
		 * 通过code判断是否需要显示标签和图标
		 * 
		 * @param $code:String 编码。
		 * 
		 * @return Boolean 是否显示标签和图标，true为显示，false为不显示。
		 * 
		 */
		
		public static function displayAssets($code:String):Boolean
		{
			return $code != PositionCodeConsts.HOLLOW;
		}
		
		/**
		 * 
		 * 通过code和position的图标悬浮属性判断是否需要显示图标
		 * 
		 * @param $code:String 编码。
		 * @param $suspend:Boolean 是否悬浮，传入position的iconSuspend属性。
		 * 
		 * @return Boolean 是否悬浮，true为悬浮，false为不悬浮。
		 * 
		 */
		
		public static function suspendIcon($code:String, $suspend:Boolean):Boolean
		{
			return $code == PositionCodeConsts.UNSEEN || ($code == PositionCodeConsts.TERRAIN && $suspend);
		}
		
		
		/**
		 * 
		 * 通过layout获取图标的限制宽高
		 * 
		 * @param $icon:* IBitmapDataDrawable 可绘制的类型。
		 * @param $ristrictWidth:Number 限制宽度。
		 * @param $ristrictHeight:Number 限制高度。
		 * 
		 * @return Transform 限制宽高以及缩放比例。
		 * 
		 */
		
		public static function restrictIcon($icon:*, $ristrictWidth:Number, $ristrictHeight:Number):Transform
		{
			var iw:Number = $icon.width;
			var ih:Number = $icon.height;
			
			var lw:Number = $ristrictWidth;
			var lh:Number = $ristrictHeight;
			
			if (iw > lw || ih > lh)
			{
				var s:Number = (iw / ih > lw / lh) ? lh / ih : lw / iw;
				iw *= s;
				ih *= s;
			}
			return new Transform(0, 0, iw, ih, s);
		}
		
	}
}