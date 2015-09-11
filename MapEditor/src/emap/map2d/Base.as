package emap.map2d
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	[Bindable]
	public class Base extends Sprite
	{
		public function Base()
		{
			super();
		}
		
		override public function get x():Number
		{
			return super.x;
		}
		override public function set x(value:Number):void
		{
			super.x = value;
		}
		
		override public function get y():Number
		{
			return super.y;
		}
		override public function set y(value:Number):void
		{
			super.y = value;
		}
		
		public function get selected():Boolean
		{
			return __selected;
		}
		public function set selected(value:Boolean):void
		{
			if (value==selected) return;
			__selected = value;
			alpha = (selected) ? .5 : 1;
		}
		private var __selected:Boolean;
		
		
		
	}
}