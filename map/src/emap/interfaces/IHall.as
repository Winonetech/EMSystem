package emap.interfaces
{
	
	/**
	 * 
	 * 馆接口。
	 * 
	 */
	
	import emap.vos.VOHall;
	
	
	public interface IHall
	{
		
		/**
		 * 
		 * 数据源。
		 * 
		 */
		
		function get data():VOHall;
		
		/**
		 * @private
		 */
		function set data($value:VOHall):void;
		
	}
}