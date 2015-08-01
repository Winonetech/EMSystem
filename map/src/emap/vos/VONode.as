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
	
	
	public final class VONode extends VO
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function VONode($json:Object = null)
		{
			super($json);
		}
		
		
		/**
		 * 
		 * x
		 * 
		 */
		
		public function get x():Number
		{
			return getProperty("x", Number);
		}
		
		
		/**
		 * 
		 * y
		 * 
		 */
		
		public function get y():Number
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
		 * @private
		 */
		public function set floorID($value:String):void
		{
			setProperty("floor_id", $value);
			clsRelation(VOFloor);
		}
		
		
		/**
		 * 
		 * positionID
		 * 
		 */
		
		public function get positionID():String
		{
			return getProperty("position_id");
		}
		
		/**
		 * @private
		 */
		public function set positionID($value:String):void
		{
			setProperty("position_id", $value);
			clsRelation(VOPosition);
		}
		
		
		/**
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
		 * position
		 * 
		 */
		
		em function get position():VOPosition
		{
			return getRelation(VOPosition, positionID);
		}
		
		
		/**
		 * 
		 * path 集合。
		 * 
		 */
		
		public var pathMap:Map;
		
	}
}