package emap.map3d.utils
{
	
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.primitives.Plane;
	import alternativa.engine3d.resources.BitmapTextureResource;
	
	import cn.vision.core.NoInstance;
	import cn.vision.utils.FontUtil;
	import cn.vision.utils.MathUtil;
	
	import emap.core.em;
	import emap.data.Layout;
	import emap.data.Transform;
	import emap.managers.TextFormatManager;
	import emap.map3d.comman.PixelTextureMaterial;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	
	public final class Map3DUtil extends NoInstance
	{
		
		/**
		 * 
		 * 转换2的次方数。
		 * 
		 */
		
		public static function to2Square($value:uint):uint
		{
			return 1 << Math.ceil(MathUtil.log2($value));
		}
		
		
		/**
		 * 
		 * 获取转换为二次方数且宽高不大于2048*2048的范围。
		 * 
		 * @param $w:Number 原始宽度。
		 * @param $h:Number 原始高度。
		 * 
		 * @return Rectangle 限制后的矩形范围。
		 * 
		 */
		
		public static function getLimitedBitmapDataRect($w:Number, $h:Number):Transform
		{
			var w:Number = to2Square($w);
			var h:Number = to2Square($h);
			while (w * h >= AREA_LIMIT)
			{
				w = to2Square(w >>> 1);
				h = to2Square(h >>> 1);
			}
			return new Transform(0, 0, w, h, w / $w, h / $h);
		}
		
		
		/**
		 * 
		 * 根据形状和布局生成一个平面。
		 * 
		 */
		
		public static function getPlaneByShape($shape:Shape, $layout:Layout):Object3D
		{
			if ($shape && $layout)
			{
				var rect:Transform = getLimitedBitmapDataRect($layout.width, $layout.height);
				var w:uint = rect.width;
				var h:uint = rect.height;
				var segW:uint = Math.max(1, 0.015625 * $layout.width);
				var segH:uint = Math.max(1, 0.015625 * $layout.height);
				if (w && h)
				{
					//Y轴反向截取
					var bmd:BitmapData = new BitmapData(w, h, true, 0);
					var mat:Matrix = new Matrix;
					mat.createBox(rect.scaleX, -rect.scaleY, 0, -$layout.minX * rect.scaleX, -$layout.minY * rect.scaleY);
					bmd.draw($shape, mat);
					var tex:PixelTextureMaterial = new PixelTextureMaterial(new BitmapTextureResource(bmd), null, 1, true);
					//tex.transparentPass = true;
					//tex.opaquePass = true;
					tex.alphaThreshold = 1;
					tex.alpha = 1;
					
					var plane:Plane = new Plane($layout.width, $layout.height, segW, segH, false);
					plane.setMaterialToAllSurfaces(tex);
					
					plane.x = plane.boundBox.maxX;
					plane.y =-plane.boundBox.maxY;
					plane.mouseChildren = plane.mouseEnabled = false;
					
					var object:Object3D = new Object3D;
					object.addChild(plane);
					object.x = $layout.minX;
					object.y =-$layout.minY;
					object.mouseChildren = object.mouseEnabled = false;
				}
			}
			return object;
		}
		
		
		/**
		 * 
		 * 获取一个文本平面。
		 * 
		 * @param $text:String 文本
		 * @param $font:String 字体
		 * @param $color:uint 颜色
		 * 
		 */
		
		public static function getPlaneByText($text:String, $font:String, $color:uint):Object3D
		{
			field.textColor = $color;
			field.text = $text;
			var temp:TextFormat = TextFormatManager.getTextFormat($font);
			if (format!= temp) format = temp;
			field.embedFonts = FontUtil.containsFont(format.font);
			field.setTextFormat(format);
			var w:Number = Map3DUtil.to2Square(field.width);
			var h:Number = Map3DUtil.to2Square(field.height);
			var segW:uint = Math.max(1, w * 0.015625);
			var segH:uint = Math.max(1, h * 0.015625);
			var opacBmd:BitmapData = new BitmapData(w, h, true, 0xFFFFFF);
			opacBmd.draw(field);
			var diffBmd:BitmapData = new BitmapData(32, 32, false, $color);
			var tex:PixelTextureMaterial = new PixelTextureMaterial(
				new BitmapTextureResource(diffBmd), 
				new BitmapTextureResource(opacBmd), 1, true);
			tex.alpha = tex.alphaThreshold = 1;
			var plane:Plane = new Plane(w, h, segW, segH, false);
			plane.setMaterialToAllSurfaces(tex);
			plane.x = plane.boundBox.maxX - .5 * field.width;
			plane.y = plane.boundBox.minY + .5 * field.height;
			var object:Object3D = new Object3D;
			object.addChild(plane);
			return object;
		}
		
		
		/**
		 * 
		 * 删除一个Object3D。
		 * 
		 */
		
		public static function destroyObject3D($object:Object3D):*
		{
			if ($object && $object.parent)
				$object.parent.removeChild($object);
			return null;
		}
		
		
		/**
		 * 
		 * 验证数值是否可改变。
		 * 
		 */
		
		public static function numable($source:Number, $target:Number):Boolean
		{
			return $source != $target && !isNaN($target);
		}
		
		
		/**
		 * @private
		 */
		private static function get field():TextField
		{
			if(!em::field)
			{
				em::field = new TextField;
				em::field.autoSize = TextFieldAutoSize.LEFT;
				em::field.antiAliasType = AntiAliasType.ADVANCED;
			}
			return em::field;
		}
		
		
		/**
		 * @private
		 */
		private static var format:TextFormat;
		
		
		/**
		 * @private
		 */
		private static const AREA_LIMIT:uint = 2048 * 2048;
		
		
		/**
		 * @private
		 */
		em static var field:TextField;
		
	}
}
