package emap.map2d
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	
	
	internal final class Grid extends Sprite
	{
		
		
		public function Grid()
		{
			super();
			initialize();
		}
		
		private function initialize():void
		{
			__scale = 1;
			
			alpha = .3;
			addChild(layer010 = new Shape).visible = false;
			addChild(layer050 = new Shape);
			addChild(layer100 = new Shape).visible = false;
			addChild(layer500 = new Shape).visible = false;
			var i:int;
			with (layer010.graphics) {
				lineStyle(.1, 0xCCCCCC);
				for (i=0;i<=MapContainer.MAX_H;i+=50) {
					moveTo(0, i);
					lineTo(MapContainer.MAX_W, i);
				}
				for (i=0;i<=MapContainer.MAX_W;i+=50) {
					moveTo(i, 0);
					lineTo(i, MapContainer.MAX_H);
				}
			}
			with (layer050.graphics) {
				lineStyle(.1, 0xCCCCCC);
				for (i=0;i<=MapContainer.MAX_H;i+=100) {
					moveTo(0, i);
					lineTo(MapContainer.MAX_W, i);
				}
				for (i=0;i<=MapContainer.MAX_W;i+=100) {
					moveTo(i, 0);
					lineTo(i, MapContainer.MAX_H);
				}
			}
			with (layer100.graphics) {
				lineStyle(.1, 0xCCCCCC);
				for (i=0;i<=MapContainer.MAX_H;i+=200) {
					moveTo(0, i);
					lineTo(MapContainer.MAX_W, i);
				}
				for (i=0;i<=MapContainer.MAX_W;i+=200) {
					moveTo(i, 0);
					lineTo(i, MapContainer.MAX_H);
				}
			}
			with (layer500.graphics) {
				lineStyle(.1, 0xCCCCCC);
				for (i=0;i<=MapContainer.MAX_H;i+=1000) {
					moveTo(0, i);
					lineTo(MapContainer.MAX_W, i);
				}
				for (i=0;i<=MapContainer.MAX_W;i+=1000) {
					moveTo(i, 0);
					lineTo(i, MapContainer.MAX_H);
				}
			}
		}
		
		public function get scale():Number
		{
			return __scale;
		}
		public function set scale(value:Number):void
		{
			if (value==scale) return;
			__scale = value;
			layer010.visible = (scale>=2);
			layer050.visible = (scale>=1&&scale<2)
			layer100.visible = (scale>=.4&&scale<1);
			layer500.visible = (scale<.4);
		}
		private var __scale:Number;
		private var layer010:Shape;
		private var layer050:Shape;
		private var layer100:Shape;
		private var layer500:Shape;
	}
}