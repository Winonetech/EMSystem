package emap.core
{
	
	import cn.vision.core.VSObject;
	
	import flash.text.Font;
	
	
	public final class EMConfig extends VSObject
	{
		
		/**
		 * 
		 * 构造函数
		 * 
		 */
		
		public function EMConfig()
		{
			super();
		}
		
		
		/**
		 * 
		 * 小图标宽度
		 * 
		 */
		
		public var iconWidth:Number = 256;
		
		
		/**
		 * 
		 * 小图标高度
		 * 
		 */
		
		public var iconHeight:Number = 256;
		
		
		/**
		 * 
		 * 位置厚度
		 * 
		 */
		
		public var positionThick:Number = 50;
		
		
		/**
		 * 
		 * 字体
		 * 
		 */
		
		public var font:String = "msyh";
		
	}
}