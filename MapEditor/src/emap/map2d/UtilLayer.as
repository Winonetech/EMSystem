package emap.map2d
{
	import editor.core.EDConfig;
	
	import emap.consts.StepStyleConsts;
	import emap.core.em;
	import emap.data.Step;
	import emap.map2d.core.E2Config;
	import emap.map2d.vos.E2VONode;
	import emap.utils.StepUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import flashx.textLayout.formats.Float;
	
	public class UtilLayer extends Sprite
	{
		public function UtilLayer(config:E2Config)
		{
			super();
			_config = config;
			pointLayer.visible = false;
			addChild(pointLayer);
			
		}
		/**
		 * 
		 * 监听emap被点击的位置 节点 路径 后产生点击效果
		 * */
		public function clickEffect():void
		{
			//将地图添加监听事件
			if(_config)
			{
				_config.eMap.addEventListener(MouseEvent.MOUSE_DOWN,mapClick);
			}
		}
		protected function mapClick(even:Event):void
		{
			//由于node已经监听了  这里不用再进行处理
//			if(even.target is Node && onode !=even.target)
//			{
//				clear();
//				this.visible = true;
//				pointLayer.visible = true;
//				//之前存在 删除效果
//				cleanEffect();
//
//				onode = even.target as Node;
//				
//				onode.clicked();
//				
//		
//			}
			if(even.target is Route)
			{
			
				var route:Route = even.target as Route;
				routeSelected(route);
			}
			if(even.target is Position)
			{
				
				var position:Position = even.target as Position;
				positionSelected(position);
			}
		
		}
		public function routeSelected(route:Route):void
		{
			clear();
			cleanEffect();
			route.selected= true;;
			oroute = route;
		}
		public function positionSelected(position:Position):void
		{
			clear();
			cleanEffect();
			oposition = position;
			oposition.selected = true;
		}
		//点击下一个对象将前一个对象特效取消
		public function cleanEffect():void
		{
			if(onode)
				onode.removeClicked();
			if(oroute)
				oroute.selected = false;
			if(oposition)
			{
				oposition.selected = false;
			oposition.selected;}
		}
		protected function pointMouseDown(event:Event):void
		{
			pointBase.addEventListener(MouseEvent.MOUSE_MOVE,pointMouseMove);
		}
		protected function pointMouseMove(event:Event):void
		{
			pointBase.addEventListener(MouseEvent.MOUSE_UP,pointMouseUp);
			pointBase.x = this.mouseX;
			
		}
		protected function pointMouseUp(event:Event):void
		{
			
		}
		public function set ground($value:Ground):void
		{
				_ground = $value;
				moveDrawStep(_ground.em::layout.steps)
		}
		private function moveDrawStep($value:Vector.<Step>):void
		{
			clear();
			cleanEffect();
			pointLayer.visible = true;
			steps = $value;
			pointArr = new Array;
			var moveToDrawStep:DrawStep;
			var moveToStep:Step;
			var lastStep:Step;
			var l:uint = steps.length;
			for(var i:int=0;i<l;i++)
			{
				var drawStep:DrawStep = new DrawStep(steps[i]);
				//判断当前steps是否为move 决定前一个step是否显示
				if(steps[i].style == StepStyleConsts.MOVE_TO)
				{
					
					if(moveToStep)
					{
						moveToDrawStep.lastStep = steps[i - 1];
					}
					moveToStep = steps[i];
					moveToDrawStep = drawStep;
				}
				if(i==l-1)
				{
					if(l==1) 
					{
						drawStep.scale = scale;
						pointArr.push(drawStep);
						pointLayer.addChild(drawStep);
						drawStep.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);	
					}
					else if(moveToStep) moveToDrawStep.lastStep = steps[l - 1];
					
				}else if(steps[i+1].style!=StepStyleConsts.MOVE_TO)
				{
					drawStep.scale = scale;
					pointArr.push(drawStep);
					pointLayer.addChild(drawStep);
					drawStep.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);	
				}
			}
			
		}
		public function get ground():Ground
		{
			return _ground;
		}
		public function set position ($value:Position):void
		{
				_position = $value;
				if(_position)
					moveDrawStep(_position.steps);
			
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
			if(event.target is PointBase)
			{
				d = event.currentTarget as DrawStep;
				b = event.target;
				//if(event.target is AimPoint) b = true;
				//if(event.target is CtrPoint) b = false;
				//a = event.target as PointBase;
				stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
				stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			}
		
		}
		protected function mouseMoveHandler(event:MouseEvent):void
		{
			
				d.update(this.mouseX, this.mouseY, b);
					
			if(_ground)
				_ground.update();
			if(_position)
			{
				_position.updata();
				_position.updatePlane();
				_position.updateLabel();
			}
			
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
		public function set onode($value:Node):void
		{
			_onode = $value;
			_oroute = null;
			_position = null;
		}
		public function get onode():Node
		{
			return _onode;
		}
		public function set oroute($value:Route):void
		{
			_oroute = $value;
			_onode = null;
			_position = null;
		}
		public function get oroute():Route
		{
			return _oroute;
		}
		public function set oposition($value:Position):void
		{
			_oposition = $value;
			_onode = null;
			_oroute = null;
		}
		public function get oposition():Position
		{
			return _oposition;
		}
		private var steps:Vector.<Step>;
		private var pointLayer:Sprite = new Sprite;
		private var _position:Position;
		private var _ground:Ground;
		private var pointArr:Array;
		private	var a:PointBase;
		private var d:DrawStep;
		private var b:Object;
		private var _config:E2Config;
		
		//上一次点击的节点 位置 路径
		public var _onode:Node;
		private var _oroute:Route;
		private var _oposition:Position;
		private var pointBase:PointBase;
		private var parentLayer:Sprite;
	}	
}