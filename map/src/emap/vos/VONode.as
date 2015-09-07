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
		 * 
		 * floorID
		 * 
		 */
		
		public function get floorID():String
		{
			return getProperty("floor_id");
		}
		
		
		/**
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
		 */
		
		em function get floor():VOFloor
		{
			return getRelation(VOFloor, floorID);
		}
		
		
		/**
		 * 
		 * path 集合。
		 * 
		 */
		
		public var pathMap:Map;
		
	}
}