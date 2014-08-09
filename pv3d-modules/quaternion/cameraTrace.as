package codes{


	import flash.display.*;
	import flash.events.*;

	import org.papervision3d.view.BasicView;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.events.InteractiveScene3DEvent;

	import gs.TweenMax;
	import gs.easing.Cubic;


	import org.papervision3d.core.math.Quaternion;


	public class test2 extends BasicView {

		private var cameraWithSlerp:CameraWithSlerp = new CameraWithSlerp();

		private var plane:Plane;

		private var cameraStart:DisplayObject3D =new DisplayObject3D();
		private var cameraTarget:DisplayObject3D=new DisplayObject3D();

		private var startQ:Quaternion =new Quaternion();
		private var endQ:Quaternion =new Quaternion();
		private var slerpQ:Quaternion=new Quaternion();

		public function test2() {

			viewport.interactive =true;

			cameraWithSlerp.target = null;
			cameraWithSlerp.slerp = 0;


			var material1:ColorMaterial=new ColorMaterial(0x000000);
			material1.doubleSided=true;
			material1.interactive=true;

			plane=new Plane(material1,200,200);
			plane.y=420;
			plane.x=300;
			plane.yaw(45);


			cameraStart.z=-1000;

			scene.addChild(plane);

			btn1.addEventListener(MouseEvent.CLICK,btn1ClickEvent);
			plane.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK,planeClickEvent);

			singleRender();

		}
		private function planeClickEvent(e:InteractiveScene3DEvent):void {
			
			cameraTarget.copyTransform(Plane(e.target));
			cameraTarget.moveBackward(200);
			
			createTween(cameraTarget);
		}
		private function btn1ClickEvent(e:MouseEvent):void {
			createTween(cameraStart);

		}
		private function createTween(e:DisplayObject3D):void {

			cameraWithSlerp.slerp = 0;

			startQ = Quaternion.createFromMatrix(cameraWithSlerp.transform);
			endQ= Quaternion.createFromMatrix(e.transform);

			TweenMax.to(cameraWithSlerp, 1, {
			x:e.x,
			y:e.y,
			z:e.z,
			slerp:1,
			ease:Cubic.easeInOut,
			onUpdate:camera_updateCallback
			});

		}
		private function camera_updateCallback():void {

			slerpQ= Quaternion.slerp(startQ,endQ,cameraWithSlerp.slerp);
			cameraWithSlerp.transform.copy3x3(slerpQ.matrix);
			singleRender();

		}
		override protected function onRenderTick(e:Event=null):void {

			renderer.renderScene(scene,cameraWithSlerp,viewport);
		}
	}
}


import org.papervision3d.cameras.Camera3D;
class CameraWithSlerp extends Camera3D {

	public var slerp:Number=0;

}