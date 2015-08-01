package emap.interfaces
{
	
	/**
	 * 
	 * 地形接口。
	 * 
	 */
	
	
	import emap.vos.VOFloor;
	
	
	public interface IGround
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