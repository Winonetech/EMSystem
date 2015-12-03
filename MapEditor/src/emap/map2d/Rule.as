package emap.map2d
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.controls.Text;
	
	public final class Rule extends Sprite
	{
		public function Rule()
		{
			super();
			initialize();
		}
		
		private function initialize():void
		{
			__scale = __scaleX = __scaleY = 1;
			
			addChild(bg = new Shape);
			addChild(s_p010 = new Shape ).visible = false;
			addChild(t_p010 = new Sprite).visible = false;
			addChild(s_p050 = new Shape );
			addChild(t_p050 = new Sprite);
			addChild(s_p100 = new Shape ).visible = false;
			addChild(t_p100 = new Sprite).visible = false;
			addChild(s_p500 = new Shape ).visible = false;
			addChild(t_p500 = new Sprite).visible = false;
			
			redraw();
		}
		private function redraw():void
		{
			drawBg();
			
			drawShape(s_p010, 10);
			drawText (t_p010, 10);
			drawShape(s_p050, 50);
			drawText (t_p050, 50);
			drawShape(s_p100, 100);
			drawText (t_p100, 100);
			drawShape(s_p500, 500);
			drawText (t_p500, 500);
		}
		
		private function drawBg():void
		{
			with (bg.graphics) {
				clear();
				beginFill(0xFFFFFF);
				if (__direction=="horizontal") {
					drawRect(-20, -20, 5015, 20);
				} else {
					drawRect(-20, -20, 20, 5015);
				}
				endFill();
			}
		}
		
		private function drawShape(shape:Shape, d:Number):void
		{
			var i:uint=0;
			with (shape.graphics) {
				clear();
				lineStyle(.1, 0);
				if (__direction=="horizontal") {
					for (i=0;i<MapContainer.MAX_W;i+=(d*.2)) {  
						moveTo(i, (i%d==0)?-10:-5); 
						lineTo(i, 0);
					}  
				} else {
					for (i=0;i<MapContainer.MAX_H;i+=(d*.2)) {
						moveTo((i%d==0)?-10:-5, i);
						lineTo(0, i);
					}
				}
			}
		}
		private function drawText(sprite:Sprite, d:Number):void
		{
			while(sprite.numChildren)sprite.removeChildAt(0);
			var temp:TextField;
			if (__direction=="horizontal") {
				for (var i:int=0;i<MapContainer.MAX_W;i+=d) {
					sprite.addChild(temp = new TextField);
					temp.autoSize = "left";
					temp.selectable = false;
					temp.text = String(i*.1*10);
					temp.setTextFormat(F);
					temp.x = i;
					temp.y = -20;
					temp.cacheAsBitmap = true;
				}
			} else {
				for (i=0;i<MapContainer.MAX_H;i+=d) {
					sprite.addChild(temp = new TextField);
					temp.autoSize = "left";
					temp.selectable = false;
					temp.text = String(i*.1*10);
					temp.setTextFormat(F);
					temp.x = -22;
					temp.y = i;
					temp.cacheAsBitmap = true;
				}
			}
		}
		
		private function scaleXShape(shape:Shape):void
		{
			if (shape.visible) {
				shape.scaleX = scale;
			}
		}
		
		private function scaleXText(sprite:Sprite,d:Number):void
		{
			if (sprite.visible) {
				var total:int = sprite.numChildren;
				for (var i:int=0;i<total;i++) {
					var temp:DisplayObject = sprite.getChildAt(i);
					temp.x = i*d*scale;
				}
			}
		}
		
		private function scaleYShape(shape:Shape):void
		{
			if (shape.visible) {
				shape.scaleY = scale;
			}
		}
		
		private function scaleYText(sprite:Sprite,d:Number):void
		{
			if (sprite.visible) {
				var total:int = sprite.numChildren;
				for (var i:int=0;i<total;i++) {
					var temp:DisplayObject = sprite.getChildAt(i);
					temp.y = i*d*scale-3;
				}
			}
		}
		
		public function get scale():Number
		{
			return __scale;
		}
		public function set scale(value:Number):void
		{
			__scale = value;
			s_p010.visible = (scale>=2);
			t_p010.visible = (scale>=2);
			s_p050.visible = (scale>= 1&&scale<= 2);
			t_p050.visible = (scale>= 1&&scale<= 2);
			s_p100.visible = (scale>=.4&&scale<  1);
			t_p100.visible = (scale>=.4&&scale<  1);
			s_p500.visible = (scale <.4);
			t_p500.visible = (scale <.4);
			if (direction=="horizontal") {
				bg.scaleX = scale;
				scaleXShape(s_p010);
				scaleXText (t_p010, 10);
				scaleXShape(s_p050);
				scaleXText (t_p050, 50);
				scaleXShape(s_p100);
				scaleXText (t_p100, 100);
				scaleXShape(s_p500);
				scaleXText (t_p500, 500);
			} else {
				bg.scaleY = scale;
				scaleYShape(s_p010);
				scaleYText (t_p010, 10);
				scaleYShape(s_p050);
				scaleYText (t_p050, 50);
				scaleYShape(s_p100);
				scaleYText (t_p100, 100);
				scaleYShape(s_p500);
				scaleYText (t_p500, 500);
			}
		}
		private var __scale:Number;
		
		override public function get scaleX():Number
		{
			return __scaleX;
		}
		override public function set scaleX(value:Number):void
		{
			__scaleX = value;
		}
		private var __scaleX:Number;
		
		override public function get scaleY():Number
		{
			return __scaleY;
		}
		override public function set scaleY(value:Number):void
		{
			__scaleY = value;
		}
		private var __scaleY:Number;
		
		
		
		public function get direction():String
		{
			return __direction;
		}
		public function set direction(value:String):void
		{
			if (direction==value) return
				__direction = (value!="vertical") 
					? "horizontal" 
					: "vertical";
			redraw();
		}
		private var bg:Shape;
		private var s_p010:Shape;
		private var t_p010:Sprite;
		private var s_p050:Shape;
		private var t_p050:Sprite;
		private var s_p100:Shape;
		private var t_p100:Sprite;
		private var s_p500:Shape;
		private var t_p500:Sprite;
		private static const F:TextFormat = new TextFormat(null,9);
		
		private var __direction:String="horizontal";
	}
}