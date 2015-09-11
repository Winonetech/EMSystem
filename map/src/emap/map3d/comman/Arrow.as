package emap.map3d.comman
{
	
	/**
	 * 
	 * 箭头。
	 * 
	 */
	
	
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.objects.WireFrame;
	
	import flash.geom.Vector3D;
	
	
	public final class Arrow extends Object3D
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function Arrow()
		{
			super();
		}
		
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			addChild(WireFrame.createLinesList(points, 0xFF0000, 1, 2));
		}
		
		
		/**
		 * @private
		 */
		private const points:Vector.<Vector3D> = new Vector.<Vector3D>
		([
			new Vector3D, new Vector3D(-5, -5),
			new Vector3D, new Vector3D(-5, 5)
		]);
		
	}
}