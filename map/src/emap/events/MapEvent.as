package emap.events
{
	
	/**
	 * 
	 * 地图事件。
	 * 
	 */
	
	
	import cn.vision.core.VSEvent;
	
	import emap.core.em;
	import emap.vos.VOPosition;
	
	import flash.events.Event;
	
	
	public final class MapEvent extends VSEvent
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function MapEvent($type:String, $serial:String = null, $bubbles:Boolean = false, $cancelable:Boolean = false)
		{
			super($type, $bubbles, $cancelable);
			
			em::serial = $serial;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function clone():Event
		{
			return new MapEvent(type, serial, bubbles, cancelable);
		}
		
		
		/**
		 * 
		 * 序列号。
		 * 
		 */
		
		public function get serial():String
		{
			return em::serial;
		}
		
		
		/**
		 * @private
		 */
		em var serial:String;
		
		
		/**
		 * 
		 * 点击位置。
		 * 
		 */
		
		public static const POSITION_CLICK:String = "positionClick";
		
	}
}