package core.com
{
	import flash.display.Sprite;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import flash.events.Event;

	import flash.filters.DropShadowFilter;

	import com.greensock.*;

	public class ShowTitle
	{
		private var main;
		private var titleLen:uint;
		private var titleTextArr:Array=new Array();
		
		private var titleSpriteArr:Array=new Array();
		private var currentTitle:int;

		private var textFormat:TextFormat = new TextFormat();

		private var titleFilter:DropShadowFilter=new DropShadowFilter();

		public function ShowTitle(m,len,txt){

			main = m;
			titleLen = len;
			titleTextArr = txt;

			textFormat.font = "Arial";
			
			textFormat.leading=4;

			titleFilter.distance = 2;
			titleFilter.strength = 0.3;
			
			for (var i=0; i<titleLen; i++)
			{
				var titleField:TextField=new TextField();
				titleField.htmlText = titleTextArr[i];
				titleField.autoSize = TextFieldAutoSize.LEFT;
				titleField.wordWrap=true;
				titleField.multiline=true;
				titleField.setTextFormat(textFormat);
				titleField.x = 4;
				titleField.y = 4;
				titleField.width=92;

				var lb:Sprite=new titleLeftBorder();
				var mb:Sprite=new titleBg();
				var rb:Sprite=new titleRightBorder();
				var ma:Sprite=new titleArrow();

				var titleSprite:Sprite=new Sprite();

				titleSpriteArr.push(titleSprite);

				titleSprite.addChild(lb);
				titleSprite.addChild(mb);

				titleSprite.addChild(rb);
				titleSprite.addChild(ma);
				
				
				
				mb.y=5;
				mb.height = titleField.height;
				rb.y = lb.height + mb.height;
				
				
				
				
				ma.y = -5;
				ma.x= (titleSprite.width-ma.width)/2;

				titleSprite.addChild(titleField);

				titleSprite.filters = [titleFilter];

				titleSprite.alpha = 0;

			}

		}

		public  function showTitle(i:uint):void
		{
			var titleSprite = titleSpriteArr[i];
			currentTitle = i;

			main.addChild(titleSprite);
			TweenMax.to(titleSprite,.4, {alpha:.9});
			
			main.addEventListener(Event.ENTER_FRAME,titleEnterFrame);
			
		}

		public  function hideTitle(i:uint):void
		{
			var titleSprite = titleSpriteArr[i];
			TweenMax.to(titleSprite,.2, {alpha:0,onComplete:function() { main.removeChild(titleSprite); }});

			main.addEventListener(Event.ENTER_FRAME,titleEnterFrame);
			
		}

		private  function titleEnterFrame(e:Event):void
		{
			titleSpriteArr[currentTitle].x = main.mouseX - titleSpriteArr[currentTitle].width / 2;
			titleSpriteArr[currentTitle].y = main.mouseY +30;
		}

	}



}