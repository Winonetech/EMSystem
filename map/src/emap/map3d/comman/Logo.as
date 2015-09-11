package emap.map3d.comman
{
	
	/**
	 * 
	 * 显示图标的Plane
	 * 
	 */
	
	
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.resources.BitmapTextureResource;
	
	import emap.core.em;
	import emap.data.Transform;
	import emap.map3d.utils.Map3DUtil;
	import emap.map3d.tools.SourceEmap3D;
	import emap.utils.PositionUtil;
	
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	  
	
	public class Logo extends Object3D
	{
		
		/**
		 * 
		 * 构造函数
		 * 
		 */
		
		public function Logo($maxWidth:Number, $maxHeight:Number, $color:uint = 0)
		{
			super();
			
			initialize($maxWidth, $maxHeight, $color);
		}
		
		
		/**
		 * 
		 * 应用LOGO
		 * 
		 */
		
		protected function applyLogo($w:Number, $h:Number, $material:PixelTextureMaterial):void
		{
			
		}
		
		
		/**
		 * 
		 * 根据传入的宽高转换为二的倍数宽高
		 * 
		 */
		
		protected function getBmdWH($value:Number):Number
		{
			return Map3DUtil.to2Square($value);
		}
		
		
		/**
		 * @private
		 */
		private function initialize($maxWidth:Number, $maxHeight:Number, $color:uint):void
		{
			color     = $color;
			maxWidth  = $maxWidth;
			maxHeight = $maxHeight;
		}
		
		/**
		 * @private
		 */
		private function createLoader():Loader
		{
			var loader:Loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handlerDefault);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handlerDefault);
			return loader;
		}
		
		/**
		 * @private
		 */
		private function resolveContent($content:IBitmapDrawable):void
		{
			resolveMaterial(PositionUtil.restrictIcon($content, maxWidth, maxHeight), $content);
		}
		
		/**
		 * @private
		 */
		private function resolveMaterial($rect:Transform, $data:IBitmapDrawable):void
		{
			offsetX = .5 * $rect.width;
			offsetY = .5 * $rect.height;
			var w:uint = getBmdWH($rect.width);
			var h:uint = getBmdWH($rect.height);
			if (w && h && $data)
			{
				var bmd:BitmapData = new BitmapData(w, h, true, color);
				var mat:Matrix = new Matrix;
				mat.scale($rect.scale, $rect.scale);
				bmd.draw($data, mat);
				var res:BitmapTextureResource = new BitmapTextureResource(bmd);
				var tex:PixelTextureMaterial = new PixelTextureMaterial(res, null, 1, false);
				tex.alphaThreshold = 1;
				applyLogo(w, h, tex);
				SourceEmap3D.uploadSource(res);
			}
		}
		
		
		/**
		 * @private
		 */
		private function handlerDefault($e:Event):void
		{
			var loaderInfo:LoaderInfo = $e.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, handlerDefault);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handlerDefault);
			if ($e.type == Event.COMPLETE) resolveContent(loaderInfo.content);
		}
		
		
		/**
		 * 
		 * 缩放比
		 * 
		 */
		
		public function get scale():Number
		{
			return em::scale;
		}
		
		/**
		 * @private
		 */
		public function set scale($value:Number):void
		{
			if (scale!= $value)
			{
				em::scale = $value;
				scaleX = scaleY = $value;
			}
		}
		
		
		/**
		 * 
		 * 资源路径
		 * 
		 */
		
		public function get source():Object
		{
			return em::source;
		}
		
		/**
		 * @private
		 */
		public function set source($value:Object):void
		{
			if (source!= $value)
			{
				em::source = $value;
				if (source is String)
					createLoader().load(new URLRequest(source as String));
				else if (source is ByteArray)
					createLoader().loadBytes(source as ByteArray);
				else if (source is IBitmapDrawable)
					resolveContent(source as IBitmapDrawable);
			}
		}
		
		
		/**
		 * 
		 * 背景颜色
		 * 
		 */
		
		public var color:uint;
		
		
		/**
		 * @private
		 */
		protected var offsetX:Number;
		
		/**
		 * @private
		 */
		protected var offsetY:Number;
		
		/**
		 * @private
		 */
		protected var maxWidth:Number;
		
		/**
		 * @private
		 */
		protected var maxHeight:Number;
		
		
		/**
		 * @private
		 */
		em var scale:Number;
		
		/**
		 * @private
		 */
		em var source:Object;
		
	}
}