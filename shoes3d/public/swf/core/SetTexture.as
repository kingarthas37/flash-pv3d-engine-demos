package core {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.ImageLoader;
	import com.greensock.events.LoaderEvent;
	
	import org.papervision3d.materials.BitmapMaterial;
	
	public class SetTexture {
		
		private var main:Main;
		private var main3d:Main3d;
		
		
		public function SetTexture(main:Main,main3d:Main3d) {
			this.main = main;
			this.main3d=main3d;
		}
		
		function loadTexture(url:String):void {
			
			main.addChild(main.loaderMc.mc);
			
			var loader:ImageLoader=new ImageLoader(url,{onProgress:textureLoadingHandler,onComplete:textureLoadedHandler,onError:ioErrorHandler});
			loader.load();
		}
		
		private function textureLoadingHandler(e:LoaderEvent):void {
			
			main.loaderMc.loaderText.text="载入图片..."+ Math.round(e.target.progress*100) +"%";
			main.loaderMc.loaderText.setTextFormat(main.loaderMc.format);
		}
		
		private function textureLoadedHandler(e:LoaderEvent):void {
			main.removeChild(main.loaderMc.mc);
			
			var bm:Bitmap = Bitmap(e.target.rawContent);
		
			main3d.updateTexture(bm);
		}
		
		private function ioErrorHandler(e:LoaderEvent):void {
			main.loaderMc.loaderText.text = "加载图片出错!"
			main.loaderMc.loaderText.setTextFormat(main.loaderMc.format);
		}

	}
	
}