package emap.vos
{
	
	/**
	 * 
	 * 楼层。
	 * 
	 */
	
	
	import cn.vision.collections.Map;
	
	import com.winonetech.core.VO;
	
	import emap.core.em;
	import emap.data.Layout;
	import emap.interfaces.ILayout;
	[Bindable]
	public class VOFloor extends VO implements ILayout
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function VOFloor($data:Object = null)
		{
			super($data, "floor");
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function parse($data:Object):void
		{
			super.parse($data);
			
			em::layout = new Layout(getProperty("coordinate"));
		}
		
		
		/**
		 * 
		 * 地形颜色。
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
		 * description
		 * 
		 */
		
		public function get description():String
		{
			return getProperty("description");
		}
		
		
		/**
		 * 
		 * image
		 * 
		 */
		
		public function get image():String
		{
			return getProperty("image");
		}
		
		
		/**
		 * 
		 * name
		 * 
		 */
		
		public function get label():String
		{
			return getProperty("label");
		}
		
		
		/**
		 * 
		 * 楼层序号，从1开始。
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
		 * hall 集合。
		 * 
		 */
		
		public var hallsMap:Map;
		
		
		/**
		 * 
		 * position 集合。
		 * 
		 */
		
		public var positionMap:Map;
		
		
		/**
		 * @private
		 */
		em var layout:Layout;
		
	}
}