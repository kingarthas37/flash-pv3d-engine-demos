package core
{
	import org.papervision3d.objects.parsers.Collada;
	import org.papervision3d.events.FileLoadEvent;
	
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.materials.WireframeMaterial;
	

	public class SetModel
	{
		private var main:Main;
		private var main3d:Main3d;
		

		public function SetModel(main:Main,main3d:Main3d)
		{
			this.main = main;
			this.main3d = main3d;
		}

		function loadModel(url:String):void
		{
			main.addChild(main.loaderMc.mc);
			
			var model:Collada = new Collada(url,new MaterialsList({all:new WireframeMaterial(0xffffff,.4)}));
			
			model.addEventListener(FileLoadEvent.LOAD_PROGRESS,DAELoadingHandler);
			model.addEventListener(FileLoadEvent.LOAD_COMPLETE,DAELoadedHandler);
			model.addEventListener(FileLoadEvent.LOAD_ERROR,DAELoadErrorHandler);
		}
		
		private function DAELoadingHandler(e:FileLoadEvent):void {
			main.loaderMc.loaderText.text="载入模型..."+ Math.round(e.bytesLoaded/e.bytesTotal*100) +"%";
			main.loaderMc.loaderText.setTextFormat(main.loaderMc.format);
		}
		
		private function DAELoadedHandler(e:FileLoadEvent):void {
			main.removeChild(main.loaderMc.mc);
			main3d.updateModel(e.target as Collada);
		}
		
		private function DAELoadErrorHandler(e:FileLoadEvent):void {
			main.loaderMc.loaderText.text = "加载文件出错!" + e.message;
			main.loaderMc.loaderText.setTextFormat(main.loaderMc.format);
		}

	}

}