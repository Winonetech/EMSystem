package emap.map2d.controls
{
	import emap.core.em;
	import emap.data.Transform;
	import emap.map2d.tools.Map2DTool;
	import emap.utils.PositionUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	public class ImageLayer extends Sprite
	{
		/**
		 * 
		 * 构造函数
		 * 
		 */
		
		public function ImageLayer()
		{
			super();
			
		}
		
		/**
		 * 
		 * 应用LOGO
		 * 
		 */

		protected function applyLogo($w:Number, $h:Number, $bmd:BitmapData):void
		{
			bitmap = Map2DTool.destroyObject(bitmap);
			addChild(bitmap = new Bitmap($bmd));
//			bitmap.x = 0;
//			bitmap.y = offsetY;
			bitmap.width = $w;
			bitmap.height = $h;
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
			resolveMaterial(new Transform(0, 0, w, h, 1, 1), $content);
		}
		
		/**
		 * @private
		 */
		private function resolveMaterial($rect:Transform, $data:IBitmapDrawable):void
		{
			offsetX =-.5 * $rect.width;
			offsetY =-.5 * $rect.height;
			if ($data)
			{
				var bmd:BitmapData = new BitmapData($rect.width, $rect.height, true, color);
				var mat:Matrix = new Matrix;
				mat.scale($rect.scaleX, $rect.scaleY);
				bmd.draw($data, mat);
				applyLogo($rect.width, $rect.height, bmd);
			
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
			if ($e.type == Event.COMPLETE)
			{
				w = loaderInfo.content.width;
				h = loaderInfo.content.height;
				resolveContent(loaderInfo.content);
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
		protected var bitmap:Bitmap;
		
		
		/**
		 * @private
		 */
		em var source:Object;
	  private var w:Number;
	  private var h:Number;
	}
	
}