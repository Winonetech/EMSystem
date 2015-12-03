package viewer.commands
{
	
	/**
	 * 
	 * 命令基类，定义了一些常用变量。
	 * 
	 */
	
	import cn.vision.data.Tip;
	import cn.vision.pattern.core.Command;
	
	import com.winonetech.core.Store;
	import com.winonetech.utils.TipUtil;
	
	import viewer.core.MVConfig;
	import viewer.core.MVPresenter;
	import viewer.core.MVView;
	
	
	internal class _InternalCommand extends Command
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function _InternalCommand()
		{
			super();
		}
		
		
		/**
		 * 
		 * 弹出提示框。
		 * 
		 * @param $tip:Tip 提示数据结构。
		 * @param $flags:uint (default = 4) 显示的按钮。
		 * @param $handler:Function (default = null) 按下任意按钮时将调用的事件处理函数。
		 * @param $default:uint (default = 4) 指定默认按钮的位标志。
		 * 
		 */
		
		protected function tip($tip:Tip, $flags:uint = 4, $handler:Function = null, $default:uint = 4):void
		{
			TipUtil.tip($tip, $flags, $handler, $default);
		}
		
		
		/**
		 * 
		 * 核心处理。
		 * 
		 */
		
		protected function get presenter():MVPresenter
		{
			return MVPresenter.presenter;
		}
		
		
		/**
		 * 
		 * 存储管理。
		 * 
		 */
		
		protected function get store():Store
		{
			return Store.instance;
		}
		
		
		/**
		 * 
		 * 视图管理。
		 * 
		 */
		
		protected function get view():MVView
		{
			return MVView.instance;
		}
		
		
		/**
		 * 
		 * 视图管理。
		 * 
		 */
		
		protected function get config():MVConfig
		{
			return MVConfig.instance;
		}
		
	}
}