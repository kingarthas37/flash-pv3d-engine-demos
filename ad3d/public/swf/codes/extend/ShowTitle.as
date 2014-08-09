package codes.extend {
	
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import flash.events.Event;
	
	import flash.filters.DropShadowFilter;
	
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	import com.greensock.*;
	
	
	public class ShowTitle{
		
        private static var main;
		private static var titleSpriteArr:Array=new Array();
		private static var currentTitle:int;
		
		public function ShowTitle() {
			
			
			}
			
			
			public static function setText(m,len:int,texts:Array):void {
				
				main=m;
				
				var textFormat:TextFormat = new TextFormat();
			    textFormat.font="Arial";
			    textFormat.color = 0x333333;
				
				var titleFilter:DropShadowFilter=new DropShadowFilter();
				titleFilter.distance=2;
				titleFilter.strength=0.3;
				
				for(var i=0;i<len;i++) {
				
				var titleField:TextField=new TextField();
				titleField.text= texts[i];
				titleField.autoSize = TextFieldAutoSize.LEFT;
				titleField.setTextFormat(textFormat);
				titleField.y=2;
				
				var lb:Sprite=new titleLeftBorder();
				var mb:Sprite=new titleBg();
				var tm:Sprite=new Sprite();
				var rb:Sprite=new titleRightBorder();
				var ma:Sprite=new titleArrow();
				
				
				var titleSprite:Sprite=new Sprite();
				
				titleSpriteArr.push(titleSprite);
				
				titleSprite.addChild(lb);
				titleSprite.addChild(mb);
				
				titleSprite.addChild(rb);
				titleSprite.addChild(ma);
				
				mb.width = titleField.width;
				tm.width 
				mb.x= lb.width;
				rb.x=mb.width+lb.width;
				titleField.x=lb.width;
				ma.y = lb.height;
				ma.x= (titleSprite.width-ma.width)/2;
				
			    titleSprite.addChild(titleField);
				titleSprite.addChild(tm);
				
				tm.graphics.beginFill(0xff0000,0);
				tm.graphics.drawRect(lb.width,0,mb.width,mb.height);
				tm.graphics.endFill();
				
				titleSprite.filters=[titleFilter];
				
				titleSprite.alpha=0;

			}
		}
				
		public static function nowTitle(i:int):Sprite {
			
			return titleSpriteArr[i];
			
		}
		
		public static function showTitle(i:int,playAction:Boolean):void {
			var titleSprite=titleSpriteArr[i];
			currentTitle = i;
			
			main.addChild(titleSprite);
			TweenMax.to(titleSprite,.4, {alpha:.8});
			
			if(playAction) {
				
				main.addEventListener(Event.ENTER_FRAME,titleEnterFrame);
				
				}
			
			}
										
		
		public static function hideTitle(i:int,playAction:Boolean):void {
			var titleSprite=titleSpriteArr[i];
			TweenMax.to(titleSprite,.2, {alpha:0,onComplete:function() { main.removeChild(titleSprite); }});

			if(playAction) {
				
				main.addEventListener(Event.ENTER_FRAME,titleEnterFrame);
				
				}
			
		}
		
		private static function titleEnterFrame(e:Event):void {
			
			titleSpriteArr[currentTitle].x=main.mouseX- titleSpriteArr[currentTitle].width/2;
			titleSpriteArr[currentTitle].y=main.mouseY-titleSpriteArr[currentTitle].height/2-50;
			}
		
		}
	
	
	
	}