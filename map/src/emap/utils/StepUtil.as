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
	import flash.geom.Vector3D;
	
	
	public class StepUtil extends NoInstance
	{
		
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
		 * 
		 */
		
		public static function drawSteps($graphics:Graphics, $steps:Vector.<Step>):void
		{
			if ($graphics && $steps && $steps.length > 2)
				for each (var step:Step in $steps) drawStep($graphics, step);
		}
		
		
		/**
		 * 
		 * 绘制一个步骤。
		 * 
		 */
		
		private static function drawStep($graphics:Graphics, $step:Step):void
		{
			if ($step)
			{
				switch ($step.style)
				{
					case "moveTo":
						$graphics.moveTo($step.aim.x, $step.aim.y);
						break;
					case "lineTo":
						$graphics.lineTo($step.aim.x, $step.aim.y);
						break;
					case "curveTo":
						$graphics.curveTo($step.ctr.x, $step.ctr.y, $step.aim.x, $step.aim.y);
						break;
				}
			}
		}
		
	}
}