package core
{

	import flash.display.MovieClip;
	import flash.display.Sprite;

	import flash.text.TextField;
	import flash.text.TextFormat;

	import flash.filters.GlowFilter;
	
	import com.greensock.*;
	import com.greensock.easing.*;

	public class Dialog extends Sprite
	{

		private var main:Main;
		private var _data:Object;
		
		private var dialogSprite:MovieClip=new dialog_sprite();

		private var format1:TextFormat = new TextFormat();
		private var format2:TextFormat = new TextFormat();
		private var format3:TextFormat = new TextFormat();
		

		public function Dialog(main,_data)
		{


			this.main = main;
			this._data = _data;

			textFormatInit();
			dialogInit();

		}

		private function textFormatInit():void
		{

			format1.size = 12;
			format1.color = 0xffffff;
			format1.font = "Arial";
			format1.align="left";

			format2.size = 12;
			format2.color = 0x516985;
			format2.font = "Arial";
			format2.align="left";

			format3.size = 12;
			format3.color = 0x87aad3;
			format3.font = "Arial";
			format3.align="left";

		}


		private function dialogInit():void
		{
			dialogSprite.x = -180;
			dialogSprite.y = 15;
			dialogSprite.alpha=.3;
			main.addChild(dialogSprite);

			dialogSprite.username.mouseEnabled = false;
			dialogSprite.username.setTextFormat(format1);
			
			dialogSprite.position.mouseEnabled = false;
			dialogSprite.position.setTextFormat(format3);
			
			dialogSprite.positionimg.width=2;
			dialogSprite.positionimg.filters=[new GlowFilter(0x4f944e,.5,10,10)];

			dialogSprite.age.mouseEnabled = false;
			dialogSprite.age.setTextFormat(format3);

			dialogSprite.constellation.mouseEnabled = false;
			dialogSprite.constellation.setTextFormat(format3);

			dialogSprite.state1.mouseEnabled = false;
			dialogSprite.state1.setTextFormat(format3);
			
			dialogSprite.state2.mouseEnabled = false;
			dialogSprite.state2.setTextFormat(format3);
			
			dialogSprite.state3.mouseEnabled = false;
			dialogSprite.state3.setTextFormat(format3);
			
			dialogSprite.state4.mouseEnabled = false;
			dialogSprite.state4.setTextFormat(format3);
			
			
			dialogSprite.title0.mouseEnabled = false;
			dialogSprite.title0.setTextFormat(format2);
			
			dialogSprite.title1.mouseEnabled = false;
			dialogSprite.title1.setTextFormat(format2);
			
			dialogSprite.title2.mouseEnabled = false;
			dialogSprite.title2.setTextFormat(format3);
			
			dialogSprite.title3.mouseEnabled = false;
			dialogSprite.title3.setTextFormat(format3);
			
			dialogSprite.title4.mouseEnabled = false;
			dialogSprite.title4.setTextFormat(format3);
			
			dialogSprite.title5.mouseEnabled = false;
			dialogSprite.title5.setTextFormat(format3);
			
			dialogSprite.title6.mouseEnabled = false;
			dialogSprite.title6.setTextFormat(format2);

		}
		
		function displayDialog(i:int,isMove:Boolean):void {
			if(isMove) {
				TweenMax.to(dialogSprite, 1.5,{
				  x:10,
				  alpha:1,
				  ease:Expo.easeInOut
				});
			}
			
			setDialogInfo(i);
			
		}

		
		function hideDialog():void {
			TweenMax.to(dialogSprite, 1,{x:-180,alpha:0,ease:Expo.easeInOut});
		}
		
		private function setDialogInfo(i:int):void {
			
			dialogSprite.username.text = _data[i].username;
			dialogSprite.username.setTextFormat(format1);
			
			dialogSprite.position.text = _data[i].position;
			dialogSprite.position.setTextFormat(format3);
			
			TweenMax.to(dialogSprite.positionimg, 1,{width:_data[i].position*1.5+2});
			
			dialogSprite.age.text = _data[i].age;
			dialogSprite.age.setTextFormat(format3);
			
			dialogSprite.constellation.text = _data[i].constellation;
			dialogSprite.constellation.setTextFormat(format3);
			
			dialogSprite.state1.text = _data[i].state1;
			dialogSprite.state1.setTextFormat(format3);
			
			dialogSprite.state2.text = _data[i].state2;
			dialogSprite.state2.setTextFormat(format3);
			
			dialogSprite.state3.text = _data[i].state3;
			dialogSprite.state3.setTextFormat(format3);
			
			dialogSprite.state4.text = _data[i].state4;
			dialogSprite.state4.setTextFormat(format3);
			
			
			
		}

	}

}