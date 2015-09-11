package emap.map2d
{
	import cn.vision.utils.MathUtil;
	
	import emap.consts.StepStyleConsts;
	import emap.core.EMConfig;
	import emap.data.Step;
	import emap.interfaces.INode;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	
	
	
	[Bindable]
	public final class DrawStep extends Sprite
	{
		public function DrawStep($step:Step)
		{
			super();
			initialize($step);
		}
		
		private function initialize($step:Step):void
		{
			step = $step;
			__style = "0";
			//this.graphics.color = 0xFFFF00;
			aimPoint = new AimPoint(step.aim);
			__scale = 1
			aimPoint.color = 0xff0000;
			if (step.style == StepStyleConsts.CURVE_TO)
			{
				ctrPoint = new CtrPoint(step.ctr);
				ctrPoint.color = 0x000000;	
				addChild(ctrPoint);
			}
	
			addChild(aimPoint);
			aimPoint.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		public function updateAim(x:Number,y:Number):void
		{
			if(x<0) x=0;
			if(y<0) y=0;
			step.aim.x = x;
			step.aim.y = y;
			aimPoint.x = x;
			aimPoint.y = y;
		}
		protected function mouseDownHandler(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			//stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			//config.component = this;
			//event.stopImmediatePropagation();
		}
		
		protected function mouseMoveHandler(event:MouseEvent):void
		{
//			var tempX:Number = parent.mouseX;
//			var tempY:Number = parent.mouseY;
//			if (config.font == "integer") {
//				var dx:Number = tempX%10;
//				if (dx<2.5/scale||dx>7.5/scale) {
//					tempX = (tempX-dx)+(10*Math.round(dx*.1));
//					config.map.createAidLine("x", tempX);
//				} else {
//					config.map.clearAidLine ("x");
//				}
//				var dy:Number = tempY%10;
//				if (dy<2.5/scale||dy>7.5/scale) {
//					tempY = (tempY-dy)+(10*Math.round(dy*.1));
//					config.map.createAidLine("y", tempY);
//				} else {
//					config.map.clearAidLine ("y");
//				}
//			}
//			x = MathUtil.clamp(tempX, 0, MapContainer.MAX_W);
//			y = MathUtil.clamp(tempY, 0, MapContainer.MAX_H);
		}
		
//		protected function mouseUpHandler(event:MouseEvent):void
//		{
//			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
//			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
//			config.map.clearAidLine ();
//		}
		
		public function get style():String
		{
			return __style;
		}
		public function set style(value:String):void
		{
			if (value==style) return;
			if (value!="0"&&value!="1") {
				value = (value=="0")?"0":"1";
			}
			__style = value;
		}
		public function get scale():Number
		{
			return __scale;
		}
		public function set scale(value:Number):void
		{
			if (value==scale) return;
			__scale = value;
			
			aimPoint.scaleX = aimPoint.scaleY = 1/scale;
			
			if(ctrPoint)
				ctrPoint.scaleX = ctrPoint.scaleY = 1/scale;
			
		}
		private var __scale:Number;
		private var __style:String;
		
		internal var shape :INode;
		private var aimPoint:AimPoint;
		private var ctrPoint:CtrPoint;
		private var step:Step;
	}
}