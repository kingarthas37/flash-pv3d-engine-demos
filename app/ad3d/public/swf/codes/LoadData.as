package codes{

	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.net.URLRequest;

	import flash.events.Event;
	import flash.events.ProgressEvent;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.BitmapFileMaterial;

	import org.papervision3d.materials.ColorMaterial;

	import codes.extend.EventArg;

	public class LoadData {

		private var main:Main;

		private var bitmapFileMaterial:BitmapFileMaterial;

		var planeArr:Array=new Array();
		var planeReArr:Array=new Array();

		private var loadBar:MovieClip;
		
		private var loadCount:int = 0;
		
		private var bitmapDataArr:Array=new Array();

		public function LoadData(m) {
			
			main=m;
			
			loadBar =new LoadBar();
			loadBar.x= (main.swfWidth-loadBar.width)/2;
			loadBar.y= (main.swfHeight-loadBar.height)/2;
			main.addChild(loadBar);
			main.addEventListener(Event.ENTER_FRAME,function() {  loadBar.loadIcon.rotation+=4; });
			
			initObject(0);
			
		}
		
		private function initObject(i:int):void {

			var loader:Loader=new Loader();
			var req:URLRequest =new URLRequest("images/"+ i +".png");
			loader.load(req);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,loadProgress);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,imageLoaded);

		}
		private function loadProgress(event:ProgressEvent):void {
			
			loadBar.loadData.text = (loadCount+1)+"/"+main.imageCount;
		}
		private function imageLoaded(event:Event):void {
			
			try {
				
				
				}
			
			catch(e:Error) {
				
				
				}
			
			var e = event.target.content;
			
			var width:int= main.imageWidth;
			var height:int = main.imageHeight;
				
			var loadbmp:Bitmap = Bitmap(e);
			var bmd:BitmapData =new BitmapData(width,height,true,0);   //创建bitmapData类
			
			var matrix:Matrix=new Matrix();
			matrix.scale(width/e.width,height/e.height);  //设置bmd的尺寸
			
			bmd.draw(loadbmp,matrix);
			
			var bmp:BitmapMaterial = new BitmapMaterial(bmd);
			bmp.doubleSided = true;
		    bmp.precise= true;
			
			
			planeArr[loadCount].material= bmp;
			
			if(main.attrReflection) {
				
				var bmdRe:BitmapData =new BitmapData(width,height,true,0);
				bmdRe.draw(loadbmp,matrix);
				
				var alphaSetp:int=30;   //设置阴影渐变色过渡数
			    for(var i:int=0;i<alphaSetp;i++) {
			      var ct:ColorTransform = new ColorTransform();
			      ct.alphaMultiplier = i/alphaSetp*.2;  //设置渐变阴影值
			      var rect:Rectangle = new Rectangle(0, i*(height/alphaSetp), width, height/alphaSetp);
			      bmdRe.colorTransform(rect, ct);
			}
				
			  var bmpRe:BitmapMaterial = new BitmapMaterial(bmdRe);
				
			  bmpRe.doubleSided = true;
		      bmpRe.precise= true;
			
			  planeReArr[loadCount].material= bmpRe;
			  
			  loadCount ++;
			  if(loadCount < main.imageCount) {
			    initObject(loadCount);
			  }
			  else {
				  main.removeChild(loadBar);
				  main.removeEventListener(ProgressEvent.PROGRESS,loadProgress);
				  main.removeEventListener(Event.COMPLETE,imageLoaded);
			  }
			
			}
		}
	}
}