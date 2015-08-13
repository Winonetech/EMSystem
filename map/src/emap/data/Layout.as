package emap.data
{
	
	/**
	 * 
	 * 布局信息。
	 * 
	 */
	
	
	import cn.vision.core.VSObject;
	
	import emap.consts.StepStyleConsts;
	import emap.core.em;
	
	import flash.geom.Point;
	
	
	public final class Layout extends VSObject
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function Layout($data:String = null)
		{
			super();
			
			initialize($data);
		}
		
		
		/**
		 * 
		 * 解析数据。
		 * 
		 */
		
		public function resolve($data:String):void
		{
			if ($data)
			{
				var temp:Array = $data.split(",");
				var resl:Vector.<Step>  = new Vector.<Step>;
				var repl:Vector.<Point> = new Vector.<Point>;
				var last:Step, step:Step;
				var xvec:Array = [], yvec:Array = [];
				var sumX:Number = 0, sumY:Number = 0, count:uint = 0;
				var addo:Function = function($point:Point, $index:uint = 0, $array:Vector.<Point> = null):void
				{
					count++;
					sumX += $point.x;
					sumY += $point.y;
					xvec[xvec.length] = $point.x;
					yvec[yvec.length] = $point.y;
					repl[repl.length] = $point;
				}
				for each(var item:String in temp)
				{
					step = new Step(item);
					switch (step.style)
					{
						case StepStyleConsts.LINE_TO:
							addo(step.aim);
							break;
						case StepStyleConsts.CURVE_TO:
							if (last) 
							{
								var cache:Vector.<Point> = step.getPoints(last.aim);
								cache.forEach(addo);
								var end:Point = cache[cache.length - 1];
								if (end.x != step.aim.x || end.y != step.aim.y) addo(step.aim);
							}
							break;
					}
					resl[resl.length] = step;
					last = step;
				}
				
				em::minX = Math.min.apply(null, xvec);
				em::maxX = Math.max.apply(null, xvec);
				em::minY = Math.min.apply(null, yvec);
				em::maxY = Math.max.apply(null, yvec);
				
				em::cenX = .5 *(.5 * (minX + maxX) + sumX / count);
				em::cenY = .5 *(.5 * (minY + maxY) + sumY / count);
				
				em::width  = maxX - minX;
				em::height = maxY - minY;
				
				em::steps = resl;
				em::points = repl;
			}
		}
		
		
		/**
		 * 
		 * 构建步骤数据。
		 * 
		 */
		
		public function build():String
		{
			return steps.join(",");
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function toString():String
		{
			return "[Layout:{cenX:" +
				cenX + ",cenY:" +
				cenY + ",minX:" +
				minX + ",minY:" +
				minY + ",maxX:" +
				maxX + ",maxY:" +
				maxY + ",width:" +
				width + ",height:" +
				height + "}]";
		}
		
		
		/**
		 * @private
		 */
		private function initialize($data:String):void
		{
			resolve($data);
		}
		
		
		/**
		 * 
		 * 中央X。
		 * 
		 */
		
		public function get cenX():Number
		{
			return em::cenX;
		}
		
		
		/**
		 * 
		 * 中央Y。
		 * 
		 */
		
		public function get cenY():Number
		{
			return em::cenY;
		}
		
		
		/**
		 * 
		 * 最小值X。
		 * 
		 */
		
		public function get minX():Number
		{
			return em::minX;
		}
		
		
		/**
		 * 
		 * 最小值Y。
		 * 
		 */
		
		public function get minY():Number
		{
			return em::minY;
		}
		
		
		/**
		 * 
		 * 最大值X。
		 * 
		 */
		
		public function get maxX():Number
		{
			return em::maxX;
		}
		
		
		/**
		 * 
		 * 最大值Y。
		 * 
		 */
		
		public function get maxY():Number
		{
			return em::maxY;
		}
		
		
		/**
		 * 
		 * 宽度。
		 * 
		 */
		
		public function get width():Number
		{
			return em::width;
		}
		
		
		/**
		 * 
		 * 高度。
		 * 
		 */
		
		public function get height():Number
		{
			return em::height;
		}
		
		
		/**
		 * 
		 * 步骤集合。
		 * 
		 */
		
		public function get steps():Vector.<Step>
		{
			return em::steps;
		}
		
		
		
		/**
		 * @private
		 */
		em var cenX:Number;
		
		/**
		 * @private
		 */
		em var cenY:Number;
		
		/**
		 * @private
		 */
		em var minX:Number;
		
		/**
		 * @private
		 */
		em var minY:Number;
		
		/**
		 * @private
		 */
		em var maxX:Number;
		
		/**
		 * @private
		 */
		em var maxY:Number;
		
		/**
		 * @private
		 */
		em var width:Number;
		
		/**
		 * @private
		 */
		em var height:Number;
		
		/**
		 * @private
		 */
		em var steps:Vector.<Step>;
		
		/**
		 * @private
		 */
		em var points:Vector.<Point>;
		
	}
}