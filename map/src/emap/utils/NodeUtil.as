package emap.utils
{
	
	/**
	 * 
	 * 节点工具，定义一些常用函数。
	 * 
	 */
	
	
	import cn.vision.core.NoInstance;
	import cn.vision.utils.DateUtil;
	import cn.vision.utils.NetUtil;
	
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	
	
	public final class NodeUtil extends NoInstance
	{
		
		/**
		 * 
		 * 生成唯一序列号
		 * 
		 */
		
		public static function generateSerial():String
		{
			var result:String = "";
			
			result += getRandom(12) + "-";
			
			result += DateUtil.getDateFormat(new Date, true, 2, "", "", "") + "-";
			
			result += getRandom();
			return result;
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
		
	}
}