package emap.map2d
{
	import emap.map2d.core.E2Config;
	
	import emap.interfaces.INode;
	import emap.map2d.core.E2Provider;
	import emap.map2d.vos.E2VOFloor;
	import emap.map2d.vos.E2VOPosition;
	import emap.utils.NodeUtil;
	import emap.vos.VOFloor;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	  
	
	
	[Bindable]
	public final class Floor extends Sprite
	{
		public function Floor($value:E2VOFloor)
		{
			super();
			initialize($value);
		}
		private function initialize($value:E2VOFloor):void
		{
			//config = mapConfig;
			
			__scale = 1;
			__labelVisible = __logoVisible = true;
			
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, MapContainer.MAX_W, MapContainer.MAX_H);
			graphics.endFill();
			
			//addChild(imageLayer = new Loader);
		//	for each(var voFloor:E2VOFloor in E2Provider.instance.floorMap){
				floorLayer = new Ground($value);
				//floorLayer.visible = false;
				E2Config.instance.floorViewMap[$value.id] = this;
				E2Config.instance.groundViewMap[$value.id] = floorLayer;
				addChild(floorLayer);
				//addPositionByFloor($value);
				
			//}
//			addChild(placeLayer = new Layer );
//			addChild(pathLayer  = new Sprite);
//			addChild(pointLayer = new Sprite);
			
			//floorLayer.data= dataProvider;
			
			//nodes = {};
			
		//	addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
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
					E2Config.instance.positionMap[p.id] = position;
					trace(p.floorID,position.id);
				}
			}
			
		}
		
		private function getRandomNodeID():String
		{
			var time:Date = new Date;
			return NodeUtil.generateSerial();
		}
		//判断两个点之间是否有路径
//		private function existPath(node1:INode, node2:INode):Boolean
//		{
//			for each (var item:Path in node1.pathes) {
//				if (item.point1==node2||item.point2==node2) {
//					return true;
//				}
//			}
//			return false;
//		}
		
