package emap.map2d.core
{
	import cn.vision.collections.Map;
	
	import editor.consts.ToolStateStyleConsts;
	
	import emap.core.EMConfig;
	import emap.map2d.EMap2D;
	import emap.map2d.UtilLayer;
	
	[Bindable]
	public final class E2Config extends EMConfig
	{
		
		/**
		 * 
		 * 构造函数
		 * 
		 */
		
		public function E2Config($data:Object = null)
		{
			super($data);
		}
		
		
		/**
		 * 
		 * logo
		 * 
		 */
		
		public function set logo($value:String):void
		{
			setProperty("logo", $value);
		}
		
		
		/**
		 * 
		 * 启用场馆。
		 * 
		 */
		
		public function set hallEnabled($value:Boolean):void
		{
			setProperty("hallEnabled", $value);
		}
		
		
		/**
		 * 
		 * 小图标宽度
		 * 
		 */
		
		public function set iconWidth($value:Number):void
		{
			setProperty("iconWidth", $value);
		}
		
		
		/**
		 * 
		 * 小图标高度
		 * 
		 */
		
		public function set iconHeight($value:Number):void
		{
			setProperty("iconHeight", $value);
		}
		
		
		/**
		 * 
		 * 实体位置厚度
		 * 
		 */
		
		public function set thickEntity($value:Number):void
		{
			setProperty("thickEntity", $value);
		}
		
		
		/**
		 * 
		 * 镂空位置厚度
		 * 
		 */
		
		public function set thickHollow($value:Number):void
		{
			setProperty("thickHollow", $value);
		}
		public function set eMap($value:EMap2D):void
		{
			_eMap = $value;
			utilLayer.clickEffect();
		}
		public function get eMap():EMap2D
		{
			return _eMap;
		}
		private var _eMap:EMap2D;
		public var serialViewMap:Map = new Map;
		public var INodeNameMap:Map = new Map;
		public var floorViewMap:Map = new Map;
		public var groundViewMap:Map = new Map;
		public var nodeViewMap:Map = new Map;
		public var routeViewMap:Map = new Map;
		public var positionViewMap:Map = new Map;
		public var utilLayer:UtilLayer;
		public var subNode:Boolean = false;
		public var setEditor:Boolean = false;
		public var editorStyle:String;
		public var toolStyle:String = ToolStateStyleConsts.NO_STATE;
	}
}