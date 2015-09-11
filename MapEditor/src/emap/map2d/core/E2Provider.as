


package emap.map2d.core
{
	import cn.vision.collections.Map;
	import cn.vision.errors.SingleTonError;

	public class E2Provider
	{
		public function E2Provider()
		{
			if(!instance)
			{}
			else throw new SingleTonError(this);
		}
		public static var instance:E2Provider = new E2Provider;
		public  var floorMap:Map;
		public var floorArr:Array;
		public  var hallMap:Map;
		public  var nodeMap:Map;
		public var serialMap:Map;
		public var nodeArr:Array;
		public  var positionArr:Array;
		public  var positionTypeMap:Map;
		public var positionTypeArr:Array;
		public  var routeMap:Map;
	}
}
