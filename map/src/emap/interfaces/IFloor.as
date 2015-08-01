package emap.interfaces
{
	
	/**
	 * 
	 * 楼层接口。
	 * 
	 */
	
	import emap.vos.VOFloor;
	
	
	public interface IFloor
	{
		
		/**
		 * 
		 * 数据源。
		 * 
		 */
		
		function get data():VOFloor;
		
		/**
		 * @private
		 */
		function set data($value:VOFloor):void;
		
	}
}