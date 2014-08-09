package core.com  {
	
	import flash.display.Sprite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.math.Number3D;
	
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.core.proto.CameraObject3D;
	
	import com.greensock.TweenLite;
	
	import core.Main;
		
	public class View3d{
		
		private var main:Main;
		private var camera:CameraObject3D;
		private var swfWidth:Number;
		private var swfHeight:Number;
		
		private var isDown:Boolean = false;
		private var currentX:Number=0;
		private var currentY:Number=0;
		private var mousex:Number=0;
		private var mousey:Number=0;
		private var orbitX:Number=0;
		private var orbitY:Number=0;
		
		private var initY:Number=-60;
		private var initX:Number=45;
		
		private var wheelCount:int=0;
		private var wheelArrX:Array=new Array();
		private var wheelArrY:Array=new Array();
		private var wheelArrZ:Array=new Array();
		private var isWheel:Boolean;
		
		private var vPlay:Number=0;  //控制播放旋转
		
		public var isPlay:Boolean=false;  //控制播放
		
		public var viewSprite:Sprite;
		
		
		public function View3d(main:Main,swfWidth:Number,swfHeight:Number,camera:CameraObject3D) {
			
			this.main=main;
			this.swfWidth=swfWidth;
			this.swfHeight=swfHeight;
			this.camera=camera;
			
			camera.orbit(initY,initX,true,DisplayObject3D.ZERO);
	
			initCameraWheel();
			
			viewSprite = new Sprite();
			viewSprite.graphics.beginFill(0x000000,0);
			viewSprite.graphics.drawRect(0,0,swfWidth,swfHeight);
			viewSprite.graphics.endFill();
			
			main.addChildAt(viewSprite,2);
			
			viewSprite.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			viewSprite.addEventListener(MouseEvent.MOUSE_UP,upHandler);
			viewSprite.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			viewSprite.addEventListener(MouseEvent.MOUSE_WHEEL,wheelHandler);
			viewSprite.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		
		private function downHandler(event:MouseEvent):void {
			isDown = true;
			mousey = main.stage.mouseY - currentY;
			mousex = main.stage.mouseX - currentX;
		}
		private function upHandler(event:MouseEvent):void {
			if(isDown) {
				
			  initCameraWheel();
			
			  isDown=false;
			  currentY = main.stage.mouseY - mousey;
			  currentX = main.stage.mouseX - mousex;
			}
		}
		
		private function outHandler(evetn:MouseEvent):void {
			if(isDown) {
			  isDown=false;
			  currentY = main.stage.mouseY - mousey;
			  currentX = main.stage.mouseX - mousex;
			}
		}
		public function wheelHandler(e:MouseEvent):void {
			
			initCameraWheel();
			
			wheelCount+=e.delta/3;
		
			if(wheelCount>=3) {
				wheelCount=2;
				return;
			}
			if(wheelCount<=-3) {
				wheelCount=-2;
				return;
			}
				 
		    TweenLite.to(camera,.5, {
						 x:wheelArrX[wheelCount+2],
						 y:wheelArrY[wheelCount+2],
						 z:wheelArrZ[wheelCount+2],
						 onStart:function() {
							 viewSprite.removeEventListener(MouseEvent.MOUSE_DOWN,downHandler);
							 viewSprite.removeEventListener(MouseEvent.MOUSE_UP,upHandler);
						 },
						 onComplete:function() {
							 viewSprite.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
							 viewSprite.addEventListener(MouseEvent.MOUSE_UP,upHandler);
						 }
			}); 
		}
		
		/*********控制摄像机缩放位置********/
		private function initCameraWheel():void {
			
			var n:Number= 1000-parseInt(Number3D.sub(new Number3D(0,0,0),new Number3D(camera.x,camera.y,camera.z)).modulo.toString());  //获取当前点的距离			
			
			for(var i:int=-2;i<=2;i++)
			{
			  var distance:Number = i*200;
			  
			  var forwardAxis:Number3D = new Number3D(0, 0, 1);
			  Matrix3D.rotateAxis(camera.transform, forwardAxis);

			  var target:Number3D = new Number3D();
			  target.x = (distance - n) * forwardAxis.x + camera.x;
			  target.y = (distance - n) * forwardAxis.y + camera.y;
			  target.z = (distance - n) * forwardAxis.z + camera.z;
				
			  wheelArrX[i+2]=target.x;
			  wheelArrY[i+2]=target.y;
			  wheelArrZ[i+2]=target.z;
			}
		}
		
		private function enterFrameHandler(event:Event):void {
			
			if (isDown) {
				orbitY = main.stage.mouseY - mousey;
				orbitX = -(main.stage.mouseX - mousex);
				if (orbitY<-90) {
					orbitY =-90;
				}
				if (orbitY>89) {
					orbitY =89;
				}
				camera.orbit(orbitY+initY,orbitX+initX + vPlay,true,DisplayObject3D.ZERO);
			}
			
			//play model
			if(isPlay) {
				vPlay ++;
				if (vPlay==360) vPlay=0;
				camera.orbit(orbitY+initY,orbitX+initX + vPlay,true,DisplayObject3D.ZERO);
			}
			
		}

	}
	
}