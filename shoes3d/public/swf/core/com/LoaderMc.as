package core.com {
	
	import flash.display.MovieClip;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class LoaderMc extends MovieClip{
		
	   public var mc:MovieClip;
	   public var loaderText:TextField;
	   public var format:TextFormat;

		public function LoaderMc(swfWidth:Number,swfHeight:Number) {
			
			mc = new loader_mc();
			
			format=new TextFormat("Arial",12,0xffffff);
			
			loaderText=new TextField();
			loaderText.x=33;
			loaderText.y=9;
			loaderText.alpha=.8;
			loaderText.mouseEnabled=false;
			loaderText.text="载入中...";
			loaderText.setTextFormat(format);
			
			mc.addChild(loaderText);
			
			mc.y=swfHeight/2-10;
			mc.x=(swfWidth-mc.width)/2+10;
		}
		
	}
	
}
