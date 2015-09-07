package emap.data
{
	
	/**
	 * 
	 * 绘制步骤。
	 * 
	 */
	
	
	import cn.vision.core.VSObject;
	import cn.vision.utils.math.BezierUtil;
	
	import emap.core.em;
	
	import flash.geom.Point;
	
	
	public final class Step extends VSObject
	{
		
		/**
		 * 
		 * 构造函数
		 * 
		 */
		
		public function Step($data:String = null)
		{
			super();
			
			initialize($data);
		}
		
		
		/**
		 * 
		 * 如果是curveTo获取曲线上的点集合。
		 * 
		 */
		
		public function getPoints($start:Point):Vector.<Point>
		{
			if (start != $start)
			{
				if (style == "curveTo" && $start)
				{
					start = $start;
					var l:Number = Point.distance($start, aim) + 
						Point.distance(aim, ctr) + Point.distance($start, ctr);
					var s:Number = 1 / (l * .1);
					points = BezierUtil.getCurvePoints($start, aim, ctr, s);
				}
			}
			return points;
		}
		
		
		/**
		 * 
		 * 转换为字符串。
		 * 
		 */
		
		public function toString():String
		{
			var c:String = style.charAt(0);
			var result:String = c + "|" + aim.x + "-" + aim.y;
			if (c == "c") result += "$" + ctr.x + "-" + ctr.y;
			return result;
		}
		
		
		/**
		 * @private
		 */
		private function initialize($data:String):void
		{
			if ($data)
			{
				var t1:Array, t2:Array, t3:Array, t4:Array, c:String = $data.charAt(0);;
				t1 = $data.split("|");
				if (t1[1])
				{
					em::aim = new Point;
					switch (c)
					{
						case "m":
						case "l":
							var temp:String = (c == "m") ? "moveTo" : "lineTo";
							em::style = temp;
							t2 = t1[1].split("-");
							aim.x = Number(t2[0]);
							aim.y = Number(t2[1]);
							break;
						case "c":
							em::ctr = new Point;
							em::style = "curveTo";
							t2 = t1[1].split("$");
							t3 = t2[0].split("-");
							t4 = t2[1].split("-");
							aim.x = Number(t3[0]);
							aim.y = Number(t3[1]);
							ctr.x = Number(t4[0]);
							ctr.y = Number(t4[1]);
							break;
					}
				}
				
			}
		}
		
		
		/**
		 * 
		 * 类型，moveTo，lineTo，curveTo。
		 * 
		 */
		
		public function get style():String
		{
			return em::style;
		}
		
		
		/**
		 * 
		 * 目标点
		 * 
		 */
		
		public function get aim():Point
		{
			return em::aim;
		}
		
		
		/**
		 * 
		 * 控制点
		 * 
		 */
		
		public function get ctr():Point
		{
			return em::ctr;
		}
		
		
		/**
		 * @private
		 */
		private var start:Point;
		
		/**
		 * @private
		 */
		private var points:Vector.<Point>;
		
		
		/**
		 * @private
		 */
		em var style:String;
		
		/**
		 * @private
		 */
		em var aim:Point;
		
		/**
		 * @private
		 */
		em var ctr:Point;
		
	}
}