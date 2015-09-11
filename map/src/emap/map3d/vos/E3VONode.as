package emap.map3d.vos
{
	
	/**
	 * 
	 * 节点
	 * 
	 */
	
	
	import cn.vision.collections.Map;
	
	import emap.core.em;
	import emap.map3d.interfaces.IE3Node;
	import emap.vos.VONode;
	
	import flash.geom.Point;
	
	
	public final class E3VONode extends VONode implements IE3Node
	{
		
		/**
		 * 
		 * 构造函数
		 * 
		 */
		
		public function E3VONode($data:Object = null)
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
		 * @inheritDoc
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