package flab3d{

	///-flab3d.com-20/11/08,可以简单的鼠标点击拖曳观察物体的类,简单测试中使用//////////////////////////////
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import caurina.transitions.*;
	import org.papervision3d.cameras.FreeCamera3D;
	import org.papervision3d.objects.DisplayObject3D;

	public class mouseDrager extends Sprite {


		private var myCamera:FreeCamera3D;
		private var myOb3d:DisplayObject3D;

		private var mouseDownX:Number;
		private var mouseDownY:Number;
		private var mouseNowX:Number;
		private var mouseNowY:Number;
		private var isMouseDown:Boolean=false;
		///-flab3d.com-20/11/08,可以简单的鼠标点击拖曳观察物体的类,简单测试中使用//////////////////////////////
		///构造需要两个参数，第一个是场景中的FreeCamera,第二个是想要被观察的物体；////////
		//addEventListener(MouseEvent.MOUSE_DOWN,本mouseDrager物体.onMouseClick);
		//addEventListener(MouseEvent.MOUSE_UP,本mouseDrager物体.onMouseClick);
		//addEventListener(MouseEvent.MOUSE_MOVE,本mouseDrager物体.onMouseClick);
		//addEventListener(MouseEvent.MOUSE_OUT,本mouseDrager物体.onMouseClick);
		////////////////////////////需要自己在自己的场景中加入上面的鼠标动作////////////////////////////////////
		////////最后需要在enterframe里面加入 本mouseDrager物体.process();///////////////////////////////////////

		public function mouseDrager(mCamera:FreeCamera3D=null,ob3d:DisplayObject3D=null):void {
			myCamera=mCamera;
			myOb3d=ob3d;
			myCamera.y=hMin;
		}
		private var zz:Number=1200;
		private var hMin:Number=10;
		private var hMax:Number=900;
		private var due:int=2;

		public function process():void {
			if (myCamera.y<hMin) {
				myCamera.y=hMin;
			}
			else if (myCamera.y>hMax) {
				myCamera.y=hMax;
			}
			myCamera.z=zz-myCamera.y*(hMax/zz);
			myCamera.lookAt(myOb3d);
		}
		public function onMouseClick(evt:MouseEvent):void {
			if (evt.type=="mouseDown") {
				isMouseDown=true;
				mouseDownX=mouseX;
				mouseDownY=mouseY;
			}
			if (evt.type=="mouseUp") {
				isMouseDown=false;
			}
			if (evt.type=="mouseOut") {
				isMouseDown=false;
			}
			if (evt.type=="mouseMove") {
				mouseNowX=mouseX;
				mouseNowY=mouseY;
				if (isMouseDown) {
					Tweener.addTween(myOb3d,{rotationY:myOb3d.rotationY+(mouseDownX-mouseNowX), time:due, delay:0});
				}
				if (isMouseDown) {
					Tweener.addTween(myCamera,{y:myCamera.y-(mouseDownY-mouseNowY)*10, time:due, delay:0});
				}
			}

		}
	}
}
///-flab3d.com-20/11/08,可以简单的鼠标点击拖曳观察物体的类,简单测试中使用//////////////////////////////