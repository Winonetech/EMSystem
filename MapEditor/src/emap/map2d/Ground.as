package emap.map2d
{
	
	/**
	 * 
	 * 地形。
	 * 
	 */
	
	
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.primitives.Plane;
	import alternativa.engine3d.resources.BitmapTextureResource;
	
	import emap.map2d.core.E2Config;
	
	import emap.core.em;
	import emap.data.Layout;
	import emap.data.Step;
	import emap.interfaces.IGround;
	import emap.map2d.core.E2Provider;

	import emap.map2d.vos.E2VOPosition;
	import emap.map3d.utils.Map3DUtil;
	import emap.utils.StepUtil;
	import emap.vos.VOFloor;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	
	public final class Ground extends Sprite implements IGround
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function Ground($data:VOFloor = null)
		{
			super();
			
			initialize($data);
		}
		
		
		/**
		 * 
		 * 绘制形状。
		 * 
		 */
		
		public function drawHollow($steps:Vector.<Step>):void
		{
			if (shape) StepUtil.drawSteps(shape.graphics, $steps, true);
		}
		
		
		/**
		 * 
		 * 绘制完毕。
		 * 
		 */
		
		public function completeSteps():void
		{
			
			graphics.endFill();
			
			
			
			//addChild(plane = Map3DUtil.getPlaneByShape(shape, em::layout));
			
			
			
		}
		
		
		/**
		 * @private
		 */
		private function initialize($data:VOFloor):void
		{
			this.mouseEnabled = this.mouseChildren = false;
			
			data = $data;
		}
		
		
		/**
		 * 
		 * 设置地形数据。<br>
		 * 在设置地形数据之前，需先调用startRender()方法开始渲染，
		 * 在上一级Floor添加完所有位置后，调用stopRender结束渲染。
		 * 
		 */
		
		public function get data():VOFloor
		{
			return em::data;
		}
		
		/**
		 * @private
		 */
		public function set data($value:VOFloor):void
		{
			if (data!= $value)
			{
				em::data = $value;
				
				
				graphics.clear();
				graphics.beginFill(em::color);
				
				//StepUtil.drawSteps(graphics, em::layout.steps, true);
//				pointArr = new Array;
//				addChild(pointLayer = new Sprite);
//				for each (var step:Step in em::layout.steps)
//				{
//					var drawStep:DrawStep = new DrawStep(step);
//					
//					pointArr.push(drawStep);
//					pointLayer.addChild(drawStep);
//				}
				StepUtil.drawSteps(graphics, em::layout.steps);
				
			//	addPositionByFloor(data);
			}
		}
		protected function addPositionByFloor($value:VOFloor):void
		{  
			var i:Number =0
			for each (var p:E2VOPosition in E2Provider.instance.positionArr)
			{
			 
				if(p.floorID==$value.id)
				{
					i++;
					var position:Position = new Position(new E2Config,p);
					position.visible = true;
					addChild(position);
					
				}
			}
			
		}
		public function update():void
		{
			graphics.clear();
			graphics.beginFill(em::color);
			StepUtil.drawSteps(graphics, em::layout.steps);
		}
		
		
		/**
		 * 
		 * 颜色
		 * 
		 */
		
		em function get color():uint
		{
			return data ? data.color : 0;
		}
		
		
		
		/**
		 * 
		 * 布局信息
		 * 
		 */
		
		em function get layout():Layout
		{
			return data ? data.layout : null;
		}
		public function get scale():Number
		{
			return __scale;
		}
		public function set scale(value:Number):void
		{
			if(value==scale) return;
			__scale = value;
			
			//	floorLayer.scale = scale;
			
			//			for each (var place:Place in placesArr) {
			//				place.scale = scale;
			//			}
			
			
		}
	
		private var __scale:Number;
		
		/**
		 * @private
		 */
		private var pointArr:Array;
		/**
		 * @private
		 */
		private var rendering:Boolean;
		
		/**
		 * @private
		 */
		private var shape:Shape;
		
		/**
		 * @private
		 */
		private var pointLayer:Sprite;
		
		/**
		 * @private
		 */
		private var points:Vector.<DrawStep>;
		
		/**
		 * @private
		 */
	
		
		
		/**
		 * @private
		 */
		em var data:VOFloor;
		
	}
}