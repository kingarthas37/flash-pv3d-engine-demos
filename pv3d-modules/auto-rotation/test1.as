package {
	import flash.display.*;
	import flash.events.*;

	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.cameras.Camera3D;

	import org.papervision3d.objects.parsers.DAE;

	public class test1 extends Sprite {

		private var viewport:Viewport3D = new Viewport3D(400,400);
		private var renderer:BasicRenderEngine = new BasicRenderEngine();
		private var scene:Scene3D = new Scene3D();
		private var camera:Camera3D = new Camera3D();

		/* copy */
		private var isDown:Boolean = false;
		private var currentx:Number=0;
		private var currenty:Number=0;
		private var mousex:Number=0;
		private var mousey:Number=0;
		private var orbitx:Number=0;
		private var orbity:Number=0;
		/* copy */


		private var dae:DAE = new DAE();

		public function test1() {
			addChild(viewport);
			dae.load("max/11.DAE");
			scene.addChild(dae);

			/* copy */
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onStageMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL,stageWheelEvent);
			/* copy */

			addEventListener(Event.ENTER_FRAME,process);
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
		public function process(event:Event):void {
			/* copy */
			if (isDown) {
				orbity = stage.mouseY - mousey;
				orbitx = -(stage.mouseX - mousex);
				if (orbity<-90) {
					orbity =-90;
				}
				if (orbity>89) {
					orbity =89;
				}
				camera.orbit(orbity-60,orbitx+180,true,dae);  /*orbity为camera的高度，orbitx为水平，初始时需要调整数值*/
				/* copy */

			}
			renderer.renderScene(scene,camera,viewport);


		}
	}
}