//		protected function mouseDownHandler(event:MouseEvent):void
//		{
//			if (config.editType=="non"||config.editState=="non") {
//				
//			} else {
//				if (config.editType=="place") {
//					if (config.editState=="add"&&placeVisible) {
//						event.stopImmediatePropagation();
//						if(!placesArr) {
//							placesArr = [];
//						}
//						if(!placesNod) {
//							placesNod = {};
//						}
//						
//						var place:Place = new Place(config);
//						config.place = place;
//						//---------------------------------------
//						placeLayer.addPlace(place);
//						//---------------------------------------
//						place.id     = "";
//						place.nodeID = getRandomNodeID();
//						place.floor  = this;
//						place.order  = placesArr.length;
//						place.scale  = scale;
//						//---------------------------------------
//						place.label  = "place"+placeLayer.numPlaces;
//						//---------------------------------------
//						place.editable = true;
//						place.editArea = true;
//						
//						placesArr.push(place);
//						placesNod[place.nodeID] = place;
//						
//						config.provider.addedPlaces[place.nodeID] = place.dataProvider;
//						
//						place.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
//					} else {
//						if (event.target is Place) {
//							place = event.target as Place;
//							config.editor.editor.showTip(
//								"确定删除？", 
//								"Notice:", 
//								true, 
//								function():void{
//									config.place = null;
//									config.component = null;
//									placesArr.splice(placesArr.indexOf(place), 1);
//									delete placesNod[place.nodeID];
//									//---------------------------------------
//									placeLayer.removePlace(place);
//									//---------------------------------------
//									if (config.provider.addedPlaces[place.nodeID]) {
//										delete config.provider.addedPlaces[place.nodeID];
//									} else {
//										config.provider.deledPlaces[place.nodeID] = place.dataProvider;
//									}
//								}
//							);
//						}
//					}
//				} else if (config.editType=="point") {
//					if (config.editState=="add"&&pointVisible) {
//						event.stopImmediatePropagation();
//						if(!pointsArr) {
//							pointsArr = [];
//						}
//						if(!pointsNod) {
//							pointsNod = {};
//						}
//						
//						var point:PointPath = new PointPath(config);
//						config.pointPath = point;
//						pointLayer.addChild(point);
//						
//						point.nodeID = getRandomNodeID();
//						point.floor = this;
//						point.moveX = mouseX;
//						point.moveY = mouseY;
//						point.scale = scale;
//						//point.label = "node"+pointLayer.numChildren;
//						
//						pointsArr.push(point);
//						pointsNod[point.nodeID] = point;
//						
//						config.provider.addedPoints[point.nodeID] = point.dataProvider;
//						
//						point.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
//					} else {
//						if (event.target is PointPath) {
//							point = event.target as PointPath;
//							config.editor.editor.showTip(
//								"确定删除？", 
//								"Notice:", 
//								true, 
//								function():void{
//									for each (var path:Path in point.pathes) {
//										path.destroy();
//										if (config.provider.addedPathes[path.id]) {
//											delete config.provider.addedPathes[path.id];
//										} else {
//											config.provider.deledPathes[path.id] = path.dataProvider;
//										}
//									}
//									config.pointPath = null;
//									pointsArr.splice(pointsArr.indexOf(point), 1);
//									delete pointsNod[point.nodeID];
//									pointLayer.removeChild(point);
//									if (config.provider.addedPoints[point.nodeID]) {
//										delete config.provider.addedPoints[point.nodeID];
//									} else {
//										config.provider.deledPoints[point.nodeID] = point.dataProvider;
//									}
//									
//								}
//							);
//						}
//					}
//				} else {
//					if (config.editState=="add"&&pathVisible) {
//						if (event.target is INode) {
//							if (config.node) {
//								var node1:INode,node2:INode;
//								node1 = config.node;
//								if (event.target is INode) node2 = event.target as INode;
//								if (node1&&node2&&node1!=node2&&!existPath(node1, node2)) {
//									var path:Path = new Path(config, node1, node2);
//									pathLayer.addChild(path);
//									config.place = null;
//									config.pointPath = null;
//									config.path = path;
//									config.provider.addedPathes[path.id] = path.dataProvider;
//								}
//								config.node = null;
//							} else {
//								config.node = event.target as INode;
//							}
//						}
//					} else {
//						if (event.target is Path) {
//							path = event.target as Path;
//							config.editor.editor.showTip(
//								"确定删除？", 
//								"Notice:", 
//								true, 
//								function():void{
//									path.destroy();
//									if (config.provider.addedPathes[path.id]) {
//										delete config.provider.addedPathes[path.id];
//									} else {
//										config.provider.deledPathes[path.id] = path.dataProvider;
//									}
//								}
//							);
//						}
//					}
//				}
//				
//			}
//		}
		
		override public function get name():String
		{
			return __name;
		}
		override public function set name(value:String):void
		{
			__name = value;
		}
		private var __name:String;
		
//		public function get color():uint
//		{
//			return floorLayer.color;
//		}
//		public function set color(value:uint):void
//		{
//			if (value==color) return;
//			floorLayer.color = value;
//			if (changing) {
//				//data.color = color;
//			//	data.changed = true;
//			}
//		}
		
//		public function get area():String
//		{
//			return floorLayer.area;
//		}
//		public function set area(value:String):void
//		{
//			floorLayer.area = value;
//			if (changing) {
////				data.area = area;
////				data.changed = true;
//			}
//		}
		
//		public function get editable():Boolean
//		{
//			return floorLayer.editable;
//		}
//		public function set editable(value:Boolean):void
//		{
//			floorLayer.editable = value;
//			placeVisible = pointVisible = pathVisible =!editable;
//			if(!editable) {
//				if (editArea) {
//					editArea = false;
//				}
//			} else {
//				groundVisible = editable;
//			}
//			
//		}
		
