package emap.map3d.vos
{
	
	/**
	 * 
	 * 位置
	 * 
	 */
	
	
	import cn.vision.collections.Map;
	
	import emap.core.em;
	import emap.map3d.interfaces.IE3Node;
	import emap.vos.VOPosition;
	
	
	public final class E3VOPosition extends VOPosition implements IE3Node
	{
		
		/**
		 * 
		 * 构造函数
		 * 
		 */
		
		public function E3VOPosition($data:Object=null)
		{
			super($data);
			
			initialize();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function toString():String
		{
			return serial;
		}
		
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			em::pathes = new Map;
		}
		
		
		/**
		 * 
		 * 临时路径集合
		 * 
		 */
		
		public function get pathes():Map
		{
			return em::pathes;
		}
		
		
		/**
		 * @private
		 */
		em var pathes:Map;
		
	}
}