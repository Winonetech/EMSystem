package emap.vos
{
	
	/**
	 * 
	 * 商场数据结构。
	 * 
	 */
	
	
	import cn.vision.collections.Map;
	
	import com.winonetech.core.VO;
	
	
	public class VOEMap extends VO
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function VOEMap($data:Object = null)
		{
			super($data, "emporium");
		}
		
		
		/**
		 * 
		 * logo
		 * 
		 */
		
		public function get logo():String
		{
			return getProperty("logo");
		}
		
		
		/**
		 * 
		 * 启用场馆。
		 * 
		 */
		
		public function get hallEnabled():Boolean
		{
			return getProperty("hallEnabled");
		}
		
		
		/**
		 * 
		 * 小图标宽度
		 * 
		 */
		
		public function get iconWidth():Number
		{
			return getProperty("iconWidth", Number);
		}
		
		
		/**
		 * 
		 * 小图标高度
		 * 
		 */
		
		public function get iconHeight():Number
		{
			return getProperty("iconHeight", Number);
		}
		
		
		/**
		 * 
		 * 实体位置厚度
		 * 
		 */
		
		public function get thickEntity():Number
		{
			return getProperty("thickEntity", Number);
		}
		
		
		/**
		 * 
		 * 镂空位置厚度
		 * 
		 */
		
		public function get thickHollow():Number
		{
			return getProperty("thickHollow", Number);
		}
		
		
		/**
		 * 
		 * hall 集合。
		 * 
		 */
		
		public var hallMap:Map;
		
		
		/**
		 * 
		 * floor 集合，在没有馆的情况下，使用该集合。
		 * 
		 */
		
		public var floorMap:Map;
		
	}
}