package emap.map3d
{
	
	/**
	 * 
	 * 背景平面。
	 * 
	 */
	
	
	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.BoundBox;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.resources.Geometry;
	
	import emap.core.em;
	import emap.map3d.tools.SourceEmap3D;
	import emap.map3d.utils.Map3DUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Stage3D;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	
	public final class Background extends Mesh
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function Background(
			width:Number = 100,
			length:Number = 100,
			usize:uint = 1,
			vsize:uint = 1,
			widthSegments:uint = 1,
			lengthSegments:uint = 1,
			twoSided:Boolean = true,
			reverse:Boolean = false,
			bottom:Material = null,
			top:Material = null)
		{
			super();
			
			if (widthSegments <= 0 || lengthSegments <= 0)
				throw new ArgumentError("Parameter widthSegments and lengthSegments must > 0");
			
			var x:int, y:int, t:Number, s:Number, wEdges:int = widthSegments + 1, lEdges:int = lengthSegments + 1;
			var indices:Vector.<uint> = new Vector.<uint>;
			var halfWidth:Number = width * 0.5, halfLength:Number = length * 0.5;
			
			var segmentUSize:Number = usize / widthSegments;
			var segmentVSize:Number = vsize / lengthSegments;
			
			var segmentWidth :Number = width  / widthSegments;
			var segmentLength:Number = length / lengthSegments;
			
			var vertices:ByteArray = new ByteArray;
			vertices.endian = Endian.LITTLE_ENDIAN;
			var offsetAdditionalData:Number = 28;
			// Top face.
			for (x = 0; x < wEdges; x++)
			{
				for (y = 0; y < lEdges; y++)
				{
					vertices.writeFloat(x*segmentWidth - halfWidth);
					vertices.writeFloat(y*segmentLength - halfLength);
					vertices.writeFloat(0);
					vertices.writeFloat(x*segmentUSize);
					vertices.writeFloat((lengthSegments - y)*segmentVSize);
					vertices.length = vertices.position += offsetAdditionalData;
				}
			}
			var lastPosition:uint = vertices.position;
			for (x = 0; x < wEdges; x++)
			{
				for (y = 0; y < lEdges; y++)
				{
					if (x < widthSegments && y < lengthSegments) 
					{
						t = (x + 1) * lEdges + y;
						s = x * lEdges + y;
						createFace(indices, vertices, s, t, t + 1, s + 1, 0, 0, 1, 1, 0, 0, -1, reverse);
					}
				}
			}
			
			if (twoSided)
			{
				vertices.position = lastPosition;
				// Bottom face.
				for (x = 0; x < wEdges; x++)
				{
					for (y = 0; y < lEdges; y++)
					{
						vertices.writeFloat(x*segmentWidth - halfWidth);
						vertices.writeFloat(y*segmentLength - halfLength);
						vertices.writeFloat(0);
						vertices.writeFloat((widthSegments - x)*segmentUSize);
						vertices.writeFloat((lengthSegments - y)*segmentVSize);
						vertices.length = vertices.position += offsetAdditionalData;
					}
				}
				var baseIndex:uint = wEdges * lEdges;
				for (x = 0; x < wEdges; x++)
				{
					for (y = 0; y < lEdges; y++)
					{
						if (x < widthSegments && y < lengthSegments)
						{
							t = baseIndex + (x + 1) * lEdges + y;
							s = baseIndex + x * lEdges + y;
							createFace(indices, vertices, t + 1, t, s, s + 1, 0, 0, -1, -1, 0, 0, -1, reverse);
						}
					}
				}
			}
			
			// Set bounds
			geometry = new Geometry;
			geometry.indices = indices;
			
			geometry.addVertexStream(SourceEmap3D.ATTRIBUTES);
			geometry.alternativa3d::_vertexStreams[0].data = vertices;
			geometry.alternativa3d::_numVertices = vertices.length / 48;
			if(!twoSided)
			{
				addSurface(top, 0, indices.length / 3);
			}
			else
			{
				addSurface(top, 0, indices.length / 6);
				addSurface(bottom, indices.length * .5, indices.length / 6);
			}
			
			boundBox = new BoundBox;
			boundBox.minX = -halfWidth;
			boundBox.minY = -halfLength;
			boundBox.minZ = 0;
			boundBox.maxX = halfWidth;
			boundBox.maxY = halfLength;
			boundBox.maxZ = 0;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function clone():Object3D
		{
			var res:Background = new Background(0, 0, 0, 0);
			res.clonePropertiesFrom(this);
			return res;
		}
		
		
		/**
		 * @private
		 */
		private function createFace(
			indices:Vector.<uint>,
			vertices:ByteArray,
			a:int,
			b:int,
			c:int,
			d:int,
			nx:Number,
			ny:Number,
			nz:Number,
			tx:Number,
			ty:Number,
			tz:Number,
			tw:Number,
			reverse:Boolean):void
		{
			var temp:int;
			if (reverse)
			{
				nx = -nx;
				ny = -ny;
				nz = -nz;
				tw = -tw;
				temp = a;
				a = d;
				d = temp;
				temp = b;
				b = c;
				c = temp;
			}
			indices[indices.length] = a;
			indices[indices.length] = b;
			indices[indices.length] = c;
			indices[indices.length] = a;
			indices[indices.length] = c;
			indices[indices.length] = d;
			vertices.position = a*48 + 20;
			vertices.writeFloat(nx);
			vertices.writeFloat(ny);
			vertices.writeFloat(nz);
			vertices.writeFloat(tx);
			vertices.writeFloat(ty);
			vertices.writeFloat(tz);
			vertices.writeFloat(tw);
			vertices.position = b*48 + 20;
			vertices.writeFloat(nx);
			vertices.writeFloat(ny);
			vertices.writeFloat(nz);
			vertices.writeFloat(tx);
			vertices.writeFloat(ty);
			vertices.writeFloat(tz);
			vertices.writeFloat(tw);
			vertices.position = c*48 + 20;
			vertices.writeFloat(nx);
			vertices.writeFloat(ny);
			vertices.writeFloat(nz);
			vertices.writeFloat(tx);
			vertices.writeFloat(ty);
			vertices.writeFloat(tz);
			vertices.writeFloat(tw);
			vertices.position = d*48 + 20;
			vertices.writeFloat(nx);
			vertices.writeFloat(ny);
			vertices.writeFloat(nz);
			vertices.writeFloat(tx);
			vertices.writeFloat(ty);
			vertices.writeFloat(tz);
			vertices.writeFloat(tw);
		}
		
		/**
		 * @private
		 */
		private function toColor($value:String):int
		{
			var result:int = -1;
			if (isNaN(Number($value)))
			{
				if ($value.charAt(0) == "#")
				{
					$value = $value.substr(1);
					if(!isNaN(Number($value))) result = uint($value);
				}
			}
			else
			{
				result = uint($value);
			}
			return result;
		}
		
		/**
		 * @private
		 */
		private function loadImage($url:String):void
		{
			loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handlerDefault);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handlerDefault);
			loader.load(new URLRequest($url));
		}
		
		/**
		 * @private
		 */
		private function displayBmd($bmd:BitmapData):void
		{
			var w:int = Map3DUtil.to2Square($bmd.width);
			var h:int = Map3DUtil.to2Square($bmd.height);
			var bmd:BitmapData = new BitmapData(w, h, true, 0);
			var sx:Number = w / $bmd.width;
			var sy:Number = h / $bmd.height;
			var mat:Matrix = new Matrix;
			mat.scale(sx, sy);
			bmd.draw($bmd, mat);
			var source:BitmapTextureResource = new BitmapTextureResource(bmd);
			
			setMaterialToAllSurfaces(new TextureMaterial(source));
			
			SourceEmap3D.uploadSource(source)
		}
		
		
		/**
		 * @private
		 */
		private function handlerDefault($e:Event):void
		{
			if ($e.type == Event.COMPLETE)
			{
				var bmd:BitmapData = new BitmapData(loader.content.width, loader.content.height, true, 0);
				bmd.draw(loader.content);
				displayBmd(bmd);
			}
		}
		
		
		/**
		 * 
		 * 设置资源，可以是颜色或图片。
		 * 
		 */
		
		public function get source():Object
		{
			return em::source;
		}
		
		/**
		 * @private
		 */
		public function set source($value:Object):void
		{
			if (source != $value)
			{
				em::source = $value;
				if (source is uint)
				{
					setMaterialToAllSurfaces(new FillMaterial(source as uint));
				}
				else if (source is String)
				{
					var temp:String = source as String;
					var color:int = toColor(temp);
					if (color >= 0)
						setMaterialToAllSurfaces(new FillMaterial(color));
					else
						loadImage(temp);
				}
				else if (source is Bitmap)
				{
					displayBmd((source as Bitmap).bitmapData);
				}
				else if (source is BitmapData)
				{
					displayBmd(source as BitmapData);
				}
			}
		}
		
		
		/**
		 * @private
		 */
		private var loader:Loader;
		
		
		/**
		 * @private
		 */
		em var source:Object;
		
	}
}