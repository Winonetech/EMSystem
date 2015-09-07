package emap.map3d.comman
{
	
	/**
	 * 
	 * 悬浮的LOGO
	 * 
	 */
	
	
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.objects.Sprite3D;
	import alternativa.engine3d.primitives.Box;
	
	import emap.core.em;
	import emap.map3d.utils.Map3DUtil;
	
	
	public final class LogoSprite extends Logo
	{
		
		/**
		 * 
		 * 构造函数
		 * 
		 */
		
		public function LogoSprite($maxWidth:Number, $maxHeight:Number, $color:uint = 0)
		{
			super($maxWidth, $maxHeight, $color);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function applyLogo($w:Number, $h:Number, $material:PixelTextureMaterial):void
		{
			sprite = Map3DUtil.destroyObject3D(sprite);
			addChild(sprite = new Sprite3D($w, $h, $material));
			sprite.alwaysOnTop = true;
		}
		
		
		/**
		 * 
		 * LOGOSprite 的宽高乘以2用来
		 * 
		 */
		
		override protected function getBmdWH($value:Number):Number
		{
			return super.getBmdWH($value) * 2;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function set scale($value:Number):void
		{
			if (scale!= $value)
			{
				em::scale = $value;
				scaleX = scaleY = scaleZ = $value;
			}
		}
		
		
		/**
		 * @private
		 */
		private var sprite:Sprite3D;
		
	}
}