package emap.map2d
{
	import emap.interfaces.INode;
	import emap.map2d.controls.ImageLayer;
	import emap.map2d.core.E2Config;
	import emap.map2d.core.E2Provider;
	import emap.map2d.vos.E2VOFloor;
	import emap.map2d.vos.E2VOPosition;
	import emap.utils.NodeUtil;
	import emap.vos.VOFloor;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	import mx.controls.Alert;
	
	  
	
	
	[Bindable]
	public final class Floor extends Sprite
	{
		public function Floor($value:E2VOFloor,e2Config:E2Config)
		{
			super();
			initialize($value,e2Config);
		}
		private function initialize($value:E2VOFloor,e2Config:E2Config):void
		{
			config = e2Config;
			dataProvider = $value;
			__scale = 1;
			__labelVisible = __logoVisible = true;
			
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, MapContainer.MAX_W, MapContainer.MAX_H);
			graphics.endFill();
			
	
				floorLayer = new Ground(config,$value);
			
				config.floorViewMap[$value.id] = this;
				config.groundViewMap[$value.id] = floorLayer;
				updataImage();
				addChild(floorLayer);
				floorLayer.alpha = 0.5;
				//imageLayer.visible =false;
				//addChild(imageLayer);
				addChild(positionLayer = new Sprite);
				
				addChild(routeLayer = new Sprite);
				addChild(nodeLayer = new Sprite);
				
				
		}
		/**
		 * 
		 * 增加节点
		 * */
		public function addNewNode($value:Boolean):void
		{
			if($value){
				nodeLayer.addEventListener(MouseEvent.MOUSE_DOWN,nodeLayerMouseDown)
			}
		}
		protected function nodeLayerMouseDown(event:MouseEvent):void
		{
			
		}
		public function addPosition($value:Position):void
		{
			positionLayer.addChild($value);
		}
		public function removePosition($value:Position):void
		{
			positionLayer.removeChild($value);
		}
		//初始化加节点
		public function addNode($value:Node):void
		{
			nodeLayer.addChild($value);
		}
		//删除节点
		public function subNode($value:Node):void
		{
			if(nodeLayer.contains($value))
			{
				nodeLayer.removeChild($value);
			}
	
		}
		public function addRoute($value:Route):void
		{
			routeLayer.addChild($value);
		}
		public function subRoute($value:Route):void
		{
			if(routeLayer.contains($value))
				routeLayer.removeChild($value);
		}
		//增加整个楼层的位置
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
					config.positionViewMap[p.id] = position;
				}
			}
			
		}
		
		private function getRandomNodeID():String
		{
			var time:Date = new Date;
			return NodeUtil.generateSerial();
		}

		public function set childVisible($value:Boolean):void
		{
			nodeLayer.visible = routeLayer.visible = positionLayer.visible = $value;
		}
		override public function get name():String
		{
			return __name;
		}
		override public function set name(value:String):void
		{
			__name = value;
		}
		private var __name:String;
		

		public function get imageVisible():Boolean
		{
			if(imageLayer)
				return imageLayer.visible;
			else return false;
		}
		public function set imageVisible(value:Boolean):void
		{
			if(imageLayer)
			{
				if (value==imageVisible) return;
				imageLayer.visible = value;
			}
		}
		
		public function get groundVisible():Boolean
		{
			return floorLayer.visible;
		}
		public function set groundVisible(value:Boolean):void
		{
			if (value==groundVisible) return;
			floorLayer.visible = value;
		}
		
		public function get logoVisible():Boolean
		{
			return __logoVisible;
		}
		public function set logoVisible(value:Boolean):void
		{
			if (value==logoVisible) return;
			__logoVisible = value;

		}
		private var __logoVisible:Boolean;
		public function get labelVisible():Boolean
		{
			return __labelVisible;
		}
		public function set labelVisible(value:Boolean):void
		{
			if (value==labelVisible) return;
			__labelVisible = value;
//			for each (var place:Place in placesArr) {
//				place.labelVisible = labelVisible;
//			}
		}
		private var __labelVisible:Boolean;
		

		/**
		 * 节点层
		 * 
		 * */
		public function get nodeVisible():Boolean
		{
			return nodeLayer.visible;
		}
		public function set nodeVisible($value:Boolean):void
		{
			if(nodeLayer)
				nodeLayer.visible = $value;
		}
		public function get pointVisible():Boolean
		{
			return pointLayer.visible;
		}
		public function set pointVisible(value:Boolean):void
		{
			pointLayer.visible = value;
		}
		/**
		 * 位置层
		 * */
		public function get positionVisible():Boolean
		{
			return positionLayer.visible;
		}
		public function set positionVisible($value:Boolean):void
		{
			if(positionLayer)
			{
				positionLayer.visible = $value;
			}
		}
		/**
		 * 路径层
		 * */
		public function get routeVisible():Boolean
		{
			return routeLayer.visible;
		}
		public function set routeVisible($value:Boolean):void
		{
			if(routeLayer)
			{
				routeLayer.visible = $value;
			}
		}
		public function get pathVisible():Boolean
		{
			return pathLayer.visible;
		}
		public function set pathVisible(value:Boolean):void
		{
			pathLayer.visible = value;
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
			floorLayer.scale = value;
			
     	}
		private var __scale:Number;
		
		public function get language():String
		{
			return __language;
		}
		public function set language(value:String):void
		{
			__language = value;
//			for each (var place:Place in placesArr) {
//				place.language = language;
//			}
		}
		private var __language:String;
		
		public function get dataProvider():Object
		{
			return __dataProvider;
		}
		//更新图片层
		private function updataImage():void
		{
			var floor:VOFloor = dataProvider as VOFloor;
			if(floor){
				id = floor.id;
				image = floor.image;
				order = floor.order;
				if(image&&image!=""&&image!=" "&&image!="undefined" )
				{
					if(!imageLayer)
					{
						imageLayer = new ImageLayer;
						imageLayer.alpha = 0.5;
						addChildAt(imageLayer,0);
					}
						imageLayer.source = File.applicationDirectory.resolvePath(floor.image).nativePath;
					
				}
			}
		}
		public function changeImage():void
		{
			var floor:VOFloor = dataProvider as VOFloor;
			updataImage();
//			if(imageLayer)
//				imageLayer.source = File.applicationDirectory.resolvePath(floor.image).nativePath;
//			else
//			{
//				imageLayer = new ImageLayer;
//				imageLayer.visible = imageVisible;
//				addChild(imageLayer);
//				imageLayer.source = File.applicationDirectory.resolvePath(floor.image).nativePath;
//			}
		}
		public function set dataProvider(value:Object):void  
		{
			if (value==dataProvider) return;
			__dataProvider = value;
//			imageLayer = new Loader;
//			imageLayer.unloadAndStop();
		
			id = name = image = null;
			order = 0;
			var floor:VOFloor = dataProvider as VOFloor;
			if (floor) {
				id    = floor.id;
				//name  = floor.name;
				image = floor.image;
				order = floor.order;
				
//				if (image&&image!=""&&image!=" "&&image!="undefined") {
//					imageLayer.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, 
//						function(e:IOErrorEvent):void{}, false, 0, true);
//					imageLayer.load(new URLRequest(image));
//				}
				
				
			}
			
			

				
				changing = true;
			}
		
		public var __dataProvider:Object;
		

		internal var pointsNod:Object;
		internal var pointsArr:Array;
		
		internal var nodes:Object;
		
		public var id   :String;
		public var image:String;
		public var order:uint;
		public var changing    :Boolean;
		public var imageLayer  :ImageLayer;
		public var floorLayer  :Ground;
	//	public var placeLayer  :Layer;
		private var pointLayer  :Sprite;
		private var pathLayer   :Sprite;
		private var positionLayer:Sprite;
		public var nodeLayer:Sprite;
		private var routeLayer:Sprite;
		private var config:E2Config;
		
	}
	
}
		
