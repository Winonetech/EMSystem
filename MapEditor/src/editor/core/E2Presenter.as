package editor.core
{
	import cn.vision.pattern.core.Command;
	import cn.vision.pattern.core.Presenter;
	import cn.vision.pattern.queue.SequenceQueue;
	
	import editor.command.InitDataCommand;
	import editor.command.InitViewCommand;
	
	import emap.map2d.errors.SingleTonError;
	
	public final class E2Presenter extends Presenter
	{
		public function E2Presenter()
		{
			super();
			if(!instance)
			{
				config = EDConfig.instance;
				quene = new SequenceQueue;
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
			quene.execute($command);
		}
		
		override protected function setup(...parameters):void
		{
			config.editor = app as MapEditor;
			
			execute(new InitDataCommand);
			execute(new InitViewCommand);
		}
		
		/**
		 * @private
		 */
		private var quene:SequenceQueue;
		
		private var config:EDConfig;
		public static const instance :E2Presenter = new E2Presenter;
	}
}