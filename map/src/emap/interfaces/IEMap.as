package emap.interfaces
{
	
	/**
	 * 
	 * 电子地图接口。
	 * 
	 */
	
	
	import cn.vision.collections.Map;
	
	import emap.vos.VOPosition;
	
	
	public interface IEMap
	{
		
		/**
		 * 
		 * 清空所有视图数据
		 * 
		 */
		
		function clear():void;
		
		
		/**
		 * 
		 * 查看位置
		 * 
		 * @param $data:* 可以传入Position，Position的id
		 * @param $tween:Boolean 是否开启缓动过程
		 * 
		 */
		
		function viewPosition($data:*, $tween:Boolean = false):void;
		
		
		/**
		 * 
		 * 查看楼层
		 * 
		 * @param $data:* 可传入Floor，Floor的id或order
		 * @param $tween:Boolean 是否开启缓动过程
		 * 
		 */
		
		function viewFloor($data:*, $tween:Boolean = false):void;
		
		
		/**
		 * 
		 * 设定字体。
		 * 
		 */
		
		function set font($value:String):void;
		
		
		/**
		 * 
		 * 是否启用馆。
		 * 
		 */
		
		function get hallEnabled():Boolean;
		
		/**
		 * @private
		 */
		function set hallEnabled($value:Boolean):void;
		
		
		/**
		 * 
		 * 楼层数据。
		 * 
		 */
		
		function set floors($data:Map):void;
		
		
		/**
		 * 
		 * 馆数据。
		 * 
		 */
		
		function set halls($data:Map):void;
		
		
		/**
		 * 
		 * 位置数据。
		 * 
		 */
		
		function set positions($data:Array):void;
		
		
		/**
		 * 
		 * 位置类型数据。
		 * 
		 */
		
		function set positionTypes($data:Map):void;
		
		
		/**
		 * 
		 * 节点数据。
		 * 
		 */
		
		function set nodes($data:Map):void;
		
		
		/**
		 * 
		 * 路径数据。
		 * 
		 */
		
		function set routes($data:Map):void;
		
	}
}