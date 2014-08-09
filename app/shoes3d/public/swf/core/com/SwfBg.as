package core.com
{
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	
	
	import core.Main;

	public class SwfBg
	{

		private var main:Main;
		private var swfWidth:Number;
		private var swfHeight:Number;

		public var bgSprite:Sprite = new Sprite();

		public function SwfBg(main:Main,swfWidth:Number,swfHeight:Number)
		{

			this.main = main;
			this.swfWidth = swfWidth;
			this.swfHeight = swfHeight;
			
			var initColor:uint=0x006699;
			var matrix:Matrix=new Matrix();
			matrix.createGradientBox(swfWidth,swfHeight,Math.PI/180*90,0,0);
			bgSprite.graphics.beginGradientFill(GradientType.LINEAR,[initColor,initColor,initColor],[.8,.6,.3],[0,128,255],matrix);
			bgSprite.graphics.drawRect(0,0,swfWidth,swfHeight);
			bgSprite.graphics.endFill();
			main.addChildAt(bgSprite,0);
		}

		public function changeBg(index:int,color:uint):void
		{
			if (index == -1 || index == 0)
			{
				bgSprite.graphics.clear();
				var matrix1:Matrix=new Matrix();
				matrix1.createGradientBox(swfWidth,swfHeight,Math.PI/180*90,0,0);
				bgSprite.graphics.beginGradientFill(GradientType.LINEAR,[color,color,color],[.8,.5,.2],[0,128,255],matrix1);
				bgSprite.graphics.drawRect(0,0,swfWidth,swfHeight);
				bgSprite.graphics.endFill();
				
				main.currentBgIndex=0;
			}
			else if (index==1)
			{
				bgSprite.graphics.clear();
				var matrix2:Matrix=new Matrix();
				matrix2.createGradientBox(swfWidth,swfHeight,Math.PI/180,0,0);
				bgSprite.graphics.beginGradientFill(GradientType.RADIAL,[color,color,color],[.1,.3,.5],[0,128,255],matrix2);
				bgSprite.graphics.drawRect(0,0,swfWidth,swfHeight);
				bgSprite.graphics.endFill();
				
				main.currentBgIndex=1;
			}
			else if (index==2)
			{
				main.currentBgIndex=2;
			}

			
		}




	}

}