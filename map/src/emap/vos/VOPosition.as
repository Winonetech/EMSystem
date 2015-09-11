package emap.vos
{
	
	/**
	 * 
	 * 位置，店铺，功能设施等。
	 * 
	 */
	
	
	import cn.vision.collections.Map;
	
	import com.winonetech.core.VO;
	
	import emap.core.em;
	import emap.data.Layout;
	import emap.interfaces.ILayout;
	import emap.interfaces.INode;
	
	import versions.version1.a3d.A3D;
	
	
	[Bindable]
	public class VOPosition extends VO implements ILayout, INode
	{
		
		/**
		 * 
		 * 构造函数
		 * 
		 */
		
		public function VOPosition($data:Object = null)
		{
			super($data, "position");
			
			initialize();
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
		 * @private
		 */
		private function initialize():void
		{
			em::routes = new Map;
		}
		
		
		/**
		 * 
		 * 坐标系组
		 * 
		 */
		
		public function get coordinates():String
		{
			return layout.build();
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
		 * 节点序列号
		 * 
		 */
		
		public function get serial():String
		{
			return getProperty("serial");
		}
		
		
		/**
		 * 
		 * 高度
		 * 
		 */
		
		public function get thick():Number
		{
			return getProperty("thick", Number);
		}
		
		
		/**
		 * @inheritDoc
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
		 * 位置编码
		 * 
		 */
		
		public function get typeCode():String
		{
			return positionType ? positionType.code : null;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get layout():Layout
		{
			return em::layout;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get nodeX():Number
		{
			return layout ? layout.cenX : 0;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get nodeY():Number
		{
			return layout ? layout.cenY : 0;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get routes():Map
		{
			return em::routes;
		}
		
		
		/**
		 * 
		 * floor
		 * 
		 */
		
		public var floor:VOFloor;
		
		
		/**
		 * 
		 * positionType
		 * 
		 */
		
		public var positionType:VOPositionType;
		
		
		/**
		 * @private
		 */
		em var layout:Layout;
		
		
		/**
		 * @private
		 */
		em var routes:Map;
		
	}
}