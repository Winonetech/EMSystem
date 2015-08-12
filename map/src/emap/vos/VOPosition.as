package emap.vos
{
	
	/**
	 * 
	 * 位置，店铺，功能设施等。
	 * 
	 */
	
	
	import com.winonetech.core.VO;
	import emap.core.em;
	import emap.data.Layout;
	import emap.interfaces.ILayout;
	
	
	public final class VOPosition extends VO implements ILayout
	{
		
		/**
		 * 
		 * 构造函数
		 * 
		 */
		
		public function VOPosition($json:Object = null)
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
		 * 坐标系组
		 * 
		 */
		
		public function get coordinates():String
		{
			return getProperty("coordinate");
		}
		
		
		/**
		 * 
		 * 颜色
		 * 
		 */
		
		public function get color():uint
		{
			return getProperty("color", uint);
		}
		
		
		/**
		 * 
		 * 图标路径
		 * 
		 */
		
		public function get icon():String
		{
			return getProperty("icon");
		}
		
		
		/**
		 * 
		 * 图标偏移X
		 * 
		 */
		
		public function get iconOffsetX():Number
		{
			return getProperty("iconOffsetX", Number);
		}
		
		
		/**
		 * 
		 * 图标偏移Y
		 * 
		 */
		
		public function get iconOffsetY():Number
		{
			return getProperty("iconOffsetY", Number);
		}
		
		
		/**
		 * 
		 * 文本旋转
		 * 
		 */
		
		public function get iconRotation():Number
		{
			return getProperty("iconRotation", Number);
		}
		
		
		/**
		 * 
		 * 图标缩放
		 * 
		 */
		
		public function get iconScale():Number
		{
			return getProperty("iconScale", Number);
		}
		
		
		/**
		 * 
		 * 图标和文字是否悬浮在顶面。
		 * 
		 */
		
		public function get iconSuspend():Boolean
		{
			return getProperty("iconSuspend", Boolean)
		}
		
		
		/**
		 * 
		 * 图标是否可见
		 * 
		 */
		
		public function get iconVisible():Boolean
		{
			return getProperty("iconVisible", Boolean);
		}
		
		
		/**
		 * 
		 * 名称
		 * 
		 */
		
		public function get label():String
		{
			return getProperty("label");
		}
		
		
		/**
		 * 
		 * 文本偏移X
		 * 
		 */
		
		public function get labelColor():uint
		{
			return getProperty("labelColor", uint);
		}
		
		
		/**
		 * 
		 * 文本偏移X
		 * 
		 */
		
		public function get labelOffsetX():Number
		{
			return getProperty("labelOffsetX", Number);
		}
		
		
		/**
		 * 
		 * 文本偏移Y
		 * 
		 */
		
		public function get labelOffsetY():Number
		{
			return getProperty("labelOffsetY", Number);
		}
		
		
		/**
		 * 
		 * 文本旋转
		 * 
		 */
		
		public function get labelRotation():Number
		{
			return getProperty("labelRotation", Number);
		}
		
		
		/**
		 * 
		 * 文本缩放
		 * 
		 */
		
		public function get labelScale():Number
		{
			return getProperty("labelScale", Number);
		}
		
		
		/**
		 * 
		 * 文本是否可见
		 * 
		 */
		
		public function get labelVisible():Boolean
		{
			return getProperty("labelVisible", Boolean);
		}
		
		
		/**
		 * 
		 * 编号
		 * 
		 */
		
		public function get number():String
		{
			return getProperty("number");
		}
		
		
		/**
		 * 
		 * 高度
		 * 
		 */
		
		public function get thick():uint
		{
			return getProperty("thick", Number);
		}
		
		
		/**
		 * 
		 * floorID
		 * 
		 */
		
		public function get floorID():String
		{
			return getProperty("floor_id");
		}
		
		
		/**
		 * 
		 * positionTypeID
		 * 
		 */
		
		public function get positionTypeID():String
		{
			return getProperty("position_type_id");
		}
		
		
		/**
		 * 
		 * nodeID
		 * 
		 */
		
		public function get nodeID():String
		{
			return getProperty("node_id");
		}
		
		
		/**
		 * 
		 * 位置编码，参见PositionType.code
		 * 
		 */
		
		public function get positionCode():String
		{
			return em::positionType ? em::positionType.code : null;
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
		 * floor
		 * 
		 */
		
		em function get floor():VOFloor
		{
			return getRelation(VOFloor, floorID);
		}
		
		
		/**
		 * 
		 * positionType
		 * 
		 */
		
		em function get positionType():VOPositionType
		{
			return getRelation(VOPositionType, positionTypeID);
		}
		
		
		/**
		 * 
		 * node
		 * 
		 */
		
		em function get node():VONode
		{
			return getRelation(VONode, nodeID);
		}
		
		
		/**
		 * @private
		 */
		em var layout:Layout;
		
	}
}