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

		
		private function initialize():void
		{
			graphics.beginFill(0x000000)
			graphics.drawRect(0,0,MAX_W,MAX_H);
			graphics.endFill();
			addChild(grid  = new Grid);
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
	private var grid : Grid ;
	}
	
}