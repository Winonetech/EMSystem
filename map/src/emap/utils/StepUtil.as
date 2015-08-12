package emap.utils
{
	
	/**
	 * 
	 * 形状绘制步骤。
	 * 
	 */
	
	
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.primitives.Plane;
	
	import cn.vision.core.NoInstance;
	
	import emap.consts.PositionCodeConsts;
	import emap.data.Step;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	
	public class StepUtil extends NoInstance
	{
		
		/**
		 * 
		 * 获取二次贝塞尔曲线上的点
		 * 
		 * @param $start:Point 起始点
		 * @param $end:Point 结束点
		 * @param $ctrl:Point 控制点
		 * @param $seg:Number 分段
		 * @param $begin:Boolean (default = false) 是否包含起始点
		 * 
		 */
		
		public static function getCurvePoints($start:Point, $end:Point, $ctrl:Point, $seg:Number = .1, $begin:Boolean = false):Vector.<Point>
		{
			if ($start && $end && $ctrl)
			{
				var result:Vector.<Point> = new Vector.<Point>;
				for (var t:Number = $seg; t <= 1; t += $seg)
				{
					//二次Bz曲线的公式
					var x:Number = (1 - t) * (1 - t) * $start.x + 2 * t * (1 - t) * $ctrl.x + t * t * $end.x;
					var y:Number = (1 - t) * (1 - t) * $start.y + 2 * t * (1 - t) * $ctrl.y + t * t * $end.y;              
					result[result.length] = new Point(x, y);
				}
			}
			return result;
		}
		
		
		/**
		 * 
		 * 生成步骤队列。
		 * 
		 * @param $data:String 需要解析的坐标数据。
		 * 
		 * @return Vector.<Step> 步骤队列。
		 * 
		 */
		
		public static function resolveSteps($data:String):Vector.<Step>
		{
			var temp:Array = $data.split(",");
			var result:Vector.<Step> = new Vector.<Step>;
			for each(var item:String in temp)
				result[result.length] = new Step(item);
			return result;
		}
		
		
		/**
		 * 
		 * 平面绘制一系列步骤，在调用该步骤之前，必须先对Graphics对象进行beginFill()操作。
		 * 
		 * @param $graphics:Graphics 绘制对象。
		 * @param $steps:Vector.<Step> 绘制的步骤队列。
		 * @param $3d:Boolean (default = false) 在A3D坐标系模式下Y轴刚好相反。
		 * 
		 */
		
		public static function drawSteps($graphics:Graphics, $steps:Vector.<Step>, $3d:Boolean = false):void
		{
			var n:int =  $3d ? -1 : 1;
			if ($graphics && $steps && $steps.length > 2)
				for each (var step:Step in $steps) drawStep($graphics, step, n);
		}
		
		
		/**
		 * 绘制一个步骤。
		 * @private
		 */
		
		private static function drawStep($graphics:Graphics, $step:Step, n:int):void
		{
			if ($step)
			{
				switch ($step.style)
				{
					case "moveTo":
						$graphics.moveTo($step.aim.x, $step.aim.y * n);
						break;
					case "lineTo":
						$graphics.lineTo($step.aim.x, $step.aim.y * n);
						break;
					case "curveTo":
						$graphics.curveTo($step.ctr.x, $step.ctr.y * n, $step.aim.x, $step.aim.y * n);
						break;
				}
			}
		}
		
	}
}