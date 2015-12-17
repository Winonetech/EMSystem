package editor.command
{
	import editor.core.EDConfig;
	
	import emap.consts.StepStyleConsts;
	import emap.map2d.Floor;
	import emap.map2d.Ground;
	import emap.map2d.core.E2Config;
	import emap.map2d.core.E2Provider;
	import emap.map2d.util.CountUtil;
	import emap.map2d.vos.E2VOFloor;

	public class AddFloorCommand extends _InternalCommand
	{
		public function AddFloorCommand()
		{
			super();
		}
		override public function execute():void
		{
			commandStart();
			addFloor();
			commandEnd();
		}
		public function addFloor():void
		{
			//创建一个新的floor数据
			var voFloor:E2VOFloor = new E2VOFloor;
			//得到floor order
			voFloor.order = CountUtil.instance.floorCount;
			voFloor.id = voFloor.order+"";
			voFloor.color = 0x996666; 
			voFloor.label = "楼层"+voFloor.order;
			E2Provider.instance.floorArr.push(voFloor);
			E2Provider.instance.floorArrC.push(voFloor);
			E2Provider.instance.floorMap[voFloor.id] = voFloor;
			var floor:Floor = new Floor(voFloor,EDConfig.instance.e2Config);
			EDConfig.instance.e2Config.eMap.addViewFloor(voFloor.id,floor);
			//将当前创建的楼层显示在视图上
			EDConfig.instance.e2Config.eMap.viewFloor(voFloor.id);
			EDConfig.instance.floorGroup.addFloor(voFloor);
			EDConfig.instance.selectedFloor = voFloor;
			EDConfig.instance.propertyPanel.floor.floor = EDConfig.instance.selectedFloor;
			EDConfig.instance.e2Config.setEditor = true;
			EDConfig.instance.e2Config.groundViewMap[voFloor.id].editSteps = true;
			EDConfig.instance.e2Config.editorStyle = StepStyleConsts.MOVE_TO;
			//由于路径在复制楼层数组 加入不同楼层的 每次楼层变化都需要改变
			//EDConfig.instance.editor.routeTool.dataProvider = E2Provider.instance.floorArr;
			
		}
		
	}
}