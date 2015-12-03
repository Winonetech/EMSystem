package emap.map2d
{
	import cn.vision.collections.Map;
	
	import editor.core.EDConfig;
	
	import emap.core.em;
	import emap.map2d.core.E2Config;
	import emap.map2d.core.E2Provider;
	import emap.map2d.vos.E2VONode;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	public class Node extends Sprite
	{
		public function Node($data:E2VONode,e2Config:E2Config)
		{
			super();
			initialize($data,e2Config);
		}
		public function initialize($data:E2VONode,e2Config:E2Config):void
		{
			config = e2Config;
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
				pointBase = new PointBase(point,5);
				addChild(pointBase);
				this.x = $value.nodeX;
				this.y =$value.nodeY;
			}
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
		}
		protected function clear():void
		{
			while(pointBase) this.removeChild(pointBase);
		}
	
		protected function mouseDownHandler(event:MouseEvent):void
		{
			
			event.stopImmediatePropagation();
			EDConfig.instance.selectedNode = data;
			EDConfig.instance.propertyPanel.setCurrentState("node",true);
			EDConfig.instance.tabBar.selectedItem = EDConfig.instance.nodeNC;
			EDConfig.instance.nodeGroup.addNodeByFloor(EDConfig.instance.selectedFloor);
			
			//点击特效处理
//			if(config.utilLayer.onode==null || config.utilLayer.onode!=this)
//			{
//				config.utilLayer.cleanEffect();
//				selected = true;
//				config.utilLayer.onode = this;
//				
//			}
			nodeSelected();
			
			if(config.subNode) 
			{
				
				
				Alert.show("是否删除该节点?","确认删除",Alert.YES|Alert.NO,null,deleteNode);
				
					return
			}
			stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
		}
		public function deleteNode(event:CloseEvent):void
		{
			if(Alert.YES == event.detail)
			{
				this.parent.removeChild(this); 
				var i:int = E2Provider.instance.nodeArr.indexOf(this.data);
				
				E2Provider.instance.nodeArr.splice(i,1);
				EDConfig.instance.nodeGroup.addNodeByFloor(EDConfig.instance.selectedFloor);
				if(E2Provider.instance.nodeMap.contains(_data))
				{	
					delete E2Provider.instance.nodeMap[_data.id];
					
					//删除路径
					for each(var route:Route in routeMap)
					{
						config.floorViewMap[_data.floorID].subRoute(route);	
						delete config.routeViewMap[route.voRoute.id]
							delete	E2Provider.instance.routeMap[route.voRoute.id]
						
							//在nodegroup里面删除
							EDConfig.instance.routeGroup.addRouteByFloorId(route.voRoute.id);
					}
				}
			}
		}
		//节点被选中 
		public function nodeSelected():void
		{
			//点击特效处理
			if(config.utilLayer.onode==null || config.utilLayer.onode!=this)
			{
				config.utilLayer.cleanEffect();
				selected = true;
				config.utilLayer.onode = this;
				
			}
		}
		protected function mouseMoveHandler(event:MouseEvent):void
		{
			this.x = parent.mouseX;
			this.y = parent.mouseY;
			_data.nodeX = parent.mouseX;
			_data.nodeY = parent.mouseY;
			for each(var route:Route in routeMap)
			{
				route.updateLineTo();
			}
		}
		public function update():void
		{
			this.x = _data.nodeX;
			this.y = _data.nodeY;
			
			for each(var route:Route in routeMap)
			{
				route.updateLineTo();
			}
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
		//当被点击的情况下
		public function set selected($value:Boolean):void
		{
			if(!_selected)
			{
				cPointBase = new PointBase(point,7);
				addChild(cPointBase);
			}
			else if(cPointBase && contains(cPointBase))
			{
				removeChild(cPointBase);
			}
		}
		public function removeClicked():void
		{
			if(cPointBase && contains(cPointBase))
				removeChild(cPointBase);
		}
		private var _selected:Boolean;
		private var __scale:Number;
		public var point:Point;
		public var pointBase:PointBase;
		public var cPointBase:PointBase;
		private var _data:E2VONode;
		public var routeMap:Array=[];
		private var config:E2Config;
	}
}