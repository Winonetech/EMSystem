package emap.map2d
{
	import editor.core.EDConfig;
	
	import emap.core.em;
	import emap.map2d.core.E2Config;
	import emap.map2d.vos.E2VONode;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class Node extends Sprite
	{
		public function Node($data:E2VONode)
		{
			super();
			initialize($data);
		}
		public function initialize($data:E2VONode):void
		{
			data = $data;
		}
		public function get data():E2VONode
		{
			return _data;
		}
		public function set data($value:E2VONode):void
		{
			if(_data!=$value)
			{
				mouseChildren = false;
				clear();
				_data = $value;
				point = new Point;
				pointBase = new PointBase(point);
				addChild(pointBase);
				this.x = $value.nodeX;
				this.y =$value.nodeY;
			}
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
		}
		protected function clear():void
		{
			while(this.numChildren) this.removeChildAt(0);
		}
	
		protected function mouseDownHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			EDConfig.instance.selectedNode = data;
			EDConfig.instance.propertyPanel.setCurrentState("node",true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
		}
		protected function mouseMoveHandler(event:MouseEvent):void
		{
			this.x = parent.mouseX;
			this.y = parent.mouseY;
			_data.nodeX = parent.mouseX;
			_data.nodeY = parent.mouseY;
		}
		protected function mouseUpHandler(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
		}
		public function endUpdate():void
		{
			pointBase.color = 0x00FF00;
			this.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
		}
		public function get scale():Number
		{
			return __scale;
		}
		public function set scale(value:Number):void
		{
			if (value==scale) return;
			__scale = value;
			this.scaleX = this.scaleY = 1/scale
		}
		private var __scale:Number;
		public var point:Point;
		public var pointBase:PointBase;
		private var _data:E2VONode;
	//	public var _x:Number;
	//	public var _y:Number;
	}
}