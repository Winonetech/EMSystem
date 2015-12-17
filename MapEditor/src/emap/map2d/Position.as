package emap.map2d
{
	
	/**
	 * 
	 * 位置视图。
	 * 
	 */
	
	import caurina.transitions.Tweener;
	import cn.vision.utils.StringUtil;
	import editor.core.EDConfig;
	import emap.consts.PositionCodeConsts;
	import emap.consts.StepStyleConsts;
	import emap.core.EMConfig;
	import emap.core.em;
	import emap.data.Layout;
	import emap.data.Step;
	import emap.interfaces.INode;
	import emap.interfaces.IPosition;
	import emap.map2d.controls.Logo;
	import emap.map2d.core.E2Config;
	import emap.map2d.core.E2Provider;
	import emap.map2d.tools.Map2DTool;
	import emap.map2d.vos.E2VOPosition;
	import emap.utils.PositionUtil;
	import emap.utils.StepUtil;
	import emap.vos.VOPosition;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.sampler.Sample;
	import flash.text.TextField;
	import flash.utils.Timer;

	public final class Position extends Sprite implements IPosition
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function Position($config:E2Config, $data:VOPosition = null)
		{
			
			super();                            
			
			initialize($config, $data);
		}
		
		
		/**
		 * @private
		 */
		private function initialize($config:E2Config, $data:VOPosition):void
		{
			mouseChildren = false;
			
			config = $config;
			data = $data;
		}
		
		/**
		 * @private
		 */
		public function update():void
		{
			
			if (steps)
			{
				//updateMesh();
				updatePlane();
			}
			
			updateIcon();
			updateIconLayout();
			
			updateLabel();
			updateLabelLayout();
			layout.update();
			
		}
		
		/**
		 * @private
		 */

		/**
		 * @private
		 */
		public function updatePlane():void
		{
			if(data.typeCode == PositionCodeConsts.LIFT || data.typeCode == PositionCodeConsts.ESCALATOR)
			{
				
				graphics.clear();
				graphics.beginFill(color,1);
				graphics.drawCircle(layout.cenX, layout.cenY,50);
				for each(var route:Route in routeMap)
				{
					route.updateLineTo();
					updateIconLayout();
				}
			}
			else
			{
				graphics.clear();
				graphics.beginFill(color);
				StepUtil.drawSteps(graphics, steps);
				for each(var route1:Route in routeMap)
				{
					route1.updateLineTo();
					updateIconLayout();
				}
			}
		}
		public function changePositionType():void
		{
			if(data.typeCode == PositionCodeConsts.LIFT || data.typeCode ==PositionCodeConsts.STAIRS || data.typeCode ==PositionCodeConsts.ESCALATOR )
			{
				if(cPosition && contains(cPosition))
					removeChild(cPosition);
				var step:Step = new Step;
				step.style = StepStyleConsts.MOVE_TO;
				step.aim.x = layout.cenX;
				step.aim.y = layout.cenY;
				steps.length=0;
				steps.push(step);
				update();
				positionSelected();
			}else
			{
				if(cPosition)
					removeChild(cPosition);
				editStep = true;
				EDConfig.instance.e2Config.setEditor = true;
				EDConfig.instance.e2Config.editorStyle = StepStyleConsts.MOVE_TO;
			}
			
		}
		
		/**
		 * @private
		 */
		
		private function updateIcon():void
		{
			if (iconVisible && !StringUtil.isEmpty(icon) &&
				PositionUtil.displayIcon(code))
			{
				if(iconLayer != null)
					this.removeChild(iconLayer);
				iconLayer = new Logo(config.iconWidth, config.iconHeight);
				iconLayer.alpha = 0.7;
				addChild(iconLayer);
				iconLayer.source = File.applicationDirectory.resolvePath(icon).nativePath;
			}
		}
		public function changeIcon():void
		{
			if(iconLayer)
				iconLayer.source =  File.applicationDirectory.resolvePath(icon).nativePath;
			else
			{
				iconLayer = new Logo(config.iconWidth, config.iconHeight);
				iconLayer.alpha = 0.7;
				addChild(iconLayer);
				iconLayer.source =  File.applicationDirectory.resolvePath(icon).nativePath;
				
				updateIconLayout();
			}
		}
		
		
		/**
		 * @private
		 */
		public function updateIconLayout():void
		{
			if (iconLayer)
			{
				iconLayer.x = cenX + iconOffsetX;
				iconLayer.y = cenY + iconOffsetY;
				iconLayer.scaleX = iconLayer.scaleY = iconScale;
				iconLayer.rotation = iconRotation;
				this.numChildren - 1
			}
		}
		/**
		 * 设置iconvisib
		 * */
		public function iconChange($value:Boolean):void
		{
			if(iconLayer)
				iconLayer.visible = $value;
		}
		public function iconScaleChange($value:Number):void
		{
			if(iconLayer)
				iconLayer.scaleX = iconLayer.scaleY = $value;
		}
		/**
		 *设置label visib 
		 */
		public function labelChange($value:Boolean):void
		{
			if(textLayer)
				textLayer.visible = $value;
		}
		/**
		 * 设置label scale
		 */
		  public function labelScaleChange($value:Number):void
		  {
			  if(textLayer)
				  textLayer.scaleX = textLayer.scaleY = $value;
		  }
		/**
		 * @private
		 */
		public function updateLabel():void
		{
			textLayer = destroyObject(textLayer);
			if ( !StringUtil.isEmpty(label) &&
				PositionUtil.displayLabel(code))
			{
				addChild(textLayer = Map2DTool.getText(label, 
					config.font, labelColor));
				if(!labelVisible)
					textLayer.visible = false;
			}
		}
		public static function destroyObject($object:Object):*
		{
			if ($object && $object.parent)
				$object.parent.removeChild($object);
			return null;
		}
		
		/**
		 * @private
		 */
		private function updateLabelLayout():void
		{
			if (textLayer)
			{
				textLayer.x = cenX + labelOffsetX;
				textLayer.y = cenY + labelOffsetY;
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
		 * 交互
		 * 
		 */
		
		public function get interact():*
		{
			return em::interact;
		}
		
		/**
		 * @private
		 */
		public function set interact($value:*):void
		{
			em::interact = $value;
			
			mouseEnabled = useHandCursor = Boolean(interact);
		}
		
		
		/**
		 * 
		 * 交互
		 * 
		 */
		
		/**
		 * @private
		 */
		public function set selected($value:Boolean):void
		{
			if($value)
			{
				if (!selected)
				{
					
					positionSelected();
					//属性面板切换到位置
					EDConfig.instance.propertyPanel.setCurrentState("position",true);
					EDConfig.instance.tabBar.selectedItem = EDConfig.instance.positionNC;
					EDConfig.instance.selectedPosition = data as E2VOPosition;
					EDConfig.instance.propertyPanel.position.position = EDConfig.instance.selectedPosition;
					EDConfig.instance.positionGroup.addPositionByFloor(EDConfig.instance.selectedFloor);
					EDConfig.instance.propertyPanel.position.dataProvider = E2Provider.instance.positionTypeArr;

				}
			}else
			{
				if(cPosition && contains(cPosition))
				{
					removeChild(cPosition);
					
				}
				_selected = false;
			}
		}
		//位置选中 效果
		private function positionSelected():void
		{
				//防止上个楼层还在编辑
				cPosition = new Sprite;
				if(data.typeCode==PositionCodeConsts.ENTITY || data.typeCode==PositionCodeConsts.PATIO || data.typeCode==PositionCodeConsts.TERRAIN || data.typeCode==PositionCodeConsts.UNSEEN){
					
					cPosition.graphics.clear();
					cPosition.graphics.lineStyle(10,0x000000);
					//cPosition.graphics.beginFill(color);
					StepUtil.drawSteps(cPosition.graphics, steps);
					cPosition.graphics.lineStyle(5,0xFFFFFF);
					//cPosition.graphics.beginFill(color);
					StepUtil.drawSteps(cPosition.graphics, steps);
				}else
				{
					cPosition.graphics.clear();
					cPosition.graphics.beginFill(0xFFFFFF,1);
					cPosition.graphics.drawCircle(layout.cenX, layout.cenY,50);
					cPosition.graphics.lineStyle(5,0x000000);
					cPosition.graphics.drawCircle(layout.cenX, layout.cenY,60);
				}
				addChildAt(cPosition,0);
				config.utilLayer.oposition = this;
				_selected = true;
		}
		public function get selected():Boolean
		{
			return _selected;
		}
		/**
		 * 
		 * 清空编辑接口
		 **/
		public function set editStep($value:Boolean):void
		{
			//当重绘传入true 
			if($value)
			{
				steps.length = 0;
				update();
				editFloor= config.floorViewMap[em::data.floorID];
				if(positionEditLayer==null ||!editFloor.contains(positionEditLayer))
				{
					positionEditLayer = new Sprite;
					positionEditLayer.graphics.beginFill(0x00BFFF,0.1);
					positionEditLayer.graphics.drawRect(0,0,5000,5000);
					positionEditLayer.graphics.endFill();
					editFloor.addChild(positionEditLayer);
					positionEditLayer.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown_Handler);
					
				}
			}
			//保存传入值为false
			else
			{
				if(editFloor&&editFloor.contains(positionEditLayer))
				{
					positionEditLayer.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDown_Handler);
					 editFloor.removeChild(positionEditLayer);
				}
				update();
				EDConfig.instance.e2Config.setEditor = false;
			}
		}
		public function mouseDown_Handler(event:MouseEvent):void
		{
			if(event.target is AimPoint  )
			{
				d = event.target.parent as DrawStep;
				positionEditLayer.addEventListener(MouseEvent.MOUSE_MOVE,mouseMove_Handler);
				positionEditLayer.addEventListener(MouseEvent.MOUSE_UP,mouseUp_Handler);
			}
			else
			{
				if(config.editorStyle== StepStyleConsts.MOVE_TO||(steps.length==0))
				{
					if(EDConfig.instance.e2Config.positionViewMap.contains(this))
					{
						var firtStep:Step = new Step;
						var lastStep:Step = new Step;
						firtStep.style = config.editorStyle;
						config.editorStyle = StepStyleConsts.LINE_TO;
						lastStep.style = config.editorStyle;
						lastStep.aim.x=firtStep.aim.x = parent.mouseX;
						lastStep.aim.y=firtStep.aim.y = parent.mouseY;
						steps.push(firtStep);
						steps.push(lastStep);
					}
				}
				
				
				
				else if(config.editorStyle== StepStyleConsts.LINE_TO)
				{ 
					var step:Step = new Step;
					step.style = config.editorStyle;
					step.aim.x = parent.mouseX;
					step.aim.y = parent.mouseY;
					var sStep:Step = steps[steps.length-2];
					steps.splice(steps.length-1,0,step);
				}else if(config.editorStyle== StepStyleConsts.CURVE_TO)
				{
					var step1:Step = new Step;
					step1.style = config.editorStyle;
					step1.aim.x = parent.mouseX;
					step1.aim.y = parent.mouseY;
					var sStep1:Step = steps[steps.length-2];
					step1.ctr.x = (step1.aim.x+sStep1.aim.x)/2;
					step1.ctr.y = (step1.aim.y+sStep1.aim.y)/2;
					steps.splice(steps.length-1,0,step1);
				}
				config.utilLayer.position =this;
				update();
			}
		}
		protected function mouseUp_Handler(event:MouseEvent):void
		{
			positionEditLayer.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMove_Handler);
			positionEditLayer.removeEventListener(MouseEvent.MOUSE_UP,mouseUp_Handler);
			
		}
		
		protected function mouseMove_Handler(event:MouseEvent):void
		{
			
			if(d&&(event.target is PointBase))
			{
				event.stopImmediatePropagation();
				d.update(this.mouseX, this.mouseY,event.target);
				update();
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
			return layout ? layout.cenX : 0;
		}
		
		
		/**
		 * 
		 * 中心Y坐标
		 * 
		 */
		
		internal function get cenY():Number
		{
			return layout ? layout.cenY : 0;
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
		
		public function updata():void
		{
			layout.update();
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
		public function addRoute($value:Route):void
		{
			routeMap.push($value);
		}
		public function removeRoute($value:Route):void
		{
			var i:Number = routeMap.indexOf($value);
			if(i>=0)
			{
				routeMap.splice(i,1);
			}
		}

		public function getRouteMap():Array
		{
			return routeMap;
		}
		
		private var routeMap:Array=[];
		/**
		 * @private
		 */
		private var config:E2Config;
		
		/**
		 * @private
		 */
		private var textLayer:Sprite;
		
		/**
		 * @private
		 */
		private var iconLayer:Logo;
		
		/**
		 * @private
		 */
		private var plane:Sprite;
		
		/**
		 * @private
		 */
		
		
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
		em var data:VOPosition;
		
		/**
		 * @private
		 */
		em var interact:*;
		
		/**
		 * @private
		 */
		em var selected:Boolean;
		
		/**
		 * @private
		 */
		em var thick:Number;
		/**
		 * @private 
		 **/
		private var positionEditLayer:Sprite;
		
		/**
		 * @private 
		 **/
		private var d:DrawStep;
		
		/**
		 * @private 
		 **/
		private var points:Vector.<DrawStep>;
		private var editFloor:Floor;
		private var cPosition:Sprite;
		private var _selected:Boolean;
	}
}