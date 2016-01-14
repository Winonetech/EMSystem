package viewer.core
{
	
	import cn.vision.errors.SingleTonError;
	import cn.vision.pattern.core.Command;
	import cn.vision.pattern.core.Presenter;
	import cn.vision.pattern.queue.SequenceQueue;
	
	import com.winonetech.core.View;
	
	import viewer.commands.InitializeDataCommand;
	import viewer.commands.InitializeViewCommand;
	
	
	public final class MVPresenter extends Presenter
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function MVPresenter()
		{
			if(!presenter)
			{
				super();
				initializeEnvironment();
			}
			else throw new SingleTonError(this);
		}
		
		
		/**
		 * 
		 * 执行命令。
		 * 
		 */
		
		public function execute($command:Command):void
		{
			queue.execute($command);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function setup(...parameters):void
		{
			execute(new InitializeDataCommand);
			execute(new InitializeViewCommand);
		}
		
		
		/**
		 * 
		 * 主窗口。
		 * 
		 */
		
		public function get application():View
		{
			return app as View;
		}
		
		
		/**
		 * @private
		 */
		private function initializeEnvironment():void
		{
			queue = new SequenceQueue;
		}
		
		
		/**
		 * @private
		 */
		private var queue:SequenceQueue;
		
		
		/**
		 * 
		 * 单例引用。
		 * 
		 */
		
		public static const presenter:MVPresenter = new MVPresenter;
		
	}
}