package emap.map3d.core
{
	
	/**
	 * 
	 * 三维地图配置
	 * 
	 */
	
	
	import emap.core.EMConfig;
	
	
	public final class E3Config extends EMConfig
	{
		
		/**
		 * 
		 * 构造函数
		 * 
		 */
		
		public function E3Config($data:Object = null)
		{
			super($data);
		}
		
		
		/**
		 * 
		 * 楼层间距。
		 * 
		 */
		
		public function get floorSpace():Number
		{
			return getProperty("floorSpace", Number);
		}
		
		/**
		 * @private
		 */
		public function set floorSpace($value:Number):void
		{
			setProperty("floorSpace", Number);
		}
		
		
		/**
		 * 
		 * 初始化位置。
		 * 
		 */
		
		public function get initializePosition():String
		{
			return getProperty("initializePosition");
		}
		
	}
}