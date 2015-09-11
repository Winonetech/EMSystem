package emap.vos
{
	
	/**
	 * 
	 * 节点。
	 * 
	 */
	
	
	import cn.vision.collections.Map;
	
	import com.winonetech.core.VO;
	
	import emap.core.em;
	import emap.interfaces.INode;
	
	
	public class VONode extends VO implements INode
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function VONode($data:Object = null)
		{
			super($data, "node");
			
			initialize();
		}
		
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			em::routes = new Map;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get serial():String
		{
			return getProperty("serial");
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get nodeX():Number
		{
			return getProperty("x", Number);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get nodeY():Number
		{
			return getProperty("y", Number);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get floorID():String
		{
			return getProperty("floor_id");
		}
		
		
		/**
<<<<<<< HEAD
		 * 
		 * 
		 * 
		 * 
		 * 
		 * 
		 * 
		 * 
		 * 
		 * 
		 * floor
		 * 
=======
		 * @inheritDoc
>>>>>>> develop
		 */
		
		public function get routes():Map
		{
			return em::routes;
		}
		
		
		/**
		 * 
		 * floor
		 * 
		 */
		
		public var floor:VOFloor
		
		
		/**
		 * @private
		 */
		em var routes:Map;
		
	}
}