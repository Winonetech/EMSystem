package emap.map3d.comman
{
	
	/**
	 * 
	 * 箭头。实际圆锥
	 * 
	 */
	
	
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.resources.Geometry;
	
	import cn.vision.utils.ArrayUtil;
	
	import emap.map3d.tools.SourceEmap3D;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	
	public final class Arrow extends Object3D
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function Arrow($color:uint = 0xFF0000)
		{
			super();
			
			initialize($color);
		}
		
		
		/**
		 * @private
		 */
		private function initialize($color:uint):void
		{
			var mesh:Mesh = new Mesh;
			addChild(mesh);
			const vts:Vector.<Number> = new Vector.<Number>;
			const uvs:Vector.<Number> = new Vector.<Number>;
			const nms:Vector.<Number> = new Vector.<Number>;
			const tgs:Vector.<Number> = new Vector.<Number>;
			const ids:Vector.<uint>   = new Vector.<uint>;
			const ats:Array = SourceEmap3D.ATTRIBUTES;
			
			const seg:uint = 48;//分段
			const h:Number = 60;//高度
			const r:Number = 20;//半径
			const n:Number = 3;
			const d:Number = 2 * Math.PI / seg;
			const f:Number = Math.asin(r * Math.sin(d)) / Math.sqrt(r * r + h * h);
			const k:Number = Math.tan(f);
			var l:uint = seg * 3;
			for (var i:uint = 0; i < l; i += 3)
			{
				ArrayUtil.push(ids, i, i + 1, i + 2);
			}
			const t:Number = 2 * Math.PI - .1;
			const s:Number = h * .5;
			for (var a:Number = 0; a < t; a += d)
			{
				var v:Number = a + d;
				ArrayUtil.push(vts, r * Math.sin(a), r * Math.cos(a), -s);
				ArrayUtil.push(vts, 0, 0, s);
				ArrayUtil.push(vts, r * Math.sin(v), r * Math.cos(v), -s);
			}
			
			const p1:Point = new Point(-.5 * n * k, n);
			const p2:Point = new Point;
			const p3:Point = new Point(.5 * n * k, n);
			const ro:Matrix = new Matrix;
			
			for (i = 0; i < l; i += 3)
			{
				var v1:Point = ro.deltaTransformPoint(p1);
				var v2:Point = ro.deltaTransformPoint(p2);
				var v3:Point = ro.deltaTransformPoint(p3);
				ro.rotate(-f);
				ArrayUtil.push(uvs, v1.x, v1.y, v2.x, v2.y, v3.x, v3.y);
			}
			
			l = seg * 9;
			for (i = 0; i < l; i += 9)
			{
				var nm:Vector3D = caculateNormals(
					new Vector3D(vts[i    ], vts[i + 1], vts[i + 2]),
					new Vector3D(vts[i + 3], vts[i + 4], vts[i + 5]),
					new Vector3D(vts[i + 6], vts[i + 7], vts[i + 8]));
				ArrayUtil.push(nms, nm.x, nm.y, nm.z, nm.x, nm.y, nm.z, nm.x, nm.y, nm.z);
			}
			
			for (i = 0; i < l; i += 9)
			{
				var ta:Vector3D = new Vector3D(
					vts[i    ] - vts[i + 6],
					vts[i + 1] - vts[i + 7],
					vts[i + 2] - vts[i + 8]);
				ta.normalize();
				ArrayUtil.push(tgs, ta.x, ta.y, ta.z, 1, ta.x, ta.y, ta.z, 1, ta.x, ta.y, ta.z, 1);
			}
			
			var geo:Geometry = new Geometry;
			geo.numVertices = seg * 3;
			geo.indices = ids;
			geo.addVertexStream(ats);
			geo.setAttributeValues(VertexAttributes.POSITION, vts);
			geo.setAttributeValues(VertexAttributes.TEXCOORDS[0], uvs);
			geo.setAttributeValues(VertexAttributes.NORMAL, nms);
			geo.setAttributeValues(VertexAttributes.TANGENT4, tgs);
			mesh.geometry = geo;
			var mat:FillMaterial = new FillMaterial($color);
			mesh.addSurface(mat, 0, seg);
			mesh.calculateBoundBox();
			mesh.setMaterialToAllSurfaces(mat);
			mesh.rotationY = Math.PI * .5;
		}
		
		/**
		 * @private
		 */
		private function caculateNormals($a:Vector3D, $b:Vector3D, $c:Vector3D):Vector3D
		{
			var v1:Vector3D = $a.subtract($b);
			var v2:Vector3D = $b.subtract($c);
			var v3:Vector3D = v1.crossProduct(v2);
			v3.normalize();
			return v3;
		}
		
	}
}