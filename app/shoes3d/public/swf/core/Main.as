package core {
	
	import flash.display.Sprite;
	import flash.display.MovieClip
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
		
	import core.com.LoaderMc;
	import core.com.TextInfo;
	import core.com.SwfBg;
	import core.com.LoadData;
		
	public class Main extends MovieClip {
		
		private var param:Object;
		
		private var swfWidth:Number;
		private var swfHeight:Number;
		private var url:String;
		private var dataURL:String;
		
		public var datas:Object;
		
		public var swfBg:SwfBg;
		public var currentBgIndex:int=0;
		
		public var loaderMc:MovieClip;
		public var textInfo:TextInfo;
		
		public function Main() {
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			
			
			/*-----------图层分布-----------*/
			// 0: background;
			// 1: viewport3d;
			// 2: viewsprite;
			// 3: button;
			/*-----------图层分布-----------*/
			
			initParams();
			initLoaderMc();
			initDatas();
			initText();
			
		}
		
		private function initParams():void {
			
			param = loaderInfo.parameters;
			
			swfWidth = param["width"]!=null ? param["width"] : 400;
			swfHeight = param["height"]!=null ? param["height"] : 400;
			url = param["url"]!=null ? param["url"] : "http://localhost/demo/";
			dataURL = param["info3d"]!=null ? param["dataURL"] : "data";
		}
		
		public function initBg():void {
			swfBg=new SwfBg(this,swfWidth,swfHeight);
		}
		
		private function initLoaderMc():void {
			loaderMc=new LoaderMc(swfWidth,swfHeight);
		}
		
		private function initText():void {
			textInfo=new TextInfo(this);
		}
		
		private function initDatas():void {
			var loadData:LoadData=new LoadData(this,url,dataURL);
		}
		
		public function init3d():void {
		    var main3d:Main3d=new Main3d(this,swfWidth,swfHeight,url);
		}
	}
	
}