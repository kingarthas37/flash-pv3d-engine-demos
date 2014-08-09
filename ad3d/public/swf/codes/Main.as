package codes{

	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;


	import flash.text.TextField;

	public class Main extends Sprite {

		//定义全局参数
		private var param:Param;
		private var main3d:Main3d;
		
		public var swfWidth:int;
		public var swfHeight:int;
		public var imageCount:int;
		public var imageWidth:int;
		public var imageHeight:int;
		
		public var radius:int;
		public var scrollStyle:String;
		public var cameraPosition:Number;
		public var cameraLocal:String;
		public var objectRotation:Boolean;
		public var userInteraction:String;
		public var mouseScrollSpeed:Number;
		public var wheelScaleAble:Boolean;
		
		public var attrBlur:Boolean;
		public var attrAlpha:Boolean;
		public var attrReflection:Boolean;
		public var attrScale:Boolean;
		public var attrBorder:Boolean;
		public var attrBorderColor:uint;
		public var attrBorderStrong:int;
		public var attrShowTitle:Boolean;
		public var attrTitleText:Array;
		

		public function Main() {

			init();
			
			var p:Object = loaderInfo.parameters;
			param =new Param(p);
			
			
			
			swfWidth=param.swfWidth();
			swfHeight=param.swfHeight();
			imageCount=param.imageCount();
			imageWidth=param.imageWidth();
			imageHeight=param.imageHeight();
			
			radius=param.radius();
			scrollStyle=param.scrollStyle();
			cameraLocal=param.cameraLocal();
			cameraPosition=param.cameraPosition();
			objectRotation=param.objectRotation();
			userInteraction=param.userInteraction();
			mouseScrollSpeed=param.mouseScrollSpeed();
			wheelScaleAble=param.wheelScaleAble();
			
			attrBlur=param.attrBlur();
			attrAlpha=param.attrAlpha();
			attrReflection=param.attrReflection();
			attrScale=param.attrScale();
			attrBorder=param.attrBorder();
			attrBorderColor=param.attrBorderColor();
			attrBorderStrong=param.attrBorderStrong();
			attrShowTitle=param.attrShowTitle();
			attrTitleText=param.attrTitleText();
			
			main3d = new Main3d(this);
			
		}
		private function init():void {
			
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;

			var mainBg:Sprite=new Sprite();
			mainBg.graphics.beginFill(0xffffff);
			mainBg.graphics.drawRect(0,0,400,300);
			mainBg.graphics.endFill();
			//addChildAt(mainBg,0);

		}
	}
}