package emap.map3d.finding
{
	
	/**
	 * 
	 * 网格
	 * 
	 */
	
	
	import cn.vision.collections.Map;
	import cn.vision.utils.ArrayUtil;
	
	import emap.core.em;
	import emap.map3d.interfaces.IE3Node;
	import emap.map3d.vos.E3VORoute;
	import emap.utils.RouteUtil;
	
	
	public final class Keywork extends Network
	{
		
		/**
		 * 
		 * 构造函数
		 * 
		 */
		
		public function Keywork($floors:Map = null)
		{
			super();
			
			initialize($floors);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function find($node1:IE3Node, $node2:IE3Node):Path
		{
			if ($node1 && $node2)
			{
				var key:String = RouteUtil.getKey(start, end);
				if(!pathes[key])
				{
					setup($node1, $node2);
					//此处寻到的节点并不是最终的节点数组，而是关键点数组，需要将省略的节点加入
					var tempNodes:Vector.<IE3Node> = findPath();
					var pathNodes:Vector.<IE3Node> = new Vector.<IE3Node>;
					var l:int = tempNodes.length - 1;
					var i:uint = 0;
					//加入省略的节点
					while (i < l)
					{
						var prev:IE3Node = tempNodes[i];
						var next:IE3Node = tempNodes[i + 1];
						ArrayUtil.push(pathNodes, prev);
						var idx:String = RouteUtil.getKey(prev, next);
						//检测是否有直接路径通向下一节点，若没有，则加入省略的节点
						if(!prev.routes[idx])
						{
							var path:Path = prev.pathes[idx];
							var n:int = path.nodes.length - 1;
							var j:uint = 1;
							while (j < n) 
							{
								ArrayUtil.push(pathNodes, path.nodes[j]);
								j++;
							}
						}
						i++;
					}
					ArrayUtil.push(pathNodes, tempNodes[l]);
					pathes[key] = new Path(pathNodes, start, end);
				}
			}
			return pathes[key];
		}
		
		
		/**
		 * @private
		 */
		private function findPath($node:IE3Node = null, $path:Vector.<IE3Node> = null):Vector.<IE3Node>
		{
			$node = $node || start;
			$path = $path || new Vector.<IE3Node>;
			if(!finded)
			{
				finded = $node == end;
				ArrayUtil.push($path, $node);
				if (!finded)
				{
					var neighbors:Vector.<IE3Node> = findNeighbors($node);
					if (neighbors && neighbors.length)
						for each (var neighbor:IE3Node in neighbors) findPath(neighbor, $path);
					else
						$path.pop();
				}
			}
			return $path;
		}
		
		/**
		 * @private
		 */
		private function findNeighbors($node:IE3Node):Vector.<IE3Node>
		{
			//首先寻找有直接route关联的关键点，这类节点包含电梯，楼梯，手扶梯在另外一层对应的关键点
			for each (var route:E3VORoute in $node.routes)
			{
				other = route.getAnotherNode($node) as IE3Node;
				if(other && !ergodic[other.serial] && nodes[other.serial])
				{
					ergodic[other.serial] = other;
					temp = temp || new Vector.<IE3Node>;
					ArrayUtil.push(temp, other);
				}
			}
			
			//其次寻找有路径可达的关键点，这类包含同层的关键点
			for each (var path:Path in $node.pathes)
			{
				var other:IE3Node = path.end;
				if(!ergodic[other.serial] && nodes[other.serial])
				{
					ergodic[other.serial] = other;
					var temp:Vector.<IE3Node> = temp || new Vector.<IE3Node>;
					ArrayUtil.push(temp, other);
				}
			}
			return temp;
		}
		
		/**
		 * @private
		 */
		private function initialize($floors:Map):void
		{
			floors = $floors;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function setup($node1:IE3Node, $node2:IE3Node):void
		{
			ergodic.clear();
			pathes.clear();
			finded = false;
			for each (var key:IE3Node in nodes) key.pathes.clear();
			if (start && end)
			{
				delete nodes[start.serial];
				delete nodes[end  .serial];
			}
			
			
			start = $node1;
			end   = $node2;
			ergodic[start.serial] = start;
			//起始点与终止点加入关键点网格
			nodes[start.serial] = start;
			nodes[end  .serial] = end;
			//建立路径关联网
			for each (key in nodes)
			{
				for each (var nod:IE3Node in nodes)
				{
					if (nod != key && 
						nod != start && 
						key != end && 
						key.floorID == nod.floorID && 
						floors[key.floorID])
					{
						var path:Path = floors[key.floorID].find(key, nod);
						if(!path.block)
						{
							pathes[path.key] = path;
							key.pathes[path.key] = path;
						}
					}
				}
			}
		}
		
		
		/**
		 * @private
		 */
		private var floors:Map;
		
	}
}