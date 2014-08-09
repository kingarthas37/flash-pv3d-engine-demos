package as3{

	import flash.display.*;

	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.TextField;

	import flash.utils.getTimer;


	import gs.*;
	import gs.easing.*;

	import flab3d.*;
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.cameras.Camera3D;

	import org.papervision3d.objects.parsers.Collada;
	import org.papervision3d.objects.DisplayObject3D;

	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.events.InteractiveScene3DEvent;

	import org.papervision3d.lights.PointLight3D;

	import org.papervision3d.view.layer.ViewportLayer;

	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.materials.shaders.PhongShader;
	import org.papervision3d.materials.shaders.ShadedMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.materials.WireframeMaterial;

	import org.papervision3d.materials.ColorMaterial;


	import org.papervision3d.objects.primitives.Sphere;

	public class main extends Sprite {

		private var isDown:Boolean = false;
		private var onMenu:Boolean = false;


		private var currentx:Number=0;
		private var currenty:Number=0;
		private var mousex:Number=0;
		private var mousey:Number=0;
		private var orbitx:Number=0;
		private var orbity:Number=0;
		private var wheelroll:int = 10;
		private var objImg:String = "img1";
		private var displayMode:String = "standard";

		private var camerascalearr:Array = [1000];
		private var endArray:Array = new Array();
		private var camerazoomin:Boolean = false;
		private var camerazoomout:Boolean = false;
		private var cameraenabled:Boolean = true;

		private var autorotation:Boolean = false;
		private var autorotationx:Number = 0;

		private var displaylight:Boolean = true;

		private var displaymovie:Boolean = false;

		private var displayFpsBar:Boolean = false;
		private var iBar:MovieClip;


		/*fpsBar*/

		var time :Number;
		var frameTime :Number;
		var prevFrameTime :Number = getTimer();
		var secondTime :Number;
		var prevSecondTime :Number = getTimer();
		var frames :Number = 0;
		var fps :String = "...";

		/*fpsBar*/


		private var mc_screen:MovieClip = new MC_Screen();

		private var menu_text:TextField;
		private var screen_text:TextField;
		private var btn1:SimpleButton;
		private var btn2:SimpleButton;
		private var btn3:SimpleButton;
		private var btn4:SimpleButton;
		private var btn5:SimpleButton;
		private var btn6:SimpleButton;
		private var btn7:SimpleButton;
		private var btn8:SimpleButton;
		private var btn9:SimpleButton;
		private var btn10:SimpleButton;
		private var btn_menuview:SimpleButton;

		private var bitmapdata:BitmapData = new img1(512,256);
		private var texture1:BitmapData = new img1(512,256);
		private var texture2:BitmapData = new img2(512,256);


		private var viewport:Viewport3D = new Viewport3D(400,400);
		private var renderer:BasicRenderEngine = new BasicRenderEngine();
		private var scene:Scene3D = new Scene3D();
		private var camera:FlabCamera3D = new FlabCamera3D();
		private var obj:Collada;

		private var light:PointLight3D = new PointLight3D();

		private var shader:PhongShader;
		private var shaded:ShadedMaterial;
		private var wirer:WireframeMaterial = new WireframeMaterial(0xffffff,100);

		private var wheel:DisplayObject3D;
		private var box1:DisplayObject3D;
		private var box2:DisplayObject3D;
		private var screen:DisplayObject3D;
		private var moviescreen:DisplayObject3D;
		private var mouse:DisplayObject3D;
		private var keyboard:DisplayObject3D;


		private var mm:MovieMaterial;
		private var material:MaterialsList;

		private var layer1:ViewportLayer;
		private var layer2:ViewportLayer;

		public function main():void {

			init();
			init3d();

			loaderInfo.addEventListener(ProgressEvent.PROGRESS,loadprogress);
			loaderInfo.addEventListener(Event.COMPLETE,eventcomplete);
			addEventListener(Event.ENTER_FRAME,process);

		}
		public function init():void {

			menu_text = menu.getChildByName("menu_text") as TextField;
			screen_text = mc_screen.getChildByName("screen_text") as TextField;

			iBar = fpsBar.getChildByName("iBar") as MovieClip;

			btn1 = menu.getChildByName("btn1") as SimpleButton;
			btn2 = menu.getChildByName("btn2") as SimpleButton;
			btn3 = menu.getChildByName("btn3") as SimpleButton;
			btn4 = menu.getChildByName("btn4") as SimpleButton;
			btn5 = menu.getChildByName("btn5") as SimpleButton;
			btn6 = menu.getChildByName("btn6") as SimpleButton;
			btn7 = menu.getChildByName("btn7") as SimpleButton;
			btn8 = menu.getChildByName("btn8") as SimpleButton;
			btn9 = menu.getChildByName("btn9") as SimpleButton;
			btn10 = menu.getChildByName("btn10") as SimpleButton;
			btn_menuview = menu.getChildByName("btn_menuview") as SimpleButton;//menu显示赢藏控制

			menu_text.text="载入中...";

			stage.addEventListener(MouseEvent.MOUSE_DOWN,onStageMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL,stageWheelEvent);


			b1.addEventListener(MouseEvent.MOUSE_OVER,b1onMouseOver);
			b2.addEventListener(MouseEvent.MOUSE_OVER,b2onMouseOver);
			b3.addEventListener(MouseEvent.MOUSE_OVER,b3onMouseOver);

			b1.addEventListener(MouseEvent.MOUSE_OUT,b1onMouseOut);
			b2.addEventListener(MouseEvent.MOUSE_OUT,b2onMouseOut);
			b3.addEventListener(MouseEvent.MOUSE_OUT,b3onMouseOut);

			btn_menuview.addEventListener(MouseEvent.CLICK,btn_menuviewClick);

			btn1.addEventListener(MouseEvent.MOUSE_OVER,btn1MouseOver);
			btn1.addEventListener(MouseEvent.CLICK,btn1Click);

			btn2.addEventListener(MouseEvent.MOUSE_OVER,btn2MouseOver);
			btn2.addEventListener(MouseEvent.CLICK,btn2Click);

			btn3.addEventListener(MouseEvent.MOUSE_OVER,btn3MouseOver);
			btn3.addEventListener(MouseEvent.CLICK,btn3Click);

			btn4.addEventListener(MouseEvent.MOUSE_OVER,btn4MouseOver);
			btn4.addEventListener(MouseEvent.CLICK,btn4Click);

			btn5.addEventListener(MouseEvent.MOUSE_OVER,btn5MouseOver);
			btn5.addEventListener(MouseEvent.CLICK,btn5Click);

			btn6.addEventListener(MouseEvent.MOUSE_OVER,btn6MouseOver);
			btn6.addEventListener(MouseEvent.CLICK,btn6Click);

			btn7.addEventListener(MouseEvent.MOUSE_OVER,btn7MouseOver);
			btn7.addEventListener(MouseEvent.CLICK,btn7Click);

			btn8.addEventListener(MouseEvent.MOUSE_OVER,btn8MouseOver);
			btn8.addEventListener(MouseEvent.CLICK,btn8Click);

			btn9.addEventListener(MouseEvent.MOUSE_OVER,btn9MouseOver);
			btn9.addEventListener(MouseEvent.CLICK,btn9Click);

			btn10.addEventListener(MouseEvent.MOUSE_OVER,btn10MouseOver);
			btn10.addEventListener(MouseEvent.CLICK,btn10Click);



		}
		public function loadprogress(event:ProgressEvent):void {
			menu_text.text="正在加载..."+Math.round(event.bytesLoaded/event.bytesTotal*100) +"%";

		}
		public function eventcomplete(event:Event):void {
			menu_text.text = "载入文件成功.";

		}
		public function init3d():void {

			addChildAt(viewport,1);
			viewport.interactive = true;

			camera.moveBackward(20000);

			light.moveUp(5000);
			light.moveRight(5000);
			scene.addChild(light);

			mm=new MovieMaterial(mc_screen,true,true);
			mm.smooth = true;

			shader = new PhongShader(light,0xffffff,0x7d7d7d,100);
			shaded = new ShadedMaterial(new BitmapMaterial(bitmapdata),shader);
			shaded.interactive = true;
			material = new MaterialsList({all:shaded});

			obj = new Collada("max/notebook.DAE",material);
			//obj = new Collada("http://www.sjchess.org/3d/max/notebook.txt",material);

			obj.addEventListener(FileLoadEvent.LOAD_COMPLETE,onDAELoaded);

		}
		private function btn_menuviewClick(event:MouseEvent):void {
			if (menu.y == 340) {
				btn_menuview.rotation  =0;
				TweenLite.to(menu, .5, {y:375,ease:Expo.easeInOut});
				TweenMax.to(menu, 1, {dropShadowFilter:{color:0x000000, alpha:0}});

			} else if (menu.y == 375) {
				btn_menuview.rotation  =180;
				TweenLite.to(menu, .5, {y:340,ease:Expo.easeInOut});
				TweenMax.to(menu, 1, {dropShadowFilter:{color:0x000000, alpha:0.5, blurX:5, blurY:5, angle:0, distance:0}});
			}
		}
		private function onStageMouseDown(event:MouseEvent):void {

			isDown = true;

			mousey = stage.mouseY - currenty;
			mousex = stage.mouseX - currentx;


		}
		private function onStageMouseUp(event:MouseEvent):void {


			isDown = false;
			currenty = stage.mouseY - mousey;
			currentx = stage.mouseX - mousex;

		}
		public function stageWheelEvent(event:MouseEvent):void {

			if (event.delta>0) {
				camera.moveForward(event.delta*50);
			} else {
				camera.moveForward(event.delta*50);
			}
		}
		public function b1onMouseOver(event:MouseEvent):void {

			menu_text.text = "拖动鼠标可旋转3D物体";
			b1.buttonMode= true;
			TweenMax.to(b1, .2, {glowFilter:{color:0xffffff, alpha:1, blurX:10, blurY:10}});
		}
		public function b2onMouseOver(event:MouseEvent):void {
			menu_text.text = "滚动滚轴键可缩放3D物体";
			b2.buttonMode= true;
			TweenMax.to(b2, .2, {glowFilter:{color:0xffffff, alpha:1, blurX:10, blurY:10}});
		}
		public function b3onMouseOver(event:MouseEvent):void {
			menu_text.text = "点击3D物体部件可显示相关信息";
			b3.buttonMode= true;
			TweenMax.to(b3, .2, {glowFilter:{color:0xffffff, alpha:1, blurX:10, blurY:10}});
		}
		public function b1onMouseOut(event:MouseEvent):void {

			TweenMax.to(b1, .2, {glowFilter:{alpha:0}});
		}
		public function b2onMouseOut(event:MouseEvent):void {

			TweenMax.to(b2, .2, {glowFilter:{alpha:0}});
		}
		public function b3onMouseOut(event:MouseEvent):void {

			TweenMax.to(b3, .2, {glowFilter:{alpha:0}});
		}
		public function onDAELoaded(event:FileLoadEvent):void {

			TweenLite.to(menu, 0.5, {y:340,ease:Expo.easeInOut});
			TweenMax.to(menu, 1, {dropShadowFilter:{color:0x000000, alpha:0.5, blurX:5, blurY:5}});
			menu_text.text = "载入模型成功";

			scene.addChild(obj);
			camera.orbit(-60,180,true,obj);


			wheel = obj.getChildByName("wheel");
			box1 = obj.getChildByName("box1");
			box2 = wheel.getChildByName("box2");
			screen = box2.getChildByName("screen");
			moviescreen = box2.getChildByName("moviescreen");
			mouse = obj.getChildByName("mouse");
			keyboard = obj.getChildByName("keyboard");


			moviescreen.visible = false;
			layer1 = viewport.getChildLayer(box1);
			layer2 = viewport.getChildLayer(wheel);

			viewport.getChildLayer(mouse).buttonMode=true;
			viewport.getChildLayer(keyboard).buttonMode=true;
			viewport.getChildLayer(wheel).buttonMode = true;

			mouse.addEventListener(InteractiveScene3DEvent.OBJECT_OVER,mouse_over);
			mouse.addEventListener(InteractiveScene3DEvent.OBJECT_OUT,mouse_out);
			mouse.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS,mouse_click);

			keyboard.addEventListener(InteractiveScene3DEvent.OBJECT_OVER,keyboard_over);
			keyboard.addEventListener(InteractiveScene3DEvent.OBJECT_OUT,keyboard_out);
			keyboard.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS,keyboard_click);

		}
		public function mouse_over(event:InteractiveScene3DEvent):void {

			TweenMax.to(viewport.getChildLayer(mouse), .5, {autoAlpha:0.8});
		}
		public function mouse_out(event:InteractiveScene3DEvent):void {

			TweenMax.to(viewport.getChildLayer(mouse), .5, {autoAlpha:1});
		}
		public function mouse_click(event:InteractiveScene3DEvent):void {

			screen_text.text = "You pressd Mouse!";
			menu_text.text = "你点击了鼠标";

		}

		public function keyboard_over(event:InteractiveScene3DEvent):void {
			TweenMax.to(viewport.getChildLayer(keyboard), .5, {autoAlpha:0.8});
		}
		public function keyboard_out(event:InteractiveScene3DEvent):void {
			TweenMax.to(viewport.getChildLayer(keyboard), .5, {autoAlpha:1});
		}
		public function keyboard_click(event:InteractiveScene3DEvent):void {

			screen_text.text = "You pressd KeyBoard!";
			menu_text.text = "你点击了键盘";

		}
		public function process(event:Event):void {

			if (isDown) {

				orbity = stage.mouseY - mousey;

				orbitx = -(stage.mouseX - mousex);

				if (orbity<-90) {
					orbity =-90;
				}
				if (orbity>89) {
					orbity =89;
				}
				camera.orbit(orbity-60,orbitx+180+autorotationx,true,obj);

			}
			if (camerazoomin) {
				if (camerascalearr[0] !=0) {
					camera.moveForward(camerascalearr[0]);
				} else {
					camerazoomin= false;
					camerascalearr[0]=1000;
					cameraenabled = true;
				}
			}
			if (camerazoomout) {
				if (camerascalearr[0] !=0) {
					camera.moveBackward(camerascalearr[0]);
				} else {
					camerazoomout= false;
					camerascalearr[0]=1000;
					cameraenabled = true;
				}
			}
			if (autorotation) {
				autorotationx ++;
				if (autorotationx==360) {
					autorotationx=0;
				}
				camera.orbit((orbity - 60),(orbitx+180+autorotationx),true,obj);

			}
			if (displayFpsBar) {

				time = getTimer();

				frameTime = time - prevFrameTime;
				secondTime = time - prevSecondTime;

				if (secondTime >= 1000) {
					fps = frames.toString();
					frames = 0;
					prevSecondTime = time;
				} else {
					frames++;
				}
				prevFrameTime = time;
				menu_text.text = ((fps + " FPS / ") + frameTime) + " MS";
				iBar.y = 200-frameTime*1.8;

				//iBar.scaleX = iBar.scaleX - ((iBar.scaleX - (frameTime /10)) / 5);

			}
			renderer.renderScene(scene,camera,viewport);

		}
		public function btn1MouseOver(event:MouseEvent):void {

			menu_text.text = "变换材质";
		}
		public function btn1Click(event:MouseEvent):void {

			if (objImg == "img1") {
				bitmapdata.draw(texture2);
				objImg = "img2";

			} else if (objImg == "img2") {
				bitmapdata.draw(texture1);
				objImg = "img1";

			}
		}
		public function btn2MouseOver(event:MouseEvent):void {

			menu_text.text = "变换显示模式";

		}
		public function btn2Click(event:MouseEvent):void {

			if (displayMode == "standard") {
				obj.setChildMaterial(wheel,wirer);
				obj.setChildMaterial(box1,wirer);
				obj.setChildMaterial(box2,wirer);
				obj.setChildMaterial(screen,wirer);
				obj.setChildMaterial(moviescreen,wirer);
				obj.setChildMaterial(mouse,wirer);
				obj.setChildMaterial(keyboard,wirer);
				displayMode= "wire";

			} else if (displayMode == "wire") {

				obj.setChildMaterial(wheel,shaded);
				obj.setChildMaterial(box1,shaded);
				obj.setChildMaterial(box2,shaded);
				obj.setChildMaterial(screen,shaded);
				moviescreen.visible = false;
				screen.visible = true;
				displaymovie = false;
				obj.setChildMaterial(mouse,shaded);
				obj.setChildMaterial(keyboard,shaded);

				displayMode = "standard";
			}
		}
		public function btn3MouseOver(event:MouseEvent):void {

			menu_text.text = "显示屏向下翻转";
		}
		public function btn3Click(event:MouseEvent):void {

			if (wheel.rotationZ > -15 ) {
				wheelroll -=10;
				TweenLite.to(wheel, 1, {rotationZ:wheelroll});
			}
		}
		public function btn4MouseOver(event:MouseEvent):void {

			menu_text.text = "显示屏向上翻转";
		}
		public function btn4Click(event:MouseEvent):void {


			if (wheel.rotationZ < 45 ) {
				wheelroll += 10;
				TweenLite.to(wheel, 1, {rotationZ:wheelroll});
			}
		}
		public function btn5MouseOver(event:MouseEvent):void {

			menu_text.text = "放大视角";
		}
		public function btn5Click(event:MouseEvent):void {
			if (cameraenabled) {
				TweenLite.to(camerascalearr, 1, {endArray:[0],ease:Expo.easeInOut});
				camerazoomin = true;
				cameraenabled = false;
			}

		}
		public function btn6MouseOver(event:MouseEvent):void {

			menu_text.text = "缩小视角";
		}
		public function btn6Click(event:MouseEvent):void {
			if (cameraenabled) {
				TweenLite.to(camerascalearr, 1, {endArray:[0],ease:Expo.easeInOut});
				camerazoomout = true;
				cameraenabled = false;
			}

		}
		public function btn7MouseOver(event:MouseEvent):void {

			menu_text.text = "开启/关闭自动旋转";
		}
		public function btn7Click(event:MouseEvent):void {
			if (autorotation == false) {
				autorotation = true;
			} else {
				autorotation = false;
			}
		}
		public function btn8MouseOver(event:MouseEvent):void {

			menu_text.text = "显示/隐藏光源";
		}
		public function btn8Click(event:MouseEvent):void {
			if (displaylight == false) {
				light.moveUp(5000);
				light.moveRight(5000);
				displaylight= true;
			} else {
				light.moveDown(5000);
				light.moveLeft(5000);
				displaylight=false;
			}
		}
		public function btn9MouseOver(event:MouseEvent):void {

			menu_text.text = "开机启动";
		}
		public function btn9Click(event:MouseEvent):void {

			if (displayMode == "standard") {

				if (displaymovie) {

					moviescreen.visible = false;
					screen.visible = true;

					obj.setChildMaterial(moviescreen,shaded);
					mc_screen.gotoAndStop(1);

					displaymovie = false;
				} else {


					moviescreen.visible = true;
					screen.visible = false;

					obj.setChildMaterial(moviescreen,mm);
					mc_screen.gotoAndPlay(2);

					displaymovie = true;
				}
			}
		}
		public function btn10MouseOver(event:MouseEvent):void {

			menu_text.text = "显示帧速和CPU占用率";
		}
		public function btn10Click(event:MouseEvent):void {
			if (displayFpsBar) {
				TweenLite.to(fpsBar, .5, {x:400,ease:Expo.easeInOut});
				displayFpsBar = false;
			} else {

				TweenLite.to(fpsBar, .5, {x:385,ease:Expo.easeInOut});
				displayFpsBar = true;
			}

		}
	}
}