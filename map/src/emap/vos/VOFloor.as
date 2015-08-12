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
	public final class VOFloor extends VO implements ILayout
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function VOFloor($json:Object = null)
		{
			super($json);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function parse($data:Object):void
		{
			super.parse($data);
			
			em::layout = new Layout(coordinates);
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
			return getProperty("coordinate");
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
		 * 
		 * hallID
		 * 
		 */
		
		public function get hallID():String
		{
			return getProperty("veneus_id");
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
		 * hall
		 * 
		 */
		
		em function get hall():VOHall
		{
			return getRelation(VOHall, hallID);
		}
		
		
		/**
		 * 
		 * position 集合。
		 * 
		 */
		
		public var positionMap:Map;
		
		
		/**
		 * 
		 * store 集合。
		 * 
		 */
		
		public var storeMap:Map;
		
		
		/**
		 * @private
		 */
		em var layout:Layout;
		
	}
}