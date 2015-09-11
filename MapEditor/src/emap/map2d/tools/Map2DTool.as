package emap.map2d.tools
{
	import cn.vision.core.NoInstance;
	import cn.vision.utils.FontUtil;
	
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Map2DTool extends NoInstance
	{
		public static function getText($text:String, $font:String, $color:uint):TextField
		{  
			
			var field:TextField = new TextField;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.antiAliasType = AntiAliasType.ADVANCED;
			field.textColor = $color;
			field.text = $text;
			var temp:TextFormat = getTextFormat($font);
			if (format!= temp) format = temp;
			field.embedFonts = FontUtil.containsFont(format.font);
			field.setTextFormat(format);  
			return field; 
		}  
		
		public static function getTextFormat($font:String):TextFormat
		{
			return TEXT_FORMATS[$font] = TEXT_FORMATS[$font] || new TextFormat($font, 20, null, false, null, null, null, null, "left");;
		}	
		public static function destroyObject($object:Object):*
		{
			if ($object && $object.parent)
				$object.parent.removeChild($object);
			return null;
		}
		private static const TEXT_FORMATS:Object = {};
		private static var format:TextFormat;
	}
	
}