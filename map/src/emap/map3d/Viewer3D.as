package emap.map3d
{
	
	/**
	 * 
	 * 交互容器。
	 * 
	 */
	
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.lights.DirectionalLight;
	
	import caurina.transitions.Tweener;
	
	import cn.vision.core.UI;
	import cn.vision.utils.MathUtil;
	import cn.vision.utils.StageUtil;
	
	import emap.core.em;
	import emap.map3d.tools.SourceEmap3D;
	import emap.map3d.utils.Map3DUtil;
	
	import flash.display.Stage3D;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import org.gestouch.core.gestouch_internal;
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.TransformGesture;
	
	
	public class Viewer3D extends UI
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function Viewer3D()
		{
			super();
			
			initialize();
		}
		
		
		/**
		 * 
		 * 地图某点平移到摄像机中心视野位置。
		 * 
		 */
		
		public function moveTo($x:Number, $y:Number, $tween:Boolean = false):void
		{
			cameraMoveX = $x;
			cameraMoveY = $y;
		}
		
		
		/**
		 * 
		 * 重置地图。
		 * 
		 */
		
		public function reset($tween:Boolean = false):void
		{
			aimCameraMoveX = 0;
			aimCameraMoveY = 0;
			aimCameraDistance  = initializeCameraDistance;
			aimCameraRotationX = initializeRotationX;
			aimCameraRotationZ = initializeRotationZ;
			if ($tween)
			{
				updateTween();
			}
			else
			{
				cameraMoveX     = aimCameraMoveX;
				cameraMoveY     = aimCameraMoveY;
				cameraDistance  = aimCameraDistance;
				cameraRotationX = aimCameraRotationX;
				cameraRotationZ = aimCameraRotationZ;
			}
		}
		
		
		/**
		 * 
		 * 上传所有资源至context3D。
		 * 
		 */
		
		protected function uploadAllSource():void
		{
			if (contextCreated)
				SourceEmap3D.uploadAllSources(main);
		}
		
		
		/**
		 * @private
		 */
		protected function updateTween():void
		{
			Tweener.removeTweens(this);
			Tweener.addTween(this, {time:1,
				cameraMoveX:aimCameraMoveX,
				cameraMoveY:aimCameraMoveY,
				cameraDistance :aimCameraDistance,
				cameraRotationX:aimCameraRotationX,
				cameraRotationZ:aimCameraRotationZ
			});
		}
		
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			camera = new Camera3D(-250, 160000);
			
			camera.view = new View(width, height, false, 0, 0, 3);
			camera.view.hideLogo();
			camera.view.antiAlias = 16;
			
			camera.fov = Math.PI * .5;
			camera.orthographic = true;
			
			addChild(camera.view);
			
			cameraContainerM = new Object3D;
			cameraContainerX = new Object3D;
			cameraContainerZ = new Object3D;
			
			main.addChild(cameraContainerM);
			cameraContainerM.addChild(cameraContainerZ);
			cameraContainerZ.addChild(cameraContainerX);
			cameraContainerX.addChild(camera);
			
			var diagnal:Number = 20000 * Math.tan(camera.fov * .5);
			var angle:Number = width ? Math.atan(height / width) : 0.7853981633974483;//Math.atan(1)
			
			backgroundLayer = new Background(diagnal * Math.cos(angle), diagnal * Math.sin(angle), 16, 10);
			backgroundLayer.x = 0;
			backgroundLayer.y = 0;
			backgroundLayer.z = maxCameraDistance * 2;
			backgroundLayer.source = 0xAAAAAA;
			camera.addChild(backgroundLayer);
			
			directLight = new DirectionalLight(0xFFFFFF);
			directLight.x = 1700;
			directLight.y =-1300;
			directLight.z = 1000;
			directLight.lookAt(0, 0, 0);
			main.addChild(directLight);
			
			ambientLight = new AmbientLight(0xAAAAAA);
			main.addChild(ambientLight);
			
			reset();
			
			camera.lookAt(0, 0, 0);
			
			addEventListener(MouseEvent.MOUSE_DOWN, handlerMouseDown);
			addEventListener(MouseEvent.MOUSE_WHEEL, handlerMouseWheel);
			//增加缩放事件
			gesture = new TransformGesture(this);
			gesture.addEventListener(GestureEvent.GESTURE_BEGAN, gestureBegin);
			var handlerContext3DCreate:Function = function($e:Event):void
			{
				scene.removeEventListener(Event.CONTEXT3D_CREATE, handlerContext3DCreate);
				
				contextCreated = true;
				uploadAllSource();
				
				timer = new Timer(33);
				timer.addEventListener(TimerEvent.TIMER, handlerTimer);
				timer.start();
			};
			
			var handlerAddedToStage:Function = function():void
			{
				SourceEmap3D.initializeStage(scene = stage.stage3Ds[0]);
				
				scene.addEventListener(Event.CONTEXT3D_CREATE, handlerContext3DCreate);
				
				scene.requestContext3D();
			};
			
			StageUtil.init(this, handlerAddedToStage);
		}
		
		
		/**
		 * @private
		 */
		private function move($x:Number, $y:Number):void
		{
			var fac:Number = Math.cos(cameraRotationX);
			$y = -$y / (fac == 0 ? 1 : fac);
			var cos:Number = Math.cos(em::cameraRotationZ);
			var sin:Number = Math.sin(em::cameraRotationZ);
			aimCameraMoveX = start.x - factor * ($x * cos - $y * sin);
			aimCameraMoveY = start.y - factor * ($x * sin + $y * cos);
			
			updateTween();
		}
		/**
		 * @private
		 */
		private function gestureBegin(e:GestureEvent):void
		{
			gesture.addEventListener(GestureEvent.GESTURE_CHANGED, gestureChanged);
			gesture.addEventListener(GestureEvent.GESTURE_POSSIBLE, gesturePossible);
		}
		
		/**
		 * @private
		 */
		private function gesturePossible(e:GestureEvent):void
		{
			gesture.removeEventListener(GestureEvent.GESTURE_CHANGED, gestureChanged);
			gesture.removeEventListener(GestureEvent.GESTURE_POSSIBLE, gesturePossible);
			gesturing = false;
		}
		
		/**
		 * @private
		 */
		private function gestureChanged(e:GestureEvent):void
		{
			if (e.newState.gestouch_internal::isEndState)
			{
				gesture.removeEventListener(GestureEvent.GESTURE_CHANGED, gestureChanged);
				gesture.removeEventListener(GestureEvent.GESTURE_POSSIBLE, gesturePossible);
				gesturing = false;
			}
			else
			{
				if (gesture.touchesCount == 2)
				{
					if(!gesturing)
					{
						gesturing = true;
					}
					else
					{
						aimCameraDistance *=1/gesture.scale;

						updateTween();
					}
				}
				else
				{
					if (gesturing) gesturing = false;
				}
			}
		}
		
		/**
		 * @private
		 */
		private function rotate($x:Number, $y:Number):void
		{
			aimCameraRotationZ = start.x - $x * .005;
			aimCameraRotationX = start.y - $y * .005;
			
			updateTween();
		}
		
		
		/**
		 * @private
		 */
		private function handlerMouseDown($e:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handlerMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, handlerMouseUp);
			
			mouse.x = mouseX;
			mouse.y = mouseY;
			
			var move:Boolean = mode == "move";
			
			start.x = move ? cameraMoveX : cameraRotationZ;
			start.y = move ? cameraMoveY : cameraRotationX;
			
			Tweener.removeTweens(this);
		}
		
		/**
		 * @private
		 */
		private function handlerMouseMove($e:MouseEvent):void
		{
			this[mode](mouseX - mouse.x, mouseY - mouse.y);
		}
		
		/**
		 * @private
		 */
		private function handlerMouseUp($e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, handlerMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, handlerMouseUp);
		}
		
		/**
		 * @private
		 */
		private function handlerMouseWheel($e:MouseEvent):void
		{
			aimCameraDistance = cameraDistance - $e.delta * 100;
			
			updateTween();
		}
		
		/**
		 * @private
		 */
		private function handlerTimer($e:TimerEvent):void
		{
			camera.render(scene);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function get height():Number
		{
			return em::height;
		}
		
		/**
		 * @private
		 */
		override public function set height($value:Number):void
		{
			if ($value!= em::height)
			{
				em::height = $value;
				camera.view.height = $value;
			}
		}
		
		
		/**
		 * 
		 * 主场景Object3D。
		 * 
		 */
		
		public function get main():Object3D
		{
			return em::main;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function get width():Number
		{
			return em::width;
		}
		
		/**
		 * @private
		 */
		override public function set width($value:Number):void
		{
			if ($value!= em::width)
			{
				em::width = $value;
				camera.view.width = $value;
			}
		}
		
		
		/**
		 * 
		 * 背景，可以是图片地址或16进制uint类型颜色值。
		 * 
		 */
		
		public function get background():*
		{
			return em::background;
		}
		
		/**
		 * @private
		 */
		public function set background($value:*):void
		{
			em::background = $value;
			backgroundLayer.source = background;
			SourceEmap3D.uploadAllSources(backgroundLayer);
		}
		
		
		/**
		 * 
		 * 是否启用。
		 * 
		 */
		
		override public function get enabled():Boolean
		{
			return super.enabled;
		}
		
		/**
		 * @private
		 */
		override public function set enabled($value:Boolean):void
		{
			if (enabled != $value)
			{
				super.enabled = $value;
				if (enabled)
				{
					addEventListener(MouseEvent.MOUSE_DOWN, handlerMouseDown);
					addEventListener(MouseEvent.MOUSE_WHEEL, handlerMouseWheel);
				}
				else
				{
					removeEventListener(MouseEvent.MOUSE_DOWN, handlerMouseDown);
					removeEventListener(MouseEvent.MOUSE_WHEEL, handlerMouseWheel);
				}
			}
		}
		
		
		/**
		 * 
		 * 鼠标交互模式，平移和旋转。
		 * 
		 */
		
		public function get mode():String
		{
			return em::mode;
		}
		
		/**
		 * @private
		 */
		public function set mode($value:String):void
		{
			if (mode!= $value)
			{
				if ($value!= "rotate") $value = "move";
				em::mode = $value;
			}
		}
		
		
		/**
		 * 
		 * 初始摄像机距离。
		 * 
		 */
		
		public function get initializeCameraDistance():Number
		{
			return em::initializeCameraDistance;
		}
		
		/**
		 * @private
		 */
		public function set initializeCameraDistance($value:Number):void
		{
			if (!isNaN($value)) em::initializeCameraDistance = $value;
		}
		
		
		/**
		 * 
		 * 初始X轴旋转角度。
		 * 
		 */
		
		public function get initializeRotationX():Number
		{
			return em::initializeRotationX;
		}
		
		/**
		 * @private
		 */
		public function set initializeRotationX($value:Number):void
		{
			if (!isNaN($value)) em::initializeRotationX = $value;
		}
		
		
		/**
		 * 
		 * 初始Z轴旋转角度。
		 * 
		 */
		
		public function get initializeRotationZ():Number
		{
			return em::initializeRotationZ;
		}
		
		/**
		 * @private
		 */
		public function set initializeRotationZ($value:Number):void
		{
			if (!isNaN($value)) em::initializeRotationX = $value;
		}
		
		
		/**
		 * 
		 * 最远摄像机距离。
		 * 
		 */
		
		public function get maxCameraDistance():Number
		{
			return em::maxCameraDistance;
		}
		
		/**
		 * @private
		 */
		public function set maxCameraDistance($value:Number):void
		{
			if (Map3DUtil.numable(maxCameraDistance, $value))
			{
				em::maxCameraDistance = Math.max(minCameraDistance, $value);
				cameraDistance = Math.min(cameraDistance, maxCameraDistance);
				backgroundLayer.z = maxCameraDistance + 1000;
			}
		}
		
		
		/**
		 * 
		 * 最近摄像机距离。
		 * 
		 */
		
		public function get minCameraDistance():Number
		{
			return em::minCameraDistance;
		}
		
		/**
		 * @private
		 */
		public function set minCameraDistance($value:Number):void
		{
			if (Map3DUtil.numable(minCameraDistance, $value))
			{
				em::maxCameraDistance = Math.min(maxCameraDistance, $value);
				cameraDistance = Math.max(cameraDistance, minCameraDistance);
			}
		}
		
		
		/**
		 * 
		 * 摄像机与地图之间的距离。
		 * 
		 */
		
		public function get cameraDistance():Number
		{
			return em::cameraDistance;
		}
		
		/**
		 * @private
		 */
		public function set cameraDistance($value:Number):void
		{
			if (Map3DUtil.numable(cameraDistance, $value))
			{
				em::cameraDistance = MathUtil.clamp($value, minCameraDistance, maxCameraDistance);
				
				camera.z = cameraDistance;
				
				camera.scaleX = camera.scaleY = camera.scaleZ = factor = cameraDistance * .001;
				
				//如果是寻路模式，控制线条粗细。
			}
		}
		
		
		/**
		 * 
		 * 最大摄像机X轴移动距离
		 * 
		 */
		
		public function get maxCameraMoveX():Number
		{
			return em::maxCameraMoveX;
		}
		
		/**
		 * @private
		 */
		public function set maxCameraMoveX($value:Number):void
		{
			if (Map3DUtil.numable(maxCameraMoveX, $value))
			{
				em::maxCameraMoveX = Math.max(minCameraMoveX, $value);
				cameraMoveX = Math.min(cameraMoveX, maxCameraMoveX);
			}
		}
		
		
		/**
		 * 
		 * 最小摄像机X轴移动距离
		 * 
		 */
		
		public function get minCameraMoveX():Number
		{
			return em::minCameraMoveX;
		}
		
		/**
		 * @private
		 */
		public function set minCameraMoveX($value:Number):void
		{
			if (Map3DUtil.numable(minCameraMoveX, $value))
			{
				em::minCameraMoveX = Math.min(maxCameraMoveX, $value);
				cameraMoveX = Math.max(cameraMoveX, minCameraMoveX);
			}
		}
		
		
		/**
		 * 
		 * 摄像机X轴移动距离
		 * 
		 */
		
		public function get cameraMoveX():Number
		{
			return em::cameraMoveX;
		}
		
		/**
		 * @private
		 */
		public function set cameraMoveX($value:Number):void
		{
			if (Map3DUtil.numable(cameraMoveX, $value))
			{
				em::cameraMoveX = MathUtil.clamp($value, minCameraMoveX, maxCameraMoveX);
				cameraContainerM.x = cameraMoveX;
			}
		}
		
		
		/**
		 * 
		 * 最大摄像机Y轴移动距离
		 * 
		 */
		
		public function get maxCameraMoveY():Number
		{
			return em::maxCameraMoveY;
		}
		
		/**
		 * @private
		 */
		public function set maxCameraMoveY($value:Number):void
		{
			if (Map3DUtil.numable(maxCameraMoveY, $value))
			{
				em::maxCameraMoveY = Math.max(minCameraMoveY, $value);
				cameraMoveY = Math.min(cameraMoveY, maxCameraMoveY);
			}
		}
		
		
		/**
		 * 
		 * 最小摄像机X轴移动距离
		 * 
		 */
		
		public function get minCameraMoveY():Number
		{
			return em::minCameraMoveY;
		}
		
		/**
		 * @private
		 */
		public function set minCameraMoveY($value:Number):void
		{
			if (Map3DUtil.numable(minCameraMoveY, $value))
			{
				em::minCameraMoveY = Math.min(maxCameraMoveY, $value);
				cameraMoveY = Math.max(cameraMoveY, minCameraMoveY);
			}
		}
		
		
		/**
		 * 
		 * 摄像机Y轴移动距离
		 * 
		 */
		
		public function get cameraMoveY():Number
		{
			return em::cameraMoveY;
		}
		
		/**
		 * @private
		 */
		public function set cameraMoveY($value:Number):void
		{
			if (Map3DUtil.numable(em::cameraMoveY, $value))
			{
				em::cameraMoveY = MathUtil.clamp($value, em::minCameraMoveY, em::maxCameraMoveY);
				cameraContainerM.y = cameraMoveY;
			}
		}
		
		
		/**
		 * 
		 * 最大cameraRotationX
		 * 
		 */
		
		public function get maxCameraRotationX():Number
		{
			return em::maxCameraRotationX;
		}
		
		/**
		 * @private
		 */
		public function set maxCameraRotationX($value:Number):void
		{
			if (Map3DUtil.numable(maxCameraRotationX, $value))
			{
				em::maxCameraRotationX = Math.max(minCameraRotationX, $value);
				cameraRotationX = Math.min(cameraRotationX, maxCameraRotationX);
			}
		}
		
		
		/**
		 * 
		 * 最小cameraRotationX
		 * 
		 */
		
		public function get minCameraRotationX():Number
		{
			return em::minCameraRotationX;
		}
		
		/**
		 * @private
		 */
		public function set minCameraRotationX($value:Number):void
		{
			if (Map3DUtil.numable(minCameraRotationX, $value))
			{
				em::minCameraRotationX = Math.min(maxCameraRotationX, $value);
				cameraRotationX = Math.max(cameraRotationX, minCameraRotationX);
			}
		}
		
		
		/**
		 * 
		 * cameraRotationX
		 * 
		 */
		
		public function get cameraRotationX():Number
		{
			return em::cameraRotationX;
		}
		
		/**
		 * @private
		 */
		public function set cameraRotationX($value:Number):void
		{
			if (Map3DUtil.numable(cameraRotationX, $value))
			{
				em::cameraRotationX = MathUtil.clamp($value, minCameraRotationX, maxCameraRotationX);
				cameraContainerX.rotationX = cameraRotationX;
			}
		}
		
		
		/**
		 * 
		 * cameraRotationZ
		 * 
		 */
		[Bindable]
		public function get cameraRotationZ():Number
		{
			return em::cameraRotationZ;
		}
		
		/**
		 * @private
		 */
		
		public function set cameraRotationZ($value:Number):void
		{
			if (Map3DUtil.numable(em::cameraRotationZ, $value))
			{
				em::cameraRotationZ = $value;
				cameraContainerZ.rotationZ = cameraRotationZ;
			}
		}
		
		
		/**
		 * 
		 * 是否开启缓动
		 * 
		 */
		
		public var tween:Boolean;
		
		
		/**
		 * context3D已创建
		 */
		protected var contextCreated:Boolean;
		
		/**
		 * 目标cameraMoveX
		 */
		protected var aimCameraMoveX:Number;
		
		/**
		 * 目标cameraMoveY
		 */
		protected var aimCameraMoveY:Number;
		
		/**
		 * 目标cameraRotationX
		 */
		protected var aimCameraRotationX:Number;
		
		/**
		 * 目标cameraRotationZ
		 */
		protected var aimCameraRotationZ:Number;
		
		/**
		 * 目标cameraDistance
		 */
		protected var aimCameraDistance:Number;
		
		
		/**
		 * @private
		 */
		private var moving:Boolean;
		
		/**
		 * @private
		 */
		private var ortho:Number = 0.000125;
		
		/**
		 * @private
		 */
		private var factor:Number = 1;
		
		/**
		 * @private
		 */
		private var camera:Camera3D;
		
		/**
		 * @private
		 */
		private var scene:Stage3D;
		
		/**
		 * @private
		 */
		private var start:Point = new Point;
		
		/**
		 * @private
		 */
		private var mouse:Point = new Point;
		
		/**
		 * @private
		 */
		private var timer:Timer;
		
		/**
		 * @private
		 */
		private var cameraContainerM:Object3D;
		
		/**
		 * @private
		 */
		private var cameraContainerX:Object3D;
		
		/**
		 * @private
		 */
		private var cameraContainerZ:Object3D;
		
		/**
		 * @private
		 */
		private var backgroundLayer:Background;
		
		/**
		 * @private
		 */
		private var directLight:DirectionalLight;
		
		/**
		 * @private
		 */
		private var ambientLight:AmbientLight;
		/**
		 * @private
		 */
		private var gesture:TransformGesture;
		
		//------------------------------------------------------------
		//手势控制临时变量
		//------------------------------------------------------------
		
		/**
		 * @private
		 */
		private var gesturing:Boolean;
		
		/**
		 * @private
		 */
		em var background:*;
		
		/**
		 * @private
		 */
		em var height:Number = 480;
		
		/**
		 * @private
		 */
		em var width:Number = 270;
		
		/**
		 * @private
		 */
		em var main:Object3D = new Object3D;
		
		/**
		 * @private
		 */
		em var mode:String = "move";
		
		/**
		 * @private
		 */
		em var initializeCameraDistance:Number = 2500;
		
		/**
		 * @private
		 */
		em var initializeRotationX:Number = Math.PI / 5;
		
		/**
		 * @private
		 */
		em var initializeRotationZ:Number = 0;
		
		/**
		 * @private
		 */
		em var maxCameraDistance:Number = 3000;
		
		/**
		 * @private
		 */
		em var minCameraDistance:Number = 1000;
		
		/**
		 * @private
		 */
		em var cameraDistance:Number = 0;
		
		/**
		 * @private
		 */
		em var maxCameraMoveX:Number = 6100;
		
		/**
		 * @private
		 */
		em var minCameraMoveX:Number =-6100;
		
		/**
		 * @private
		 */
		em var cameraMoveX:Number = 0;
		
		/**
		 * @private
		 */
		em var maxCameraMoveY:Number = 6100;
		
		/**
		 * @private
		 */
		em var minCameraMoveY:Number =-6100;
		
		/**
		 * @private
		 */
		em var cameraMoveY:Number = 0;
		
		/**
		 * @private
		 */
		em var maxCameraRotationX:Number = Math.PI / 2.5;
		
		/**
		 * @private
		 */
		em var minCameraRotationX:Number = 0;
		
		/**
		 * @private
		 */
		em var cameraRotationX:Number = 0;
		
		/**
		 * @private
		 */
		em var cameraRotationZ:Number = 0;
		
	}
}