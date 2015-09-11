package emap.map3d.finding
{
	
	/**
	 * 
	 * 路径演示
	 * 
	 */
	
	
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.objects.WireFrame;
	import alternativa.engine3d.primitives.Box;
	
	import cn.vision.collections.Map;
	import cn.vision.core.VSObject;
	import cn.vision.utils.ArrayUtil;
	import cn.vision.utils.Vector3DUtil;
	import cn.vision.utils.math.BezierUtil;
	import cn.vision.utils.math.LineUtil;
	
	import emap.core.em;
	import emap.map3d.EMap3D;
	import emap.map3d.data.Axis3D;
	import emap.map3d.interfaces.IE3Node;
	import emap.map3d.tools.SourceEmap3D;
	import emap.map3d.vos.E3VOPosition;
	import emap.utils.NodeUtil;
	import emap.utils.RouteUtil;
	import emap.vos.VONode;
	import emap.vos.VOPosition;
	import emap.vos.VORoute;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Timer;
	
	
	public final class Shower extends Object3D
	{
		
		/**
		 * 
		 * 构造函数
		 * 
		 */
		
		public function Shower($emap3d:EMap3D, $container:Object3D)
		{
			super();
			
			initialize($emap3d, $container);
		}
		
		
		/**
		 * 
		 * 路径演示。
		 * 
		 */
		
		public function show($path:Path, $tween:Boolean = false):void
		{
			clear();
			
			path = $path;
			
			if (path && !path.block)
			{
				zawp = emap3d.em::viewFloors(path.floors, $tween);
				
				resolvePointsByPath();
				
				resolveVector3Ds2Axis();
				
				if ($tween)
				{
					
				}
				else
				{
					container.addChild(WireFrame.createLineStrip(points, 0xFF0000, 1, .5));
					SourceEmap3D.uploadAllSources(container);
					
				}
			}
		}
		
		
		/**
		 * 
		 * 清空上一次的路径演示。
		 * 
		 */
		
		public function clear():void
		{
			/*timer.stop();
			while (container.numChildren) container.removeChildAt(0);*/
		}
		
		
		/**
		 * @private
		 */
		private function initialize($emap3d:EMap3D, $container:Object3D):void
		{
			emap3d = $emap3d;
			container = $container;
			var box:Box = new Box(100, 100, 500);
			var mat:FillMaterial = new FillMaterial(0xFFFF00);
			box.setMaterialToAllSurfaces(mat);
			container.addChild(box);
			
			axis3d = new Vector.<Axis3D>;
			points = new Vector.<Vector3D>;
			
			timer = new Timer(33);
			timer.addEventListener(TimerEvent.TIMER, handlerTimer);
		}
		
		/**
		 * @private
		 */
		private function resolveVector3Ds2Axis():void
		{
			var l:uint = points.length;
			var i:uint = 0;
			while (i < l)
			{
				var p:Vector3D = points[i];
				p.y = -p.y;
				axis3d[i] = new Axis3D(p.x, p.y, p.z, 0, 0, 0);
				i++;
			}
		}
		
		/**
		 * @private
		 */
		private function resolvePointsByPath():void
		{
			if (path)
			{
				if (path.shows && path.shows.length)
				{
					axis3d.length = 0;
					points.length = 0;
					var shows:Vector.<IE3Node> = path.shows;
					var i:uint = 0;
					var l:int = shows.length;
					//遍历所有需要显示的节点
					while (i < l)
					{
						var p:Number  = i == 0 ? 0 : radius;
						i = resolvePointsByRoute(shows, i, p);
					}
				}
			}
		}
		
		/**
		 * 获取单个路径的点集，取下一路径终点作为辅助。
		 * @private
		 * 
		 * @param $nodes:Vector.<IE3Node> 节点集合。
		 * @param $flag:uint 遍历进度记号。
		 * @param $fseg:Number (default = 0) 从某个距离开始。
		 * 
		 * @return uint 
		 */
		private function resolvePointsByRoute($nodes:Vector.<IE3Node>, $flag:uint, $dis:Number = 0):uint
		{
			var l:uint = $nodes.length;
			var n1:IE3Node = ($flag < l) ? $nodes[$flag] : null;
			var n2:IE3Node = ($flag < l - 1) ? $nodes[$flag + 1] : null;
			var n3:IE3Node = ($flag < l - 2) ? $nodes[$flag + 2] : null;
			$flag++;
			var bezier:Array = [];
			//判断n1和n2节点是否存在
			if (n1 && n2)
			{
				//判断是否有n3节点，非必要条件
				if (n3)
				{
					//第三节点存在
					var d1:Number = distance(n1, n2);
					//判断d1长度是否超过$dis
					if (d1 > $dis)
					{
						//判断第一条路径从$dis开始的长度是否超过radius
						if (d1 - $dis > radius)
						{
							//若超过，获取直线上的点，并推入points
							pushPointsLine(n1, n2, $dis, radius);
							//并将距离v2为$dis的点推入bezier
							ArrayUtil.push(bezier, getVector3DByDis(n2, n1, $dis));
						}
						else
						{
							//否则将第一条路径从$dis开始的点推入bezier
							ArrayUtil.push(bezier, getVector3DByDis(n1, n2, $dis));
						}
					}
					else
					{
						//将该点推入贝塞尔曲线数组末尾
						ArrayUtil.push(bezier, getVector3DByNode(n1));
					}
					//n2推入bezier
					ArrayUtil.push(bezier, getVector3DByNode(n2));
					
					//循环判断第二条路径长度是否超过$dis，如不超过，将路径终点推入bezier
					//否则停止循环，推入第二条路径
					var tmp:uint = $flag;
					while (tmp < l - 1)
					{
						var v1:IE3Node = $nodes[tmp];
						var v2:IE3Node = $nodes[tmp + 1];
						var dn:Number  = distance(v1, v2);
						if (dn < radius)
						{
							//下一路径长度未超过$dis，v2推入bezier
							ArrayUtil.push(bezier, getVector3DByNode(v2));
							tmp++;
						}
						else
						{
							//d2长度超过dis，第二条路径距v1为$dis的点推入bezier
							ArrayUtil.push(bezier, getVector3DByDis(v1, v2, radius));
							break;
						}
					}
					//获取曲线上的点，并推入points
					pushPointsCurve(bezier);
					//更新标记
					$flag = tmp;
				}
				else
				{
					//第三个节点不存在，路径至n2已经结束
					//获取n1与n2连接线上从$dis开始的点集合，并存入points
					pushPointsLine(n1, n2, $dis, 0);
					//更新标记
				}
			}
			return $flag;
		}
		
		/**
		 * @private
		 */
		private function pushPointsLine($start:IE3Node, $end:IE3Node, $front:Number, $back:Number):void
		{
			const start:Vector3D = getVector3DByNode($start);
			const end:Vector3D = getVector3DByNode($end);
			const speed:Number = getLineSpeedByNodes($start, $end);
			points = points.concat(LineUtil.getLineVector3Ds(start, end, speed, $front, $back));
		}
		
		/**
		 * @private
		 */
		private function pushPointsCurve($bezier:Array):void
		{
			if ($bezier.length > 1)
			{
				const p:Number = speedTurn / Vector3DUtil.distance.apply(null, $bezier);
				const start:Vector3D = ArrayUtil.shift($bezier);
				const end:Vector3D = $bezier.pop();
				ArrayUtil.unshift($bezier, start, end, p, true);
				points = points.concat(BezierUtil.getBezierVector3Ds.apply(null, $bezier));
			}
		}
		
		/**
		 * 计算2个节点之间的距离，包含同层与跨层的情况。
		 * @private
		 */
		private function distance($node1:IE3Node, $node2:IE3Node):Number
		{
			return Vector3D.distance(getVector3DByNode($node1), getVector3DByNode($node2));;
		}
		
		/**
		 * @private
		 */
		private function getVector3DByDis($node1:IE3Node, $node2:IE3Node, $dis:Number):Vector3D
		{
			const v1:Vector3D = getVector3DByNode($node1);
			const v2:Vector3D = getVector3DByNode($node2);
			return Vector3DUtil.interpolate(v2, v1, $dis /  Vector3D.distance(v1, v2));
		}
		
		/**
		 * @private
		 */
		private function getVector3DByNode($node:IE3Node):Vector3D
		{
			return new Vector3D($node.nodeX, $node.nodeY, getZByFloorID($node.floorID));
		}
		
		/**
		 * @private
		 */
		private function getLineSpeedByNodes($node1:IE3Node, $node2:IE3Node):Number
		{
			return ($node1.floorID == $node2.floorID) ? speedWalk : speedCros;
		}
		
		
		/**
		 * 获取节点Z坐标。
		 * @private
		 * 
		 * @param $id:String 楼层ID
		 * 
		 * @return Number Z坐标。
		 */
		private function getZByFloorID($id:String):Number
		{
			return zawp ? zawp[$id] + 5 : 5;
		}
		
		
		/**
		 * @private
		 */
		private function handlerTimer($e:TimerEvent):void
		{
			
		}
		
		
		/**
		 * @private
		 */
		private var axis3d:Vector.<Axis3D>;
		
		/**
		 * @private
		 */
		private var points:Vector.<Vector3D>;
		
		/**
		 * 拐角处弧度
		 * @private
		 */
		private var radius:Number = 10;
		
		/**
		 * @private
		 */
		private var speedWalk:Number = 2;
		
		/**
		 * @private
		 */
		private var speedTurn:Number = 1;
		
		/**
		 * @private
		 */
		private var speedCros:Number = 10;
		
		/**
		 * @private
		 */
		private var emap3d:EMap3D;
		
		/**
		 * @private
		 */
		private var container:Object3D;
		
		/**
		 * @private
		 */
		private var wire:WireFrame;
		
		/**
		 * @private
		 */
		private var path:Path;
		
		/**
		 * @private
		 */
		private var timer:Timer;
		
		/**
		 * @private
		 */
		private var zawp:Object;
		
	}
}