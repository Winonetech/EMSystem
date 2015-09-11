package emap.map2d.errors
{
	
	/**
	 * 
	 * 单例异常。当尝试构造新的单例类时抛出此异常。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public class SingleTonError extends Error
	{
		public function SingleTonError(instance:*)
		{
			super(instance.getClassName()+"is single ton mode!");
		}
	}
}