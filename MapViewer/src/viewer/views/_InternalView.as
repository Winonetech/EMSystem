package viewer.views
{
	
	/**
	 * 
	 * 视图基类。
	 * 
	 */
	
	
	import cn.vision.data.Tip;
	
	import com.winonetech.core.Store;
	import com.winonetech.core.View;
	import com.winonetech.utils.TipUtil;
	
	import viewer.core.MVPresenter;
	
	
	public class _InternalView extends View
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function _InternalView()
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
		 * 存储管理。
		 * 
		 */
		
		protected function get store():Store
		{
			return Store.instance;
		}
		
		
		/**
		 * 
		 * 处理器。
		 * 
		 */
		
		protected function get presenter():MVPresenter
		{
			return MVPresenter.presenter;
		}
		
	}
}