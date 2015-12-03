package editor.command
{
	import cn.vision.pattern.core.Command;
	
	import editor.core.EDConfig;
	
	import emap.consts.StepStyleConsts;
	import emap.map2d.Floor;
	import emap.map2d.Position;
	import emap.map2d.core.E2Config;
	import emap.map2d.core.E2Provider;
	import emap.map2d.util.CountUtil;
	import emap.map2d.vos.E2VOPosition;
	import emap.utils.NodeUtil;
	
	public class AddPositionCommand extends Command
	{
		public function AddPositionCommand()
		{
			super();
		}
		override public function execute():void
		{
			commandStart(); 
			addPosition();
			commandEnd(); 
		}
		public function addPosition():void
		{
			//防止前一个位置还在编辑
			if(EDConfig.instance.selectedPosition)
			{
				EDConfig.instance.e2Config.utilLayer.clear();
				if(EDConfig.instance.e2Config.positionViewMap[EDConfig.instance.selectedPosition.id])
				{
					EDConfig.instance.e2Config.positionViewMap[EDConfig.instance.selectedPosition.id].update(); 
					EDConfig.instance.e2Config.positionViewMap[EDConfig.instance.selectedPosition.id].editStep = false;
					
				}
			}
			//如果选中的楼层不为空就进入编辑状态
			if(EDConfig.instance.selectedFloor)
			{
				//防止新增加楼层并且加的楼层还在编辑状态
				EDConfig.instance.e2Config.utilLayer.clear();
				
				
				EDConfig.instance.e2Config.groundViewMap[EDConfig.instance.selectedFloor.id].update();
				if(EDConfig.instance.e2Config.floorViewMap[EDConfig.instance.selectedFloor.id])
					EDConfig.instance.e2Config.floorViewMap[EDConfig.instance.selectedFloor.id].childVisible = true;
				EDConfig.instance.e2Config.groundViewMap[EDConfig.instance.selectedFloor.id].editSteps = false;
				var voPosition:E2VOPosition = new E2VOPosition();
				//生成新的数据结构初始化数据
				voPosition.id = CountUtil.instance.positionCount+"";
				voPosition.serial = NodeUtil.generateSerial();
				voPosition.positionTypeID = "1"; 
				voPosition.label = "位置"+voPosition.id;
				voPosition.iconScale=1.0;
				voPosition.labelColor = 0xFFFFFF;
				voPosition.color = 0x996666;
				voPosition.thick = 20;
				voPosition.floorID = EDConfig.instance.selectedFloor.id;
				
				EDConfig.instance.positionGroup.addNewPosition(voPosition);
				E2Provider.instance.positionArr.push(voPosition);
				var position:Position = new Position(EDConfig.instance.e2Config,voPosition);
				var floor:Floor = EDConfig.instance.e2Config.floorViewMap[voPosition.floorID];
				floor.addPosition(position);
				EDConfig.instance.e2Config.positionViewMap[voPosition.id] = position;
				EDConfig.instance.e2Config.serialViewMap[voPosition.serial] = position;
				//在位置形状中将状态设置为清空编辑状态
				position.editStep =true;
				
				EDConfig.instance.e2Config.setEditor = true;
				EDConfig.instance.selectedPosition = voPosition;
				//位置图形中 第一个点类型为move_to
				EDConfig.instance.e2Config.editorStyle = StepStyleConsts.MOVE_TO;
				EDConfig.instance.propertyPanel.setCurrentState("position",true);
				EDConfig.instance.propertyPanel.position.position = EDConfig.instance.selectedPosition;
			}
		}
	}
}