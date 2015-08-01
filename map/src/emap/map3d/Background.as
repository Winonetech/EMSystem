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
	import emap.tools.SourceManager;
	import emap.map3d.utils.Map3DUtil;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Stage3D;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
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
			
			var indices:Vector.<uint> = new Vector.<uint>;
			var x:int;
			var y:int;
			var wEdges:int = widthSegments + 1;
			var lEdges:int = lengthSegments + 1;
			var halfWidth:Number = width * 0.5;
			var halfLength:Number = length * 0.5;
			
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
						createFace(indices, vertices, x * lEdges + y, (x + 1) * lEdges + y, (x + 1) * lEdges + y + 1, x * lEdges + y + 1, 0, 0, 1, 1, 0, 0, -1, reverse);
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
							createFace(indices, vertices, baseIndex + (x + 1) * lEdges + y + 1, baseIndex + (x + 1) * lEdges + y, baseIndex + x * lEdges + y, baseIndex + x * lEdges + y + 1, 0, 0, -1, -1, 0, 0, -1, reverse);
					}
				}
			}
			
			// Set bounds
			geometry = new Geometry;
			geometry.indices = indices;
			var attributes:Array = new Array;
			attributes[0] = VertexAttributes.POSITION;
			attributes[1] = VertexAttributes.POSITION;
			attributes[2] = VertexAttributes.POSITION;
			attributes[3] = VertexAttributes.TEXCOORDS[0];
			attributes[4] = VertexAttributes.TEXCOORDS[0];
			attributes[5] = VertexAttributes.NORMAL;
			attributes[6] = VertexAttributes.NORMAL;
			attributes[7] = VertexAttributes.NORMAL;
			attributes[8] = VertexAttributes.TANGENT4;
			attributes[9] = VertexAttributes.TANGENT4;
			attributes[10] = VertexAttributes.TANGENT4;
			attributes[11] = VertexAttributes.TANGENT4;
			
			geometry.addVertexStream(attributes);
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
		private function handlerDefault($e:Event):void
		{
			if ($e.type == Event.COMPLETE)
			{
				var w:int = Map3DUtil.to2Square(loader.content.width);
				var h:int = Map3DUtil.to2Square(loader.content.height);
				var bmd:BitmapData = new BitmapData(w, h, true, 0);
				bmd.draw(loader.content);
				
				var source:BitmapTextureResource = new BitmapTextureResource(bmd);
				
				setMaterialToAllSurfaces(new TextureMaterial(source));
				
				SourceManager.uploadSource(source);
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
			}
		}
		
		
		/**
		 * @private
		 */
		private var scene:Stage3D;
		
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