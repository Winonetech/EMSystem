package emap.map2d.core
{
	import emap.core.EMConfig;
	
	
	public final class E2Config extends EMConfig
	{
		
		/**
		 * 
		 * 构造函数
		 * 
		 */
		
		public function E2Config($data:Object = null)
		{
			super($data);
		}
		
		
		/**
		 * 
		 * logo
		 * 
		 */
		
		public function set logo($value:String):void
		{
			setProperty("logo", $value);
		}
		
		
		/**
		 * 
		 * 启用场馆。
		 * 
		 */
		
		public function set hallEnabled($value:Boolean):void
		{
			setProperty("hallEnabled", $value);
		}
		
		
		/**
		 * 
		 * 小图标宽度
		 * 
		 */
		
		public function set iconWidth($value:Number):void
		{
			setProperty("iconWidth", $value);
		}
		
		
		/**
		 * 
		 * 小图标高度
		 * 
		 */
		
		public function set iconHeight($value:Number):void
		{
			setProperty("iconHeight", $value);
		}
		
		
		/**
		 * 
		 * 实体位置厚度
		 * 
		 */
		
		public function set thickEntity($value:Number):void
		{
			setProperty("thickEntity", $value);
		}
		
		
		/**
		 * 
		 * 镂空位置厚度
		 * 
		 */
		
		public function set thickHollow($value:Number):void
		{
			setProperty("thickHollow", $value);
		}
		
	}
}