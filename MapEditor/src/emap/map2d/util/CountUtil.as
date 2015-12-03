package emap.map2d.util
{
	import cn.vision.errors.SingleTonError;
	
	import emap.map2d.Floor;

	public class CountUtil
	{
		public function CountUtil()
		{
			if(!instance)
			{
				
			}
			else throw SingleTonError;
			
		}
		
		//在生成新floor时候拿到 +1
		public function get floorCount():uint
		{
			_floorCount++;
			return _floorCount;
		}
		public function set floorCount($value:uint):void
		{
			if($value>_floorCount)
			{
				_floorCount = $value;
			}
		}
		
		public function get positionCount():uint
		{
			_positionCount++;
			return _positionCount;
		}
		public function set positionCount($value:uint):void
		{
			if($value>_positionCount)
			{
				_positionCount = $value;
			}
		}
		public function get nodeCount():uint
		{
			_nodeCount++;
			return _nodeCount;
		}
		public function set nodeCount($value:uint):void
		{
			if($value>_nodeCount)
			{
				_nodeCount = $value;
			}

		}
		public function get positionTypeCount():uint
		{
			_positionTypeCount++;
			return _positionTypeCount;
		}
		public function set positionTypeCount($value:uint):void
		{
			if($value>_positionTypeCount)
			{
				_positionTypeCount = $value;
			}
			
		}
		public function get routeCount():uint
		{
			_routeCount++;
			return _routeCount;
		}
		public function set routeCount($value:uint):void
		{
			if($value>_routeCount)
			{
				_routeCount = $value;
			}
			
		}
		
		public  static var instance:CountUtil = new CountUtil;
	
		private var _floorCount:uint = 0;
		private var _positionCount:uint = 0;
		private var _nodeCount:uint = 0;
		private var _positionTypeCount:uint = 0;
		private var _routeCount:uint = 0;
	}
}