package emap.map3d.tools
{
	
	/**
	 * 
	 * 资源管理。
	 * 
	 */
	
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.resources.BitmapTextureResource;
	
	import cn.vision.core.NoInstance;
	
	import emap.map3d.comman.ColorStandardMaterial;
	
	import flash.display.BitmapData;
	import flash.display.Stage3D;
	import flash.events.Event;
	import flash.text.TextFormat;
	
	
	public final class SourceEmap3D extends NoInstance
	{
		
		
		/**
		 * 
		 * 注册stage3D，为上传资源使用。
		 * 
		 */
		
		public static function initializeStage($stage:Stage3D):void
		{
			if ($stage)
			{
				stage = $stage;
				if (stage.context3D) 
				{
					while (sources.length) sources.pop().upload(stage.context3D);
				}
				else
				{
					var handlerContext3DCreate:Function = function($e:Event):void
					{
						stage.removeEventListener(Event.CONTEXT3D_CREATE, handlerContext3DCreate);
						
						while (sources.length) sources.pop().upload(stage.context3D);
					};
					stage.addEventListener(Event.CONTEXT3D_CREATE, handlerContext3DCreate);
				}
			}
		}
		
		
		/**
		 * 
		 * 上传资源至stage3D环境。
		 * 
		 */
		
		public static function uploadSource($source:Resource):void
		{
			if ($source)
			{
				if (stage && stage.context3D)
					$source.upload(stage.context3D);
				else
					sources[sources.length] = $source;
			}
		}
		
		
		/**
		 * 
		 * 上传root Object3D中的资源至stage3D环境。
		 * 
		 */
		
		public static function uploadAllSources($root:Object3D):void
		{
			if (stage && $root)
			{
				var sources:Vector.<Resource> = $root.getResources(true);
				for each (var source:Resource in sources)
					SourceEmap3D.uploadSource(source);
			}
		}
		
		
		/**
		 * 
		 * 返回一个可重复使用的ColorStandardMaterial。
		 * 
		 */
		
		public static function getColorMaterial($value:uint):ColorStandardMaterial
		{
			if(!COLOR_MATERIALS[$value])
			{
				COLOR_MATERIALS[$value] = new ColorStandardMaterial($value);
				COLOR_MATERIALS[$value].alphaThreshold = 1;
			}
			return COLOR_MATERIALS[$value];
		}
		
		
		/**
		 * 
		 * 返回一个可重复使用的文本颜色透明资源。
		 * 
		 */
		
		public static function getTextDiffResource($color:uint):BitmapTextureResource
		{
			if(!TEXT_SOURCE[$color])
			{
				var diffBmd:BitmapData = new BitmapData(32, 32, false, $color);
				TEXT_SOURCE[$color] = new BitmapTextureResource(diffBmd);
			}
			return TEXT_SOURCE[$color];
		}
		
		
		/**
		 * 
		 * 返回一个创建材质所需的属性数组。
		 * 
		 */
		
		public static const ATTRIBUTES:Array = 
		[
			VertexAttributes.POSITION,
			VertexAttributes.POSITION,
			VertexAttributes.POSITION,
			VertexAttributes.TEXCOORDS[0],
			VertexAttributes.TEXCOORDS[0],
			VertexAttributes.NORMAL,
			VertexAttributes.NORMAL,
			VertexAttributes.NORMAL,
			VertexAttributes.TANGENT4,
			VertexAttributes.TANGENT4,
			VertexAttributes.TANGENT4,
			VertexAttributes.TANGENT4
		];
		
		
		/**
		 * @private
		 */
		private static var stage:Stage3D;
		
		
		/**
		 * @private
		 */
		private static const sources:Vector.<Resource> = new Vector.<Resource>;
		
		/**
		 * @private
		 */
		private static const COLOR_MATERIALS:Object = {};
		
		/**
		 * @private
		 */
		private static const TEXT_SOURCE:Object = {};
		
	}
}