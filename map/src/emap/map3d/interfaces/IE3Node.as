package emap.map3d.interfaces
{
	
	import cn.vision.collections.Map;
	
	import emap.interfaces.INode;
	
	
	public interface IE3Node extends INode
	{
		
		
		/**
		 * 
		 * 路径集合
		 * 
		 */
		
		function get pathes():Map;
		
	}
}