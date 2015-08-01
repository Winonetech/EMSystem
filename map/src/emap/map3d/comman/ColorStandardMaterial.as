package emap.map3d.comman
{
	
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.resources.TextureResource;
	
	import flash.display.BitmapData;
	
	
	public class ColorStandardMaterial extends StandardMaterial
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function ColorStandardMaterial(
			col:uint,
			diffuseMap:TextureResource = null,
			normalMap:TextureResource = null,
			specularMap:TextureResource = null,
			glossinessMap:TextureResource = null,
			opacityMap:TextureResource = null)
		{
			color = col;
			
			var resource1:BitmapTextureResource = new BitmapTextureResource(new BitmapData(16, 16, false, col));  
			var resource2:BitmapTextureResource = new BitmapTextureResource(new BitmapData(16, 16, false, 0x0000ff));  
			var resource3:BitmapTextureResource = new BitmapTextureResource(new BitmapData(16, 16, false, 0x000000));  
			
			super(resource1, resource2, resource3);
			
			alphaThreshold = 1;
		}
		
		
		/**
		 * 
		 * 颜色值。
		 * 
		 */
		
		public var color:uint;
		
	}
}