package emap.vos
{
	
	/**
	 * 
	 * 场馆，区域。
	 * 
	 */
	
	
	import cn.vision.collections.Map;
	
	import com.winonetech.core.VO;
	
	import emap.core.em;
	import emap.data.Layout;
	import emap.interfaces.ILayout;
	
	
	public class VOHall extends VO implements ILayout
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function VOHall($data:Object = null)
		{
			super($data, "hall");
			
			em::layout = new Layout(getProperty("coordinate"));
		}
		
		
		/**
		 * 
		 * 颜色
		 * 
		 */
		
		public function get color():uint
		{
			return getProperty("color");
		}
		
		
		/**
		 * 
		 * 一组坐标，地图模块根据坐标组画出地图形状。
		 * 
		 */
		
		public function get coordinates():String
		{
			return layout.build();
		}
		
		
		/**
		 * 
		 * label
		 * 
		 */
		
		public function get label():String
		{
			return getProperty("label");
		}
		
		
		/**
		 * 
		 * order
		 * 
		 */
		
		public function get order():uint
		{
			return getProperty("order", uint);
		}
		
		/**
		 * @private
		 */
		public function set order($value:uint):void
		{
			setProperty("order", $value);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get layout():Layout
		{
			return em::layout;
		}
		
		
		/**
		 * 
		 * floor collection
		 * 
		 */
		
		public var floorMap:Map;
		
		
		/**
		 * @private
		 */
		em var layout:Layout;
		
	}
}