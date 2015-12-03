package editor.managers
{
	import cn.vision.collections.Map;
	
	import flash.filesystem.File;

	public final class ImageManager
	{
		/**
		 * 
		 **/
		public static function registImage($url:String,$fold:String):String
		{
			var file1:File = new File($url);
			var ary:Array = $url.split(".");
			var name:String = ary[ary.length-1];
			/**
			 * 创建文件夹 使用时间作为图片名字
			 **/
			var _rootExportDir:File = new File(File.applicationDirectory.resolvePath($fold).nativePath);
			if(_rootExportDir.exists == false)
				_rootExportDir.createDirectory();
			var url:String =  File.applicationDirectory.resolvePath($fold).nativePath;
			name = "/"+getTime()+"."+name
			url = url+name;
			var file2:File = new File(File.applicationDirectory.resolvePath(url).nativePath);
			file1.copyTo(file2,true);
			return ($fold+name);
		}
		//删除图片
		public static function removeImage($url:String):void
		{
			if($url!=null && ($url!=""))
			{
				var file:File = new File(File.applicationDirectory.resolvePath($url).nativePath);
				if(file.exists)
					file.deleteFile();
			}  
		}
		/**
		 * 得到系统时间
		 **/
		private static function getTime():String
		{
			var date:Date = new Date();
			var time:String = ""+date.date + date.hours + date.minutes + date.seconds + date.milliseconds;
			return time;
		}
		
	}

	
}