package emap.map2d
{
	import editor.command.InitDataCommand;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class MapContainer extends Sprite
	{
		public function MapContainer()
		{
			super();
			initialize();
		}
		public function createAidLine(style:String, value:Number):void
		{
			
			if (style=="x") {
				hLine.graphics.clear();
				hLine.graphics.lineStyle(.1, 0x33FF00);
				hLine.graphics.moveTo(value, 0);
				hLine.graphics.lineTo(value, MAX_H);
			} else {
				vLine.graphics.clear();
				vLine.graphics.lineStyle(.1, 0x33FF00);
				vLine.graphics.moveTo(0    , value);
				vLine.graphics.lineTo(MAX_W, value);
			}
		}
		
		public function clearAidLine (style:String=null):void
		{
			if (style=="x") {
				hLine.graphics.clear();
			} else if (style=="y") {
				vLine.graphics.clear();
			} else {
				hLine.graphics.clear();
				vLine.graphics.clear();
			}
		}
		
		private function initialize():void
		{
			addChild(floorLayer = new Sprite);
			addChild(toolLayer = new Sprite);
			
			//new InitDataCommand().execute();
			
		}
		public function addFloor(floor:Floor):void
		{
			
			floorLayer.addChild(floor);
		}
		public function clear():void
		{
			while(this.numChildren) this.removeChildAt(0);
		}
		private var toolLayer:Sprite;
		
		private var floorLayer:Sprite;
		
	public static const MAX_W:Number = 5000;
	public static const MAX_H:Number = 5000;
	private var ruleLayer:Sprite;
	private var hRule:Rule;
	private var vRule:Rule;
	private var hLine :Shape;
	private var vLine :Shape; 
	}
	
}