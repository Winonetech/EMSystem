package emap.map2d
{
	import emap.core.EMConfig;
	import emap.data.Step;
	//import emap.map2d.core.MapConfig;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
	
	[Bindable]
	public class PointBase extends Base
	{
		public function PointBase(point:Point)
		{
			super();
			initialize(point);
		}
		
		private function initialize(point:Point):void
		{
			mouseChildren = false;
			
			//config = mapConfig;
			this.x = point.x;
			this.y = point.y;
			__scale = 1;
			__color = 0x00FF00;
			
			buttonMode = true;
			
			with (graphics) {
				clear();
				lineStyle(1, 0);
				beginFill(color);
				
				drawCircle(0,0,5);
				endFill();
			}
			
			addChild(textLayer = new Sprite);
			textLayer.mouseChildren = textLayer.mouseEnabled = false;
			textLayer.addChild(textField = new TextField);
			textField.autoSize = "left";
			textField.selectable = false;
			textField.text = "";
			textField.x =-.5*textField.width;
			
		}
		
		public function get label():String
		{
			return textField.text;
		}
		public function set label(value:String):void
		{
			if (value==label) return;
			textField.text = value;
			textField.x =-.5*textField.width;
		}
		
		public function get color():uint
		{
			return __color;
		}
		public function set color(value:uint):void
		{
			if (value==color) return;
			__color = value;
			trace("color: ",color);
			with (graphics) {
				clear();
				lineStyle(1, 0);
				beginFill(color);
				drawCircle(0,0,5);
				endFill();
			}
		}
		private var __color:uint;
		
		public function get scale():Number
		{
			return __scale;
		}
		public function set scale(value:Number):void
		{
			if (value==scale) return;
			__scale = value;
			
			scaleX = scaleY = 1/scale;
		}
		private var __scale:Number;
		
	//	internal var config:MapConfig;
		
		private var textLayer:Sprite;
		private var textField:TextField;
	}
}