package core.com {
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import core.Main;
	
	public class TextInfo {
		
		private var main:Main;
		
		public var objMoveText:TextField;
		
		private var format1:TextFormat= new TextFormat("Arial",12,0x1b7dbc);
		
		
		public function TextInfo(main:Main) {
			this.main=main;
			initObjMoveInfo();
		}
		
		
		public function objMoveInfo(infoX:Number,infoY:Number,infoZ:Number):void {
			objMoveText.text= "[ " + "x:"+Math.round(infoX)+" y:"+Math.round(infoY)+" z:"+Math.round(infoZ)+" ]";
			objMoveText.setTextFormat(format1);
			objMoveText.x=main.mouseX-10;
			objMoveText.y=main.mouseY-30;
		}
		
		public function setObjRotaPosition(screenX:Number,screenY:Number):void {
			objMoveText.x=screenX;
			objMoveText.y=screenY;
		}
		
		public function objRotaInfo(infoX:Number,infoY:Number,infoZ:Number):void {
			objMoveText.text= "[ " + "x:"+Math.round(infoX)+" y:"+Math.round(infoY)+" z:"+Math.round(infoZ)+" ]";
			objMoveText.setTextFormat(format1);
		}
		
		private function initObjMoveInfo():void {
			objMoveText=new TextField();
			objMoveText.mouseEnabled=false;
			objMoveText.name="objMoveText";
			objMoveText.width=150;
			
		}
		
		public function showObjMoveText():void {
			main.addChild(objMoveText);
		}
		
		public function hideObjMoveText():void {
			if(main.getChildByName("objMoveText"))
			main.removeChild(objMoveText);
		}

	}
	
}