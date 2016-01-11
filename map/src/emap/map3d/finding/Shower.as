package emap.map3d.finding
{
	
	/**
	 * 
	 * 路径演示
	 * 
	 */
	
	
	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.objects.WireFrame;
	import alternativa.engine3d.resources.WireGeometry;
	import alternativa.types.Float;
	import alternativa.types.Long;
	
	import cn.vision.utils.ArrayUtil;
	import cn.vision.utils.FontUtil;
	import cn.vision.utils.MathUtil;
	import cn.vision.utils.TimerUtil;
	import cn.vision.utils.Vector3DUtil;
	import cn.vision.utils.math.BezierUtil;
	import cn.vision.utils.math.LineUtil;
	
	import emap.core.em;
	import emap.interfaces.INode;
	import emap.map3d.EMap3D;
	import emap.map3d.comman.Arrow;
	import emap.map3d.interfaces.IE3Node;
	import emap.map3d.tools.SourceEmap3D;
	import emap.map3d.vos.E3VOPosition;
	import emap.vos.VOPosition;
	
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
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
		 * 清空上一次的路径演示。
		 * 
		 */
		
		public function clear():void
		{
			timer.stop();
			while (container.numChildren) container.removeChildAt(0);
			arrow.visible = false;
		}
		
		
		/**
		 * 
		 * 
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
				
				if ($tween)
				{
					count = 0;
					wire = new WireFrame(0xFF0000, 1, 3);
					TimerUtil.callLater(1 * 1000, timer.start);
				}
				else
				{
					wire = WireFrame.createLineStrip(points, 0xFF0000, 1, 1);
				}
				container.addChild(wire);
				container.addChild(arrow);
				SourceEmap3D.uploadAllSources(container);
			}
		}
		
		
		/**
		 * @private
		 */
		private function walk():void
		{
			arrow.visible = true;
			if (count < points.length - 1)
			{
				var geometry:WireGeometry = wire.alternativa3d::geometry;
				var p0:Vector3D = points[count];
				var p1:Vector3D = points[count + 1];
				geometry.alternativa3d::addLine(p0.x, p0.y, p0.z, p1.x, p1.y, p1.z);
				wire.calculateBoundBox();
				var v:Vector3D = p1.subtract(p0);
				v.normalize();
				arrow.x = p1.x;
				arrow.y = p1.y;
				arrow.z = p1.z;
				arrow.rotationX = Math.atan2(v.z, v.y);
				arrow.rotationY = Math.atan2(MathUtil.abs(v.z), MathUtil.abs(v.x));
				arrow.rotationZ = Math.atan2(v.y, v.x);
				
				count ++;
				SourceEmap3D.uploadAllSources(wire);
			}
			else
			{
				timer.stop();
			}
		}
		
		/**
		 * @priva+te
		 */
		private function initialize($emap3d:EMap3D, $container:Object3D):void
		{
			emap3d = $emap3d;
			container = $container;
			
			arrow = new Arrow;
			arrow.visible = false;
			
			points = new Vector.<Vector3D>;
			
			timer = new Timer(33);
			timer.addEventListener(TimerEvent.TIMER, handlerTimer);
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
					points.length = 0;
					var shows:Vector.<IE3Node> = path.shows.concat();
					if(!toEnd && shows.length > 2) shows.pop();
					var i:uint = 0;
					var l:uint = shows.length;
					//遍历所有需要显示的节点
					while (i < l)
					{
						var p:Number = i == 0 ? 0 : radius;
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
		 **/
		private function resolvePointsByRoute($nodes:Vector.<IE3Node>, $flag:uint, $dis:Number = 0):uint
		{
			trace("xxxxxx",checkTipNode(0,$nodes));
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
							ArrayUtil.push(bezier, getVector3DByDis(n2, n1, radius));
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
				}
			}
			return $flag;
		}
		
		
		//
		public static function getText($text:String, $font:String, $color:uint):Sprite
		{  
			//if($font == null) $font = "bold"
			var sprite:Sprite = new Sprite;
			var field:TextField = new TextField;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.antiAliasType = AntiAliasType.ADVANCED;
			field.textColor = $color;
			field.text = $text;
			var temp:TextFormat = getTextFormat($font); 
			if (format!= temp) format = temp;
			field.embedFonts = FontUtil.containsFont(format.font);
			field.setTextFormat(format);
			field.x = -.5 * field.width;
			field.y = -.5 * field.height;
			sprite.addChild(field);
			return sprite;
		}
		private static var format:TextFormat;
		private static const TEXT_FORMATS:Object = {};
		public static function getTextFormat($font:String):TextFormat
		{
			return TEXT_FORMATS[$font] = TEXT_FORMATS[$font] || new TextFormat($font, 20, null, false, null, null, null, null, "left");;
		}	
		/**
		 * @private
		 */
		private function checkTipNode($flag:uint, $nodes:Vector.<IE3Node>):String
		{
			
			var l:uint = $nodes.length;
			if (l)
			{
				var result:String;
				if ($flag == 0)
				{
					if ($flag + 1 < l)
					{
						result = "从当前位置出发，沿" + getDirection($nodes[$flag], $nodes[$flag + 1]) + "方向行走，至" + getNearestPositionName($nodes[$flag + 1]);
						result;
					}
				}
				else if ($flag == $nodes.length - 1)
				{
					
				}
				else
				{
					
				}
			}
			return result;
		}
		
		/**
		 * @private
		 */
		private function getDirection($node1:IE3Node, $node2:IE3Node):String
		{
			var v1:Point = new Point($node1.nodeX, -$node1.nodeY);
			var v2:Point = new Point($node2.nodeX, -$node2.nodeY);
			var v3:Point = v2.subtract(v1);
			var ag:Number = MathUtil.moduloAngle(MathUtil.radianToAngle(Math.atan2(v3.y, v3.x)));
			var it:uint = (ag+22.5)%45==0?(ag+22.5)/45:(ag+67.5)/45;
			return DIRECTIONS[it];
		}
		
		/**
		 * @private
		 */
		private function getNearestPositionName($node:IE3Node):String
		{
			
			
			if(positionArr)
			{
				var label:String = positionArr[0].label;
				
				var min:int = ($node.nodeX-positionArr[0].layout.cenX)^2+($node.nodeY-positionArr[0].layout.cenY);
				for each(var position:E3VOPosition in positionArr)
				{
					
					//计算距离的平方
					var i:int = ($node.nodeX-position.layout.cenX)^2+($node.nodeY-position.layout.cenY);
					if(i<min)
					{
						min = i;
						label = position.label
					}
				}
			}
			return label;
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
				ArrayUtil.unshift($bezier, start, end, p, false);
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
			return Vector3DUtil.interpolate(v2, v1, $dis / Vector3D.distance(v1, v2));
		}
		
		/**
		 * @private
		 */
		private function getVector3DByNode($node:IE3Node):Vector3D
		{
			return new Vector3D($node.nodeX, -$node.nodeY, getZByFloorID($node.floorID));
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
			walk();
		}
		
		
		internal var positionArr:Array;
		
		/**
		 * 
		 * 演示终点。
		 * 
		 */
		
		public var toEnd:Boolean = true;
		
		
		/**
		 * @private
		 */
		private var points:Vector.<Vector3D>;
		
		/**
		 * @private
		 */
		private var count:uint = 0;
		
		/**
		 * 拐角处弧度
		 * @private
		 */
		private var radius:Number = 20;
		
		/**
		 * @private
		 */
		private var speedWalk:Number = 5;
		
		/**
		 * @private
		 */
		private var speedTurn:Number = 1;
		
		/**
		 * @private
		 */
		private var speedCros:Number = 15;
		
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
		private var arrow:Arrow;
		
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

		/**
		 * @private
		 */
		private const DIRECTIONS:Object = {1:"北", 2:"东北", 3:"东", 4:"东南", 5:"南", 6:"西南", 7:"西", 8:"西北",9:"北"};
		
		/**
		 * @private
		 */
		private const TIPS:Dictionary = new Dictionary;
	}
}23