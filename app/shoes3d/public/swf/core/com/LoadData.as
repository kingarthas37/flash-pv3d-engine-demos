package core.com {
	
	import flash.display.MovieClip;
	
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.DataLoader;
	import com.greensock.events.LoaderEvent;
	
	import com.adobe.serialization.json.JSON;
	
	import core.Main;
	
	public class LoadData {
		
		private var main:Main;
		private var url:String;
		private var dataURL:String;
		
		private var datas:Object;
		
		public function LoadData(main:Main,url:String,dataURL:String) {
			this.main=main;
			this.url=url;
			this.dataURL=dataURL;
			
			initDatas();
			
		}
		
		private function initDatas():void {
			
			main.addChild(main.loaderMc.mc);
			
			var loader:DataLoader=new DataLoader(url+ dataURL + "/data.html",{name:"king1",onProgress:dataLoadingHandler,onComplete:dataLoadedHandler,onError:dataErrorHandler});
			loader.load();
		}
		
		private function dataLoadingHandler(e:LoaderEvent):void {
			main.loaderMc.loaderText.text="载入数据..."+ Math.round(e.target.progress*100) +"%";
			main.loaderMc.loaderText.setTextFormat(main.loaderMc.format);
		}
		
		private function dataLoadedHandler(e:LoaderEvent):void {
			main.removeChild(main.loaderMc.mc);
			
			main.datas= JSON.decode(e.target.content);
			
			main.initBg();
			main.init3d();
		}
		
		private function dataErrorHandler(e:LoaderEvent):void {
			main.loaderMc.loaderText.text= "加载数据失败!";
			main.loaderMc.loaderText.setTextFormat(main.loaderMc.format);
		}

	}
	
}