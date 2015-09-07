package emap.utils
{
	
	/**
	 * 
	 * 节点工具，定义一些常用函数。
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	import cn.vision.utils.DateUtil;
	
	import emap.consts.PositionCodeConsts;
	import emap.interfaces.INode;
	import emap.vos.VOPosition;
	
	import flash.geom.Point;
	
	
	public final class NodeUtil extends NoInstance 
	{
		
		/**
		 * 
		 * 获取两个节点的距离，如果是二次贝塞尔曲线，则包含控制点；只从坐标运算，不考虑跨层的情况。
		 * 
		 * @param $node1:INode 节点1。
		 * @param:$node2:INode 节点2。
		 * 
		 */
		
		public static function distance($node1:INode, $node2:INode):Number
		{
			if ($node1.floorID == $node2.floorID)
			{
				var p1:Point = new Point($node1.nodeX, $node1.nodeY);
				var p2:Point = new Point($node2.nodeX, $node2.nodeY);
				var result:Number = Point.distance(p1, p2);
			}
			else
			{
				if ($node1 is VOPosition && $node2 is VOPosition)
				{
					var v1:VOPosition = $node1 as VOPosition;
					var v2:VOPosition = $node2 as VOPosition;
					if (v1.typeCode == v2.typeCode) result = CODES[v1.typeCode];
				}
			}
			return result;
		}
		
		
		/**
		 * 
		 * 生成唯一序列号。
		 * 
		 * @return String 序列号。
		 * 
		 */
		
		public static function generateSerial():String
		{
			return getRandom(12) + "-" + 
				DateUtil.getDateFormat(new Date, true, 2, "", "", "") + "-" + getRandom();
		}
		
		
		/**
		 * 
		 * 验证是否为关键节点。
		 * 
		 */
		
		public static function validateKeyNode($node:INode):Boolean
		{
			if ($node is VOPosition)
			{
				var position:VOPosition = $node as VOPosition;
				return(position.typeCode == PositionCodeConsts.ESCALATOR || 
						position.typeCode == PositionCodeConsts.LIFT || 
						position.typeCode == PositionCodeConsts.STAIRS);
			}
			return false;
		}
		
		
		/**
		 * @private
		 */
		private static function getRandom($length:uint = 8):String
		{
			var tm:Array = CHARS.concat();
			tm.sort(function(a:String, b:String):Number
			{
				return Math.random() - .5;
			});
			tm.length = 8;
			return tm.join("");
		}
		
		
		/**
		 * @private
		 */
		private static const CHARS:Array = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
		
		/**
		 * @private
		 */
		private static const CODES:Object = {lift:15, escalator:10, stairs:15};
		
	}
}