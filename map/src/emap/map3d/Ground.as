package emap.map3d
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
	
	import emap.core.em;
	import emap.data.Layout;
	import emap.data.Step;
	import emap.interfaces.IGround;
	import emap.map3d.utils.Map3DUtil;
	import emap.utils.StepUtil;
	import emap.vos.VOFloor;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	
	
	public final class Ground extends Object3D implements IGround
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
			if (shape) StepUtil.drawSteps(shape.graphics, $steps);
		}
		
		
		/**
		 * 
		 * 绘制完毕。
		 * 
		 */
		
		public function completeSteps():void
		{
			if (shape)
			{
				shape.graphics.endFill();
				
				Map3DUtil.destroyObject3D(plane);
				
				addChild(plane = Map3DUtil.getPlaneByShape(shape, em::layout));
				
				shape = null;
			}
		}
		
		
		/**
		 * @private
		 */
		private function initialize($data:VOFloor):void
		{
			mouseEnabled = mouseChildren = false;
			
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
				
				shape = shape || new Shape;
				shape.graphics.clear();
				shape.graphics.beginFill(em::color);
				
				StepUtil.drawSteps(shape.graphics, em::layout.steps);
			}
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
		private var plane:Object3D;
		
		
		/**
		 * @private
		 */
		em var data:VOFloor;
		
	}
}