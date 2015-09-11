package emap.managers
{
	
	/**
	 * 
	 * 文本样式管理器。
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	
	import flash.text.TextFormat;
	
	
	public final class TextFormatManager extends NoInstance
	{
		
		/**
		 * 
		 * 获取一个文本样式。
		 * 
		 */
		
		public static function getTextFormat($font:String):TextFormat
		{
			return TEXT_FORMATS[$font] = TEXT_FORMATS[$font] || new TextFormat($font, 20, null, false, null, null, null, null, "left");
		}
		
		
		/**
		 * @private
		 */
		private static const TEXT_FORMATS:Object = {};
		
	}
}