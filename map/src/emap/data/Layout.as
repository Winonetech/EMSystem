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
	import emap.utils.StepUtil;
	
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
		 * 更新Layout。
		 * 
		 */
		
		public function update():void
		{
			var temp:Vector.<Step> = em::steps;
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
			};
			
			if (temp.length < 2)
			{
				addo(temp.length > 0 ? temp[0].aim: new Point);
			}
			else
			{
				for each(step in temp)
				{
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
					last = step;
				}
			}
			
			//删除重复的点
			if (repl.length >= 2)
			{
				var i:uint = 1;
				while (i < repl.length)
				{
					var lst:Point = repl[i - 1];
					var cur:Point = repl[i];
					if(int(lst.x) == int(cur.x) && int(lst.y) == int(cur.y)) repl.splice(i, 1);
					else i++;
				}
			}
			
			em::minX = Math.min.apply(null, xvec);
			em::maxX = Math.max.apply(null, xvec);
			em::minY = Math.min.apply(null, yvec);
			em::maxY = Math.max.apply(null, yvec);
			
			em::cenX = .5 *(.5 * (minX + maxX) + sumX / count);
			em::cenY = .5 *(.5 * (minY + maxY) + sumY / count);
			
			em::width  = maxX - minX;
			em::height = maxY - minY;
			
			em::points = repl;
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
				em::steps = StepUtil.resolveSteps($data);
				
				update();
			}
			else
			{
				em::steps = new Vector.<Step>
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
		em var cenX:Number = 0;
		
		/**
		 * @private
		 */
		em var cenY:Number = 0;
		
		/**
		 * @private
		 */
		em var minX:Number = 0;
		
		/**
		 * @private
		 */
		em var minY:Number = 0;
		
		/**
		 * @private
		 */
		em var maxX:Number = 0;
		
		/**
		 * @private
		 */
		em var maxY:Number = 0;
		
		/**
		 * @private
		 */
		em var width:Number = 0;
		
		/**
		 * @private
		 */
		em var height:Number = 0;
		
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