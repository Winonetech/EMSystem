package emap.map2d
{
	
	/**
	 * 
	 * 交互容器。
	 * 
	 */
	
	
	import caurina.transitions.Tweener;
	
	import cn.vision.core.UI;
	import cn.vision.utils.MathUtil;
	  
	import flash.display.DisplayObject;  
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	  
	
	public class Viewer2D extends UI   
	{
		public function Viewer2D()
		{
			super();
			
			initialize();
		}
		
		
		/**
		 * 
		 * 重置
		 * 
		 */
		
		public function reset($tween:Boolean = false):void
		{
			Tweener.removeTweens(this);
			aimScale = mapScale = minScale;
			aimX = isNaN(resetX)
				?(viewWidth - mapWidth) * .5
				:-resetX * aimScale + viewWidth * .5;
			aimY = isNaN(resetY)
				?(viewHeight - mapHeight) * .5
				:-resetY * aimScale + viewHeight * .5;
			restrictScale();
			restrictXY();
			
			if ($tween)
			{
				updateTween();
			}
			else
			{
				mapScale = aimScale;
				mapX = aimX;
				mapY = aimY;
			}
		}
		
		
		/**
		 * 
		 * 移动
		 * 
		 */
		
		public function moveTo(x:Number, y:Number, $tween:Boolean = false):void
		{
			aimX = x;
			aimY = y;
			restrictXY();
			
			if ($tween)
			{
				updateTween();
			}
			else
			{
				mapX = aimX;
				mapY = aimY;
			}
		}
		
		
		/**
		 * 
		 * 缩放
		 * 
		 */
		
		public function scaleTo(scale:Number, $tween:Boolean = false):void
		{
			aimScale = scale;
			restrictScale();
			
			if ($tween)
			{
				updateTween();
			}
			else
			{
				mapScale = aimScale;
			}
		}
		
		
		/**
		 * @private
		 */
		protected	 function caculateScale():void
		{
			if (baseWidth == 0 || baseHeight == 0)
			{
				minScale = 1;
			}
			else
			{
				minScale = (baseWidth / baseHeight > viewWidth / viewHeight)
					? viewHeight / baseHeight : viewWidth  / baseWidth;
			}
			maxScale = minScale * 4;
		}
		
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			__mapX = __mapY = 0;
			__minScale = __maxScale = 1;
			super.addChild(container = new Sprite);
			super.addChild(cover = new Shape);
			container.mask = cover;
			setSize(480, 270);
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
		}
		
		/**
		 * @private
		 */
		private function setSize(w:Number, h:Number):void
		{
			viewWidth  = w;
			viewHeight = h;
			graphics.clear();
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
			cover.graphics.clear();
			cover.graphics.beginFill(0);
			cover.graphics.drawRect(0,0,w,h);
			cover.graphics.endFill();
			if (map)
			{
				caculateScale();
				restrictScale();
				restrictXY();
				mapScale = (isNaN(aimScale))?1:aimScale;
				mapX = (isNaN(aimX))?0:aimX;
				mapY = (isNaN(aimY))?0:aimY;
			}
		}
		
		//限制
		/**
		 * @private
		 */
		private function restrictScale():void
		{
			aimScale = MathUtil.clamp(aimScale, minScale, maxScale);
			if (aimScale!= mapScale)
			{
				//the rate of scale
				var s:Number = aimScale / mapScale;
				//the aim position after scale
				aimX = mouseX - (mouseX - mapX) * s;
				aimY = mouseY - (mouseY - mapY) * s;
				if (aimScale < mapScale) restrictXY();
			}
		}
		
		/**
		 * @private
		 */
		private function restrictXY():void
		{
			aimX = mapWidth  < viewWidth  ? (viewWidth  - mapWidth ) * .5 : MathUtil.clamp(aimX, minX, maxX);
			aimY = mapHeight < viewHeight ? (viewHeight - mapHeight) * .5 : MathUtil.clamp(aimY, minY, maxY);
		}
		
		/**
		 * @private
		 */
		private function updateTween():void
		{
			Tweener.removeTweens(this);
			Tweener.addTween(this, {
				mapScale:aimScale, 
				mapX:aimX, mapY:aimY, time:1
			});
		}
		
		
		/**
		 * @private
		 */
		private function mouseDown(e:MouseEvent):void
		{
			if (map) 
			{
				lastX = mouseX;
				lastY = mouseY;
				plusX = aimX = mapX;
				plusY = aimY = mapY;
				aimScale = mapScale;
				Tweener.removeTweens(this);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			}
		}
		
		/**
		 * @private
		 */
		private function mouseMove(e:MouseEvent):void
		{
			aimX = mouseX - lastX+plusX;
			aimY = mouseY - lastY+plusY;
			restrictXY();
			updateTween();
		}
		
		/**
		 * @private
		 */
		private function mouseUp(e:MouseEvent):void
		{
			restrictXY();
			updateTween();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		/**
		 * @private
		 */
		private function mouseWheel(e:MouseEvent):void
		{
			if (map)
			{
				aimScale *= e.delta>0 ? 1.05 : .95;
				restrictScale();
				updateTween();
			}
		}
		
		
		/**
		 * 
		 * 地图
		 * 
		 */
		
		public function get map():DisplayObject
		{
			return __map;
		}
		
		/**
		 * @private
		 */
		public function set map(value:DisplayObject):void
		{
			__map = value;
			while(container.numChildren)container.removeChildAt(0);
			if (map)
			{
				container.addChild(map);
				baseWidth  = map.width;
				baseHeight = map.height;
				caculateScale();
				reset();
			}
		}
		
		
		/**
		 * 
		 * 最小缩放
		 * 
		 */
		
		public function get minScale():Number
		{
			return __minScale;
		}
		
		/**
		 * @private
		 */
		public function set minScale(value:Number):void
		{
			if (value > maxScale) {
				value = maxScale;
			}
			__minScale = value;
		}
		
		
		/**
		 * 
		 * 最大缩放
		 * 
		 */
		
		public function get maxScale():Number
		{
			return __maxScale;
		}
		
		/**
		 * @private
		 */
		public function set maxScale(value:Number):void
		{
			
			__maxScale = value;
		}
		
		
		/**
		 * 
		 * 地图缩放
		 * 
		 */
		
		public function get mapScale():Number
		{
			return container.scaleX;
		}
		
		/**
		 * @private
		 */
		public function set mapScale(value:Number):void
		{
			container.scaleX = container.scaleY = value;
		}
		
		
		/**
		 * 
		 * 重置时移动至的X坐标
		 * 
		 */
		
		public function get resetX():Number
		{
			return __resetX;
		}
		
		/**
		 * @private
		 */
		public function set resetX(value:Number):void
		{
			__resetX = value;
		}
		
		
		/**
		 * 
		 * 重置时移动至的Y坐标
		 * 
		 */
		
		public function get resetY():Number
		{
			return __resetY;
		}
		
		/**
		 * @private
		 */
		public function set resetY(value:Number):void
		{
			__resetY = value;
		}
		
		
		/**
		 * 
		 * 地图X坐标
		 * 
		 */
		
		public function get mapX():Number
		{
			return __mapX;
		}
		
		/**
		 * @private
		 */
		public function set mapX(value:Number):void
		{
			__mapX = value;
			container.x = Math.floor(100*mapX)*.01;
		}
		
		
		/**
		 * 
		 * 地图Y坐标
		 * 
		 */
		
		public function get mapY():Number
		{
			return __mapY;
		}
		
		/**
		 * @private
		 */
		public function set mapY(value:Number):void
		{
			__mapY = value;
			container.y =  Math.floor(100*mapY)*.01;
		}
		
		
		/**
		 * 
		 * 地图宽度，随缩放值变化而变化
		 * 
		 */
		
		public function get mapWidth():Number
		{
			return baseWidth*aimScale;
		}
		
		
		/**
		 * 
		 * 地图高度，随缩放值变化而变化
		 * 
		 */
		
		public function get mapHeight():Number
		{
			return baseHeight*aimScale;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function get width():Number
		{
			return viewWidth;
		}
		
		/**
		 * @private
		 */
		override public function set width(value:Number):void
		{
			if(viewWidth!= value) setSize(value, viewHeight);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function get height():Number
		{
			return viewHeight;
		}
		
		/**
		 * @private
		 */
		override public function set height(value:Number):void
		{
			if(viewHeight!=value) setSize(viewWidth, value);
		}
		
		
		/**
		 * @private
		 */
		private function get cenX():Number
		{
			return (viewWidth * .5 - mapX) / mapScale;
		}
		
		/**
		 * @private
		 */
		private function get cenY():Number
		{
			return (viewHeight * .5 - mapY) / mapScale;
		}
		
		/**
		 * @private
		 */
		private function get minX():Number
		{
			return viewWidth-mapWidth;
		}
		
		/**
		 * @private
		 */
		private function get maxX():Number
		{
			return 0;
		}
		
		/**
		 * @private
		 */
		private function get minY():Number
		{
			return viewHeight-mapHeight;
		}
		
		/**
		 * @private
		 */
		private function get maxY():Number
		{
			return 0;
		}
		
		
		//当前移动或缩放时移动的目标值
		
		/**
		 * @private
		 */
		private var aimX:Number;
		
		/**
		 * @private
		 */
		private var aimY:Number;
		//当前移动或缩放时缩放的目标值，该值在计算坐标限制时有效
		
		/**
		 * @private
		 */
		private var aimScale:Number;
		
		//鼠标移动使用的临时变量
		//鼠标按下时容器的mouseX mouseY
		
		/**
		 * @private
		 */
		private var plusX:Number;
		
		/**
		 * @private
		 */
		private var plusY:Number;
		
		//鼠标按下时this的mouseX mouseY
		
		/**
		 * @private
		 */
		private var lastX:Number;
		
		/**
		 * @private
		 */
		private var lastY:Number;
		
		/**
		 * @private
		 */
		private var baseWidth:Number;
		
		/**
		 * @private
		 */
		private var baseHeight:Number;
		
		/**
		 * @private
		 */
		private var viewWidth:Number;
		
		/**
		 * @private
		 */
		private var viewHeight:Number;
		
		/**
		 * @private
		 */
		private var container:Sprite;
		
		/**
		 * @private
		 */
		private var cover:Shape;
		
		/**
		 * @private
		 */
		private var __map:DisplayObject;
		
		/**
		 * @private
		 */
		private var __minScale:Number;
		
		/**
		 * @private
		 */
		private var __maxScale:Number;
		
		/**
		 * @private
		 */
		private var __resetX:Number;
		
		/**
		 * @private
		 */
		private var __resetY:Number;
		
		/**
		 * @private
		 */
		private var __mapX:Number;
		
		/**
		 * @private
		 */
		private var __mapY:Number;
		
	}
}