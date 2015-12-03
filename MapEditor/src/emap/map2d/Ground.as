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
	
	import editor.core.EDConfig;
	
	import emap.consts.StepStyleConsts;
	import emap.core.em;
	import emap.data.Layout;
	import emap.data.Step;
	import emap.interfaces.IGround;
	import emap.map2d.core.E2Config;
	import emap.map2d.core.E2Provider;
	import emap.map2d.vos.E2VOPosition;
	import emap.map3d.utils.Map3DUtil;
	import emap.utils.StepUtil;
	import emap.vos.VOFloor;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import mx.core.mx_internal;
	
	
	public final class Ground extends Sprite implements IGround
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function Ground(e2Config:E2Config,$data:VOFloor = null)
		{
			super();
			
			initialize(e2Config,$data);
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
			
		}
		
		
		/**
		 * @private
		 */
		private function initialize(e2Config:E2Config,$data:VOFloor):void
		{
			this.mouseEnabled = this.mouseChildren = false;
			config = e2Config;
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

				StepUtil.drawSteps(graphics, em::layout.steps);
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
		//楼层图形进入编辑模式:1.新增楼层  2.清空的情况下
		public function set editSteps($value:Boolean):void
		{
			if ($value)
			{
				while(numChildren) removeChildAt(0);
				this.mouseEnabled = this.mouseChildren =true;
				//进入编辑模式
				editorLayer = new Sprite;
				editorLayer.graphics.beginFill(0x00BFFF,0.2);
				editorLayer.graphics.drawRect(0,0,5000,5000);
				editorLayer.graphics.endFill();
				addChild(editorLayer);
				
				editorLayer.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown_Handler);
				points = new Vector.<DrawStep>;
				//创建矩形
				
				//针对背景添加鼠标监听
			}else
			{
				if(editorLayer && this.contains(editorLayer))
				{
					editorLayer.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDown_Handler);
					removeChild(editorLayer);
					
				}
				EDConfig.instance.e2Config.utilLayer.clear();
				
				
//				if(EDConfig.instance.selectedFloor)
//				{
//					EDConfig.instance.e2Config.floorViewMap[EDConfig.instance.selectedFloor.id].childVisible = true;
//					EDConfig.instance.e2Config.groundViewMap[EDConfig.instance.selectedFloor.id].editSteps = false;
//				}
				
				update();
				EDConfig.instance.e2Config.setEditor = false;
			}
			
		}
		protected function mouseDown_Handler(event:MouseEvent):void
		{	
			//在编辑状态的情况下 如果点击的是点 就使点可以移动  如果是空白那么就新产生点
			if(event.target is AimPoint )
			{
				d = event.target.parent as DrawStep;
				editorLayer.addEventListener(MouseEvent.MOUSE_MOVE,mouseMove_Handler);
				editorLayer.addEventListener(MouseEvent.MOUSE_UP,mouseUp_Handler)
			}
			else
			{
				if(config.editorStyle== StepStyleConsts.MOVE_TO||(em::layout.steps.length==0))
				{
				
					var firtStep:Step = new Step;
					var lastStep:Step = new Step;
					firtStep.style = config.editorStyle;
					config.editorStyle = StepStyleConsts.LINE_TO;
					lastStep.style = config.editorStyle;
					lastStep.aim.x=firtStep.aim.x = parent.mouseX;
					lastStep.aim.y=firtStep.aim.y = parent.mouseY;
					em::layout.steps.push(firtStep);
					em::layout.steps.push(lastStep);
				}
				else if(config.editorStyle== StepStyleConsts.LINE_TO)
				{
					var lStep:Step = new Step;
					lStep.style = config.editorStyle;
					lStep.aim.x = parent.mouseX;
					lStep.aim.y = parent.mouseY;
					em::layout.steps.splice(em::layout.steps.length-1,0,lStep)
				}
				else if(config.editorStyle== StepStyleConsts.CURVE_TO)
				{
					if(em::layout.steps.length>0)
					{
						var cStep:Step = new Step;
						cStep.style = config.editorStyle;
						cStep.aim.x = parent.mouseX;
						cStep.aim.y = parent.mouseY;
						var steps:Vector.<Step> = em::layout.steps;
						
							var sStep:Step = steps[steps.length-2];
							cStep.ctr.x = (cStep.aim.x+sStep.aim.x)/2;
							cStep.ctr.y = (cStep.aim.y+sStep.aim.y)/2;
						em::layout.steps.splice(em::layout.steps.length-1,0,cStep)
					}
				}

				config.utilLayer.ground =this;
			
				
				update();
			}
		}
		protected function mouseUp_Handler(event:MouseEvent):void
		{
			editorLayer.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMove_Handler);
			editorLayer.removeEventListener(MouseEvent.MOUSE_UP,mouseUp_Handler);
			
		}
		
		protected function mouseMove_Handler(event:MouseEvent):void
		{
			
			if(d)
			{
				event.stopImmediatePropagation();
				d.update(this.mouseX, this.mouseY,event.target);
				update();
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
		public function get scale():Number
		{
			return __scale;
		}
		public function set scale(value:Number):void
		{
			if(value==scale) return;
			__scale = value;
			for each(var drawStep:DrawStep in points)
			{
				drawStep.scale = value;
			}
			
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
		private var editorLayer:Sprite;
		private var d:DrawStep;
		private var config:E2Config;
	}
}