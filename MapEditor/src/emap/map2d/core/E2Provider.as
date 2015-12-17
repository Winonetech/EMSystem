


package emap.map2d.core
{
	import cn.vision.collections.Map;
	import cn.vision.errors.SingleTonError;
	
	import mx.collections.ArrayCollection;
	
	public class E2Provider
	{
		public function E2Provider()
		{
			if(!instance)
			{
				
			}
			else throw new SingleTonError(this);
		}
		public static var instance:E2Provider = new E2Provider;
		public  var floorMap:Map = new Map;
		public var floorArr:Array = new Array;
		//这个楼层数组是为了其他类似路径对楼层数组操作 又不影响正常的数据
		public var floorArrC:Array = new Array;
		public  var hallMap:Map = new Map;
		public  var nodeMap:Map = new Map ;
		public var serialMap:Map = new Map;
		public var nodeArr:Array = new Array;
		public  var positionArr:Array = new Array;
		public  var positionTypeMap:Map = new Map;
		public var positionTypeArr:Array = new Array;
		public  var routeMap:Map = new Map;
		public var imageMap:Map = new Map;
		[Bindable]
		public var positionCode:ArrayCollection =new ArrayCollection(["entity","hollow","terrain","unseen","lift","stairs","escalator"]);
	}
}
