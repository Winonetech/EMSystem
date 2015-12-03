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
	
	
	/**
	 * 画楼层 位置的节点
	 * 
	 * */
	
	
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
			//节点至少包含一个基本点
			aimPoint = new AimPoint(step.aim);
			__scale = 1
			aimPoint.color = 0xff0000;
			//如果该点为曲线点  就会多一个控制点
			if (step.style == StepStyleConsts.CURVE_TO)
			{
				ctrPoint = new CtrPoint(step.ctr);
				ctrPoint.color = 0x000000;	
				addChild(ctrPoint);
			}
	
			addChild(aimPoint);
		
		}
		public function update(x:Number,y:Number, a:Object):void
		{
			
			if(x<0) x=0;
			if(y<0) y=0;
			if(a is AimPoint){
				step.aim.x = aimPoint.x = x;
				step.aim.y = aimPoint.y = y;
				
			}
			else
			{
				step.ctr.x = ctrPoint.x = x;
				step.ctr.y = ctrPoint.y = y;
				
			}
			//图形为闭合 最后一个点与第一个点保持重合
			if(lastStep)
			{
				lastStep.aim.x = x;
				lastStep.aim.y = y;
				
			}
			
		}
		
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
		public var lastStep:Step;
	}
}