//		public function get editArea():Boolean
//		{
//			return floorLayer.editArea;
//		}
//		public function set editArea(value:Boolean):void
//		{
//			floorLayer.editArea = value;
//			if (changing) {
//				//data.changed = true;
//			}
//		}
		
		public function get imageVisible():Boolean
		{
			return imageLayer.visible;
		}
		public function set imageVisible(value:Boolean):void
		{
			if (value==imageVisible) return;
			imageLayer.visible = value;
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
//			for each (var place:Place in placesArr) {
//				place.logoVisible = logoVisible;
//			}
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
		
//		public function get placeVisible():Boolean
//		{
//			return placeLayer.visible;
//		}
		
		
		public function get pointVisible():Boolean
		{
			return pointLayer.visible;
		}
		public function set pointVisible(value:Boolean):void
		{
			pointLayer.visible = value;
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
		public function set dataProvider(value:Object):void  
		{
			if (value==dataProvider) return;
			__dataProvider = value;
			
			imageLayer.unloadAndStop();
		//	floorLayer.dataProvider = null;
			//---------------------------------------
		//	placeLayer.removeAllPlace();
			//---------------------------------------
			while(pointLayer.numChildren) pointLayer.removeChildAt(0);
			//placesNod = pointsNod = placesArr = pointsArr = null;
			id = name = image = null;
			order = 0;
			
			var floor:VOFloor = dataProvider as VOFloor;
			if (floor) {
				id    = floor.id;
				//name  = floor.name;
				image = floor.image;
				order = floor.order;
				
				if (image&&image!=""&&image!=" "&&image!="undefined") {
					imageLayer.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, 
						function(e:IOErrorEvent):void{}, false, 0, true);
					imageLayer.load(new URLRequest(image));
				}
				
				//floorLayer.dataProvider = floor;
				
			//	var placesList:Array = floor.places;
//				if (placesList) {
//					var placesLength:uint = placesList.length;
//					if (placesLength) {
//						placesArr = [];
//						placesNod = {};
//					}
//					for(var j:uint=0; j<placesLength; j++) {
//						var place:Place = new Place(config);
//						placeLayer.addPlace(place);
//						place.floor    = this;
//						place.scale    = scale;
//						place.language = language;
//						place.logoVisible  = logoVisible;
//						place.labelVisible = labelVisible;
//						place.dataProvider = placesList[j];
//						
//						placesNod[place.nodeID] = placesArr[j] = place;
//						nodes[place.nodeID] = place;
//					}
				}
				
//				var pointsList:Array = floor.date;
//				if (pointsList) {
//					var pointsLength:uint = pointsList.length;
//					if (pointsLength) {
//						pointsArr = [];
//						pointsNod = {};
//					}
//					for(j=0; j<pointsLength; j++) {
//						var point:PointPath = new PointPath(config);
//						point.floor = this;
//						point.scale = scale;
//						point.dataProvider = pointsList[j];
//						pointLayer.addChild(point);
//						pointsNod[point.nodeID] = pointsArr[j] = point;
//						nodes[point.nodeID] = point;
//					}
//				}
//				var pathesList:Array = floor.pathes;
//				if (pathesList) {
//					var pathesLength:uint = pathesList.length;
//					if (pathesLength) {
//						for(j=0; j<pathesLength; j++) {
//							var data:DataPath = pathesList[j];
//							var path:Path = new Path(config, nodes[data.node1ID], nodes[data.node2ID]);
//							path.id = data.id;
//							pathLayer.addChild(path);
//						}
//					}
//				}
				
				changing = true;
			}
		
		public var __dataProvider:Object;
		
//		public function get data():VOFloor
//		{  
//		//	return dataProvider as VOFloor;
//		}
		
	//	public var config:MapConfig;
		//public var hall  :Hall;
	//	import emap.map2d.Layer;
	import emap.map2d.Ground;
	
	import flash.display.Loader;
	import flash.display.Sprite
//		internal var placesNod:Object;
//		internal var placesArr:Array;
		internal var pointsNod:Object;
		internal var pointsArr:Array;
		
		internal var nodes:Object;
		
		public var id   :String;
		public var image:String;
		public var order:uint;
		public var changing    :Boolean;
		public var imageLayer  :Loader;
		public var floorLayer  :Ground;
	//	public var placeLayer  :Layer;
		public var pointLayer  :Sprite;
		public var pathLayer   :Sprite;
		
	}
	
}
		
