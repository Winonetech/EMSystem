package emap.vos
{
	
	/**
	 * 
	 * 路径。
	 * 
	 */
	
	
	import com.winonetech.core.VO;
	
	import emap.core.em;
	
	
	public final class VORoute extends VO
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function VORoute($json:Object = null)
		{
			super($json);
		}
		
		
		/**
		 * 
		 * node1ID。
		 * 
		 */
		
		public function get node1ID():String
		{
			return getProperty("node_id_b");
		}
		
		/**
		 * @private
		 */
		public function set node1ID($value:String):void
		{
			setProperty("node_id_b", $value);
			clsRelation(VONode);
		}
		
		
		/**
		 * 
		 * node2ID。
		 * 
		 */
		
		public function get node2ID():String
		{
			return getProperty("node_id_e");
		}
		
		/**
		 * @private
		 */
		public function set node2ID($value:String):void
		{
			setProperty("node_id_e", $value);
			clsRelation(VONode);
		}
		
		
		/**
		 * 
		 * node1。
		 * 
		 */
		
		em function get node1():VONode
		{
			return getRelation(VONode, node1ID);
		}
		
		
		/**
		 * 
		 * node2。
		 * 
		 */
		
		em function get node2():VONode
		{
			return getRelation(VONode, node2ID);
		}
		
	}
}