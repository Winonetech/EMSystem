package emap.events
{
	import cn.vision.core.VSEvent;
	
	public final class MapEvent extends VSEvent
	{
		public function MapEvent($type:String, $bubbles:Boolean = false, $cancelable:Boolean = false)
		{
			super($type, $bubbles, $cancelable);
		}
	}
}