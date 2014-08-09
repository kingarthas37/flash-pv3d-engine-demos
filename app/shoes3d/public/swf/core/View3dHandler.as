package core {
	
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.parsers.Collada;
	
	import core.com.AssistLine3d;
		
	public class View3dHandler {
		
		private var main:Main;
		private var main3d:Main3d;
		
		private var assistLine3d:AssistLine3d;
		
		var model:Collada;
				
		public function View3dHandler(main:Main,main3d:Main3d,assistLine3d:AssistLine3d) {
			this.main=main;
			this.main3d=main3d;
			this.assistLine3d=assistLine3d;
		}
		
		function playModel():void {
			main3d.view3d.isPlay=true;
		}
		function stopModel():void {
			main3d.view3d.isPlay=false;
		}
		function displayPlane():void {
			main3d.scene.addChild(assistLine3d.planeLines);
		}
		function hidePlane():void {
			main3d.scene.removeChild(assistLine3d.planeLines);
		}
		function colorChange(fileName:String,index:int):void {
			main3d.initTexture(fileName);
			//main.swfBg.changeBg(main.currentBgIndex,main.datas.texture[index].bgcolor);
		}

	}
	
}