package emap.interfaces
{
	
	/**
	 * 
	 * 节点接口。
	 * 
	 */
	
	
	import cn.vision.collections.Map;
	
	import emap.vos.VOFloor;
	
	
	public interface INode
	{
		
		/**
		 * 
		 * 序列号，每个位置或节点的序列号都是唯一的
		 * 
		 */
		
		function get serial():String;
		
		
		/**
		 * 
		 * X坐标
		 * 
		 */
		
		function get nodeX():Number;
		
		
		/**
		 * 
		 * Y坐标
		 * 
		 */
		
		function get nodeY():Number;
		
		/**
		 * 
		 * 楼层ID
		 * 
		 */
		
		function get floorID():String;
		
		
		/**
		 * 
		 * 路径集合
		 * 
		 */
		
		function get routes():Map;
		
	}
}