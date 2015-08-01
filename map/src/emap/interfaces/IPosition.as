package emap.interfaces
{
	
	/**
	 * 
	 * 位置接口。
	 * 
	 */
	
	import emap.vos.VOPosition;
	
	
	public interface IPosition
	{
		
		/**
		 * 
		 * 数据源。
		 * 
		 */
		
		function get data():VOPosition;
		
		/**
		 * @private
		 */
		function set data($value:VOPosition):void;
		
	}
}