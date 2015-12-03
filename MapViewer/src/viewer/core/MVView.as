package viewer.core
{
	
	import cn.vision.core.VSObject;
	import cn.vision.errors.SingleTonError;
	
	import spark.components.WindowedApplication;
	
	import viewer.views.MapView;
	import viewer.views.PositionClickView;
	
	
	public final class MVView extends VSObject
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function MVView()
		{
			if(!instance) super();
			else throw new SingleTonError(this);
		}
		
		
		/**
		 * 
		 * 主窗口。
		 * 
		 */
		
		public function get application():WindowedApplication
		{
			return MVPresenter.presenter.application;
		}
		
		
		/**
		 * 
		 * 地图视图。
		 * 
		 */
		
		public var mapView:MapView;
		
		
		/**
		 * 
		 * 位置点击弹出视图。
		 * 
		 */
		
		public var positionClickView:PositionClickView;
		
		
		/**
		 * 
		 * 单例引用。
		 * 
		 */
		
		public static const instance:MVView = new MVView;
		
	}
}