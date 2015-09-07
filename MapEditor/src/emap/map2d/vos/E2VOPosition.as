package emap.map2d.vos
{
	import emap.vos.VOPosition;
	import emap.core.em;
	
	[Bindable]
	public final class E2VOPosition extends VOPosition
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function E2VOPosition($data:Object=null)
		{
			super($data);
		}
		
		
		/**
		 * 
		 * 颜色
		 * 
		 */
		
		public function set color($value:uint):void
		{
			setProperty("color", $value);
		}
		
		
		/**
		 * 
		 * 图标路径
		 * 
		 */
		
		public function set icon($value:String):void
		{
			setProperty("icon", $value);
		}
		
		
		/**
		 * 
		 * 图标偏移X
		 * 
		 */
		
		public function set iconOffsetX($value:Number):void
		{
			setProperty("iconOffsetX", $value);
		}
		
		
		/**
		 * 
		 * 图标偏移Y
		 * 
		 */
		
		public function set iconOffsetY($value:Number):void
		{
			setProperty("iconOffsetY", $value);
		}
		
		
		/**
		 * 
		 * 文本旋转
		 * 
		 */
		
		public function set iconRotation($value:Number):void
		{
			setProperty("iconRotation", $value);
		}
		
		
		/**
		 * 
		 * 图标缩放
		 * 
		 */
		
		public function set iconScale($value:Number):void
		{
			setProperty("iconScale", $value);
		}
		
		
		/**
		 * 
		 * 图标和文字是否悬浮在顶面。
		 * 
		 */
		
		public function set iconSuspend($value:Boolean):void
		{
			setProperty("iconSuspend", $value);
		}
		
		
		/**
		 * 
		 * 图标是否可见
		 * 
		 */
		
		public function set iconVisible($value:Boolean):void
		{
			setProperty("iconVisible", $value);
		}
		
		
		/**
		 * 
		 * 名称
		 * 
		 */
		
		public function set label($value:String):void
		{
			setProperty("label", $value);
		}
		
		
		/**
		 * 
		 * 文本偏移X
		 * 
		 */
		
		public function set labelColor($value:uint):void
		{
			setProperty("labelColor", $value);
		}
		
		
		/**
		 * 
		 * 文本偏移X
		 * 
		 */
		
		public function set labelOffsetX($value:Number):void
		{
			setProperty("labelOffsetX", $value);
		}
		
		
		/**
		 * 
		 * 文本偏移Y
		 * 
		 */
		
		public function set labelOffsetY($value:Number):void
		{
			setProperty("labelOffsetY", $value);
		}
		
		
		/**
		 * 
		 * 文本旋转
		 * 
		 */
		
		public function set labelRotation($value:Number):void
		{
			setProperty("labelRotation", $value);
		}
		
		
		/**
		 * 
		 * 文本缩放
		 * 
		 */
		
		public function set labelScale($value:Number):void
		{
			setProperty("labelScale", $value);
		}
		
		
		/**
		 * 
		 * 文本是否可见
		 * 
		 */
		
		public function set labelVisible($value:Boolean):void
		{
			setProperty("labelVisible", $value);
		}
		
		
		/**
		 * 
		 * 编号
		 * 
		 */
		
		public function set number($value:String):void
		{
			setProperty("number", $value);
		}
		
		
		/**
		 * 
		 * 高度
		 * 
		 */
		
		public function set thick($value:Number):void
		{
			setProperty("thick", $value);
		}
		
		
		/**
		 * 
		 * floorID
		 * 
		 */
		
		public function set floorID($value:String):void
		{
			setProperty("floor_id", $value);
		}
		
		
		/**
		 * 
		 * positionTypeID
		 * 
		 */
		
		public function set positionTypeID($value:String):void
		{
			setProperty("position_type_id", $value);
		}
		
		public function get typeName():String
		{
			return em::positionType ? em::positionType.label : null;
		}
		
	}
}