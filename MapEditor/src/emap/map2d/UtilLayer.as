package emap.map2d
{
	import emap.core.em;
	import emap.data.Step;
	import emap.utils.StepUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class UtilLayer extends Sprite
	{
		public function UtilLayer()
		{
			super();
			pointLayer.visible = false;
			addChild(pointLayer);
			//addEventListener(MouseEvent.CLICK,mouseDownHandler);
		}
		public function set ground($value:Ground):void
		{
			
				clear();
				
				pointLayer.visible = true;
				_ground = $value;
				//StepUtil.drawSteps(graphics, _ground.em::layout, true);
				pointArr = new Array;
				for each(var step:Step in _ground.em::layout.steps)
				{
					var drawStep:DrawStep = new DrawStep(step);
					drawStep.scale = scale;
					pointArr.push(drawStep);
					pointLayer.addChild(drawStep);
					drawStep.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				}
				//StepUtil.drawSteps(graphics, _ground.em::layout.steps);
			
		}
		public function get ground():Ground
		{
			return _ground;
		}
		public function set position ($value:Position):void
		{
			clear();
			pointLayer.visible = true;
			_position = $value;
			pointArr = new Array;
			for each(var step:Step in _position.steps)
			{
				var drawStep:DrawStep = new DrawStep(step);
				drawStep.scale = scale;
				pointArr.push(drawStep);
				pointLayer.addChild(drawStep);
				drawStep.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			}
		}
		
		public function get scale():Number
		{
			return __scale;
		}
		public function set scale($value:Number):void
		{
			__scale = $value;
			for each (var point:DrawStep in pointArr)
			{
				point.scale = $value;
			}
		}
		protected function mouseDownHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			if(event.target is AimPoint)
			{
				d = event.currentTarget as DrawStep;
				a = event.target as AimPoint;
				stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
				stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			}
		}
		protected function mouseMoveHandler(event:MouseEvent):void
		{
			d.updateAim(this.mouseX, this.mouseY)
			if(_ground)
				_ground.update();
			if(_position)
				_position.updatePlane();
			
		}
		protected function mouseUpHandler(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
		}
		private var __scale:Number;
		
		public function clear():void
		{
			while (pointLayer.numChildren) pointLayer.removeChildAt(0);
		}
		private var pointLayer:Sprite = new Sprite;
		private var _position:Position;
		private var _ground:Ground;
		private var pointArr:Array;
		private	var a:AimPoint;
		private var d:DrawStep;
	}
}