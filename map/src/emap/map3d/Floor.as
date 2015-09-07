package emap.map3d
{
	
	/**
	 * 
	 * 二维楼层视图。
	 * 
	 */
	
	
	import alternativa.engine3d.core.Object3D;
	
	import caurina.transitions.Tweener;
	
	import cn.vision.core.UI;
	
	import emap.consts.PositionCodeConsts;
	import emap.core.EMConfig;
	import emap.core.em;
	import emap.data.Layout;
	import emap.interfaces.IFloor;
	import emap.map3d.utils.Map3DUtil;
	import emap.vos.VOFloor;
	
	
	public final class Floor extends Object3D implements IFloor
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function Floor($config:EMConfig, $data:VOFloor = null)
		{
			super();
			
			initialize($config, $data);
		}
		
		
		/**
		 * 
		 * 添加一个Position。
		 * 
		 */
		
		public function addPosition($position:Position):void
		{
			if ($position.code == PositionCodeConsts.PATIO)
			{
				ground.drawHollow($position.steps);
			}
			
			addChild($position);
		}
		
		
		/**
		 * 
		 * 完成添加位置操作。
		 * 
		 */
		
		public function completeSteps():void
		{
			ground.completeSteps();
		}
		
		
		/**
		 * 
		 * 重置。
		 * 
		 */
		
		public function reset():void
		{
			Tweener.removeTweens(this);
			z = 0;
			visible = false;
		}
		
		
		/**
		 * @private
		 */
		private function initialize($config:EMConfig, $data:VOFloor):void
		{
			config = $config;
			
			addChild(ground = new Ground);
			
			mouseEnabled = false;
			
			data = $data;
		}
		
		
		/**
		 * 
		 * 楼层ID。
		 * 
		 */
		
		public function get id():String
		{
			return data ? data.id : null;
		}
		
		
		/**
		 * 
		 * 楼层序号。
		 * 
		 */
		
		public function get order():uint
		{
			return data ? data.order : 0;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get data():VOFloor
		{
			return em::data;
		}
		
		/**
		 * @private
		 */
		public function set data($value:VOFloor):void
		{
			if (data!= $value)
			{
				em::data = $value;
				
				ground.data = data;
			}
		}
		
		
		/**
		 * 
		 * 布局
		 * 
		 */
		
		public function get layout():Layout
		{
			return data ? data.layout : null;
		}
		
		
		/**
		 * @private
		 */
		private var ground:Ground;
		
		/**
		 * @private
		 */
		private var config:EMConfig;
		
		
		/**
		 * @private
		 */
		em var data:VOFloor;
		
	}
}