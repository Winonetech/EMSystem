package viewer.core
{
	
	import cn.vision.collections.Map;
	import cn.vision.core.VSObject;
	import cn.vision.errors.SingleTonError;
	
	import emap.map3d.core.E3Config;
	
	
	public final class MVConfig extends VSObject
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function MVConfig()
		{
			if(!instance) super();
			else throw new SingleTonError(this);
		}
		
		
		/**
		 * 
		 * 配置。
		 * 
		 */
		
		public var config:E3Config;
		
		
		/**
		 * 
		 * 楼层。
		 * 
		 */
		
		public var floors:Map;
		
		/**
		 *serals 
		 * 
		 * 
		 **/
		public var serials:Map;
		/**
		 * 
		 * 位置。
		 * 
		 */
		
		public var positions:Array;
		
		
		/**
		 * 
		 * 位置类别。
		 * 
		 */
		
		public var positionTypes:Map;
		
		
		/**
		 * 
		 * 节点。
		 * 
		 */
		
		public var nodes:Map;
		
		
		/**
		 * 
		 * 路径。
		 * 
		 */
		
		public var routes:Map;
		
		
		/**
		 * 
		 * 馆。
		 * 
		 */
		
		public var halls:Map;
		
		
		/**
		 * 
		 * 单例引用。
		 * 
		 */
		
		public static const instance:MVConfig = new MVConfig;
		
	}
}