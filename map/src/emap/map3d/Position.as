package emap.map3d
{
	
	/**
	 * 
	 * 位置视图。
	 * 
	 */
	
	
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.resources.Geometry;
	
	import caurina.transitions.Tweener;
	
	import cn.vision.utils.ArrayUtil;
	import cn.vision.utils.StringUtil;
	
	import emap.consts.PositionCodeConsts;
	import emap.consts.StepStyleConsts;
	import emap.core.EMConfig;
	import emap.core.em;
	import emap.data.Layout;
	import emap.data.Step;
	import emap.interfaces.IPosition;
	import emap.map3d.comman.logo.*;
	import emap.map3d.tools.SourceEmap3D;
	import emap.map3d.utils.Map3DUtil;
	import emap.utils.PositionUtil;
	import emap.utils.StepUtil;
	import emap.vos.VOPosition;
	
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Timer;
	
	
	public final class Position extends Object3D implements IPosition
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function Position($config:EMConfig, $data:VOPosition = null)
		{
			super();
			
			initialize($config, $data);
		}
		
		
		/**
		 * @private
		 */
		private function initialize($config:EMConfig, $data:VOPosition):void
		{
			mouseEnabled = false;
			config = $config;
			data = $data;
		}
		
		/**
		 * @private
		 */
		private function update():void
		{
			
			mouseEnabled = useHandCursor = PositionUtil.interactable(code);
			if (steps && steps.length > 2)
			{
				updateTop();
				updateSide();
				updateMesh();
			}
			
			updateIcon();
			updateIconLayout();
			
			updateLabel();
			updateLabelLayout();
		}
		
		/**
		 * @private
		 */
		private function updateTop():void
		{
			//判断是否需要创建顶面
			if (PositionUtil.displayTop(code))
			{
				var shape:Shape = new Shape;
				shape.graphics.beginFill(color);
				StepUtil.drawSteps(shape.graphics, steps, true);
				shape.graphics.endFill();
				
				addChild(top = Map3DUtil.getPlaneByShape(shape, layout)).z = thick;
			}
		}
		
		/**
		 * @private
		 */
		private function updateSide():void
		{
			//判断是否需要创建侧面。
			if (PositionUtil.displaySide(code))
			{
				var bottom:Number = code == PositionCodeConsts.PATIO ? 0 : -selectH;
				//获取所有面
				var faces:Array = [], l:uint = steps.length - 1, step:Step, next:Step;
				var cret:Function = function($start:Point, $end:Point):void
				{
					faces[faces.length] = [
						new Vector3D($start.x, -$start.y, bottom),
						new Vector3D($end  .x, -$end  .y, bottom),
						new Vector3D($start.x, -$start.y, thick),
						new Vector3D($end  .x, -$end  .y, thick),
					];
				};
				for (var i:uint = 0; i < l; i++)
				{
					step = steps[i];
					next = steps[i + 1];
					switch(next.style)
					{
						case StepStyleConsts.LINE_TO:
							cret(step.aim, next.aim);
							break;
						case StepStyleConsts.CURVE_TO:
							var points:Vector.<Point> = next.getPoints(step.aim);
							var o:uint = points.length - 1;
							cret(step.aim, points[0]);
							var end:Point = points[points.length - 1];
							if (end.x != next.aim.x || end.y != next.aim.y)
								cret(points[points.length - 1], next.aim);
							for (var j:uint = 0; j < o; j++)
								cret(points[j], points[j + 1]);
							break;
					}
				}

				//创建侧面
				var crfe:Function = function($face:Array, $index:uint, $array:Array):void
				{
					var v1:Vector3D = new Vector3D($face[0].x - $face[1].x, $face[0].y - $face[1].y);
					var v2:Vector3D = new Vector3D($face[2].x - $face[1].x, $face[2].y - $face[1].y);
					var v3:Vector3D = v1.crossProduct(v2);
					v3.normalize();
					for (var i:uint = 0; i < 4; i++)
					{
						var face:Vector3D = $face[i];
						ArrayUtil.push(vxs, face.x, face.y, face.z);
						ArrayUtil.push(uvs, face.x * .001, face.y * .001);
						ArrayUtil.push(nms, v3.x, v3.y, v3.z);
					}
					//uv 矩阵
					ArrayUtil.push(fci, num, num + 1, num + 3);
					ArrayUtil.push(fci, num, num + 3, num + 1);
					ArrayUtil.push(fci, num, num + 3, num + 2);
					ArrayUtil.push(fci, num, num + 2, num + 3);
					num += 4;
				};
				faces.forEach(crfe);
				Map3DUtil.destroyObject3D(mesh);
				//创建Mesh
				var gem:Geometry = new Geometry(num);
				gem.addVertexStream(SourceEmap3D.ATTRIBUTES);
				gem.setAttributeValues(VertexAttributes.POSITION, vxs);
				gem.setAttributeValues(VertexAttributes.TEXCOORDS[0], uvs);
				gem.setAttributeValues(VertexAttributes.NORMAL, nms);
				gem.indices = fci;
				addChild(mesh = new Mesh);
				mesh.geometry = gem;
				mesh.addSurface(SourceEmap3D.getColorMaterial(color), 0, num);
				mesh.calculateBoundBox();
			}
		}
		
		/**
		 * @private
		 */
		private function updateMesh():void
		{
			
		}
		
		/**
		 * @private
		 */
		private function updateIcon():void
		{
			Map3DUtil.destroyObject3D(iconLayer);
			if (iconVisible && !StringUtil.isEmpty(icon) &&
				PositionUtil.displayIcon(code))
			{
				//判断是否需要图标悬浮，而生成不同的图标组件。
				iconLayer =!PositionUtil.suspendIcon(code, iconSuspend)
					? new LogoPlane (config.iconWidth, config.iconHeight) 
					: new LogoSprite(config.iconWidth, config.iconHeight, color);
				addChild(iconLayer).z = thick + 20;
				iconLayer.source = icon;
				iconLayer.visible = true;
				
			}
			if(data.positionType.code == PositionCodeConsts.LIFT || data.positionType.code == PositionCodeConsts.STAIRS || data.positionType.code == PositionCodeConsts.ESCALATOR)
			{
				//判断是否需要图标悬浮，而生成不同的图标组件。
				iconLayer =!PositionUtil.suspendIcon(code, iconSuspend)
					? new LogoPlane (config.iconWidth, config.iconHeight) 
					: new LogoSprite(config.iconWidth, config.iconHeight, color);
				addChild(iconLayer).z = thick + 20;
				iconLayer.source = icon;
				iconLayer.visible = true;
				
			}
		}
		
		/**
		 * @private`
		 */
		private function updateIconLayout():void
		{
			if (iconLayer)
			{
				iconLayer.x = cenX + iconOffsetX;
				iconLayer.y =-cenY - iconOffsetY;
				iconLayer.rotationZ = iconRotation;
				iconLayer.scale = iconScale;
			}
		}
		   
		/**
		 * @private
		 */
		private function updateLabel():void
		{  
			textLayer = Map3DUtil.destroyObject3D(textLayer);
			if (labelVisible && !StringUtil.isEmpty(label) &&
				PositionUtil.displayLabel(code))
			{
				addChild(textLayer = Map3DUtil.getPlaneByText(label, 
					config.font, labelColor)).z = thick + 1;
			}
		}
		
		/**
		 * @private
		 */
		private function updateLabelLayout():void
		{
			if (textLayer)
			{
				textLayer.x = cenX + labelOffsetX;
				textLayer.y =-cenY - labelOffsetY;
				textLayer.rotationZ = labelRotation;
				textLayer.scaleX = textLayer.scaleY = labelScale;
			}
		}
		
		
		/**
		 * @private
		 */
		private function createTimer($handler:Function, $delay:uint):void
		{
			if(!timer)
			{
				timerHandler = $handler;
				timer = new Timer($delay);
				timer.addEventListener(TimerEvent.TIMER, timerHandler);
				timer.start();
			}
		}
		
		/**
		 * @private
		 */
		private function removeTimer():void
		{
			if (timer)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, timerHandler);
				timer = null;
				timerHandler = null;
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get data():VOPosition
		{
			return em::data;
		}
		
		/**
		 * @private
		 */
		public function set data($value:VOPosition):void
		{
			if (data!= $value)
			{
				em::data = $value;
				
				update();
			}
		}
		
		
		/**
		 * 
		 * 选中
		 * 
		 */
		
		public function get selected():Boolean
		{
			return em::selected as Boolean;
		}
		
		/**
		 * @private
		 */
		public function set selected($value:Boolean):void
		{
			if (selected!= $value)
			{
				em::selected = $value;
				Tweener.removeTweens(this);
				Tweener.addTween(this, {z:selected ? selectH : 0, time:1});
			}
		}
		
		
		/**
		 * 
		 * ID
		 * 
		 */
		
		public function get id():String
		{
			return data ? data.id : null;
		}
		
		
		/**
		 * 
		 * 中心X坐标
		 * 
		 */
		
		internal function get cenX():Number
		{
			return (layout ? layout.cenX + data.offsetX : 0);
		}
		
		
		/**
		 * 
		 * 中心Y坐标
		 * 
		 */
		
		internal function get cenY():Number
		{
			return (layout ? layout.cenY + data.offsetY : 0);
		}
		
		
		/**
		 * 
		 * 位置类别代码
		 * 
		 */
		
		internal function get code():String
		{
			return data ? data.typeCode : null;
		}
		
		
		/**
		 * 
		 * 颜色
		 * 
		 */
		
		internal function get color():uint
		{
			return data ? data.color : 0;
		}
		
		
		/**
		 * 
		 * 图标
		 * 
		 */
		
		internal function get icon():String
		{
			if(data.positionType.code == PositionCodeConsts.LIFT || data.positionType.code == PositionCodeConsts.STAIRS || data.positionType.code == PositionCodeConsts.ESCALATOR)
			{
				return data.positionType.icon;
			}
			return data ? data.icon : null;
		}
		
		
		/**
		 * 
		 * 图标是贴紧在顶面，还是悬浮在顶面
		 * 
		 */
		
		internal function get iconSuspend():Boolean
		{
			return data ? data.iconSuspend : true;
		}
		
		
		/**
		 * 
		 * 标签X轴偏移量
		 * 
		 */
		
		internal function get iconOffsetX():Number
		{
			return data ? data.iconOffsetX : 0;
		}
		
		
		/**
		 * 
		 * 标签Y轴偏移量
		 * 
		 */
		
		internal function get iconOffsetY():Number
		{
			return data ? data.iconOffsetY : 0;
		}
		
		
		/**
		 * 
		 * 标签旋转
		 * 
		 */
		
		internal function get iconRotation():Number
		{
			return data ? data.iconRotation : 0;
		}
		
		
		/**
		 * 
		 * 标签缩放
		 * 
		 */
		
		internal function get iconScale():Number
		{
			return (data && data.iconScale) ? data.iconScale : 1;
		}
		
		
		/**
		 * 
		 * 标签缩放
		 * 
		 */
		
		internal function get iconVisible():Boolean
		{
			return data ? data.iconVisible : true;
		}
		
		
		/**
		 * 
		 * 标签
		 * 
		 */
		
		internal function get label():String
		{
			return data ? data.label : null;
		}
		
		
		/**
		 * 
		 * 标签颜色
		 * 
		 */
		
		internal function get labelColor():uint
		{
			return data ? data.labelColor : 0xFFFFFF;
		}
		
		
		/**
		 * 
		 * 标签X轴偏移量
		 * 
		 */
		
		internal function get labelOffsetX():Number
		{
			return data ? data.labelOffsetX : 0;
		}
		
		
		/**
		 * 
		 * 标签Y轴偏移量
		 * 
		 */
		
		internal function get labelOffsetY():Number
		{
			return data ? data.labelOffsetY : 0;
		}
		
		
		/**
		 * 
		 * 标签旋转
		 * 
		 */
		
		internal function get labelRotation():Number
		{
			return data ? data.labelRotation : 0;
		}
		
		
		/**
		 * 
		 * 标签缩放
		 * 
		 */
		
		internal function get labelScale():Number
		{
			return (data && data.labelScale) ? data.labelScale : 1;
		}
		
		
		/**
		 * 
		 * 标签是否可见
		 * 
		 */
		
		internal function get labelVisible():Boolean
		{
			return data ? data.labelVisible : true;
		}
		
		
		/**
		 * 
		 * 位置的厚度。
		 * 
		 */
		
		internal function get thick():Number
		{
			return code == PositionCodeConsts.TERRAIN ? 1 : (data && data.thick > 0 ? data.thick : 
				(   code == PositionCodeConsts.PATIO ? config.thickHollow : config.thickEntity));
		}
		
		
		/**
		 * 
		 * 楼层视图引用
		 * 
		 */
		
		internal function get floor():Floor
		{
			return parent as Floor;
		}
		
		
		/**
		 * 
		 * 布局信息
		 * 
		 */
		
		internal function get layout():Layout
		{
			return data ? data.layout : null;
		}
		
		
		/**
		 * 
		 * 绘制步骤
		 * 
		 */
		
		internal function get steps():Vector.<Step>
		{
			return layout ? layout.steps : null;
		}
		
		
		/**
		 * @private
		 */
		private var config:EMConfig;
		
		/**
		 * @private
		 */
		private var textLayer:Object3D;
		
		/**
		 * @private
		 */
		private var iconLayer:Logo;
		
		/**
		 * @private
		 */
		private var top:Object3D;
		
		/**
		 * @private
		 */
		private var mesh:Mesh;
		
		/**
		 * @private
		 */
		private var timer:Timer;
		
		/**
		 * @private
		 */
		private var timerHandler:Function;
		
		/**
		 * @private
		 */
		private var selectH:Number = 15;
		
		/**
		 * @private
		 */
		private var num:uint = 0;
		
		/**
		 * @private
		 */
		private var vxs:Vector.<Number> = new Vector.<Number>;
		
		/**
		 * @private
		 */
		private var uvs:Vector.<Number> = new Vector.<Number>;
		
		/**
		 * @private
		 */
		private var nms:Vector.<Number> = new Vector.<Number>;
		
		/**
		 * @private
		 */
		private var fci:Vector.<uint>   = new Vector.<uint>;
		
		/**
		 * @private
		 */
		em var data:VOPosition;
		
		/**
		 * @private
		 */
		em var selected:Boolean;
		
		/**
		 * @private
		 */
		em var thick:Number;
		
	}
}