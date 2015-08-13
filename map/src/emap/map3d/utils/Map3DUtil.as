package emap.map3d.utils
{
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.primitives.Plane;
	import alternativa.engine3d.resources.BitmapTextureResource;
	
	import cn.vision.collections.Map;
	import cn.vision.core.NoInstance;
	import cn.vision.utils.FontUtil;
	import cn.vision.utils.MathUtil;
	
	import com.winonetech.core.VO;
	
	import emap.core.em;
	import emap.data.Layout;
	import emap.map3d.comman.PixelTextureMaterial;
	import emap.tools.SourceManager;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
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
		 * 根据形状和布局生成一个形状。
		 * 
		 */
		
		public static function getPlaneByShape($shape:Shape, $layout:Layout):Object3D
		{
			if ($shape && $layout)
			{
				var w:uint = to2Square($layout.width);
				var h:uint = to2Square($layout.height);
				var segW:uint = Math.max(1, w * 0.015625);
				var segH:uint = Math.max(1, h * 0.015625);
				if (w && h)
				{
					//Y轴反向截取
					var bmd:BitmapData = new BitmapData(w, h, true, 0);
					var mat:Matrix = new Matrix;
					mat.createBox(1, -1, 0, -$layout.minX, -$layout.minY);
					bmd.draw($shape, mat);
					
					var tex:PixelTextureMaterial = new PixelTextureMaterial(new BitmapTextureResource(bmd));
					tex.alphaThreshold = tex.alpha = 1;
					var plane:Plane = new Plane(w, h, segW, segH, false);
					plane.setMaterialToAllSurfaces(tex);
					
					plane.x = plane.boundBox.maxX;
					plane.y =-plane.boundBox.maxY;
					
					var object:Object3D = new Object3D;
					object.addChild(plane);
					object.x = $layout.minX;
					object.y =-$layout.minY;
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
			var temp:TextFormat = SourceManager.getTextFormat($font);
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
		 * 
		 * 遍历数组，并返回一个Map类型。
		 * 
		 * @param $arr:Array 数组。
		 * 
		 * @return Map Map类型。
		 * 
		 */
		
		public static function analyzeArr($arr:Array):Map
		{
			if ($arr && $arr.length)
			{
				var map:Map = new Map;
				for each (var vo:VO in $arr) map[vo.id] = vo;
			}
			return map;
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
		em static var field:TextField;
		
	}
}