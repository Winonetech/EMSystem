package emap.map3d.comman
{
	
	/**
	 * 
	 * 平面贴紧的LOGO
	 * 
	 */
	
	
	import alternativa.engine3d.primitives.Plane;
	
	import emap.map3d.utils.Map3DUtil;
	
	
	public final class LogoPlane extends Logo
	{
		
		/**
		 * 
		 * 构造函数
		 * 
		 */
		
		public function LogoPlane($maxWidth:Number, $maxHeight:Number)
		{
			super($maxWidth, $maxHeight);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function applyLogo($w:Number, $h:Number, $material:PixelTextureMaterial):void
		{
			plane = Map3DUtil.destroyObject3D(plane);
			var segW:uint = Math.max(1, $w * 0.015625);
			var segH:uint = Math.max(1, $h * 0.015625);
			addChild(plane = new Plane($w, $h, segW, segH, true));
			plane.setMaterialToAllSurfaces($material);
			plane.x = plane.boundBox.maxX - offsetX;
			plane.y = plane.boundBox.minY + offsetY;
		}
		
		
		/**
		 * @private
		 */
		private var plane:Plane;
		
	}
}