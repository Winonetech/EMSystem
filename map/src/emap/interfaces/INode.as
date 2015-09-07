package emap.interfaces
{
	public interface INode
	{
		
		/**
		 * 
		 * 序列号，每个位置或节点的序列号都是唯一的。
		 * 
		 */
		
		function get serial():String;
		
		
		/**
		 * 
		 * X坐标。
		 * 
		 */
		
		function get nodeX():Number;
		
		
		/**
		 * 
		 * Y坐标。
		 * 
		 */
		
		function get nodeY():Number;
		
		//function get pathes():Array;
	}
}