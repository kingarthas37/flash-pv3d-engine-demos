package codes{


	import flash.display.*;
	import flash.events.*;

	import org.papervision3d.view.BasicView;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.events.InteractiveScene3DEvent;

	import org.papervision3d.core.math.Quaternion;


	public class test1 extends BasicView {

		private var plane:Plane;
		private var planeTarget:Plane;

		private var slerp:Number=0;
		private var startQ:Quaternion =new Quaternion();
		private var endQ:Quaternion =new Quaternion();
		private var slerpQ:Quaternion=new Quaternion();

		public function test1() {

			viewport.interactive =true;

			var material1:ColorMaterial=new ColorMaterial(0x000000);
			material1.doubleSided=true;
			material1.interactive =true;

			var material2:ColorMaterial =new ColorMaterial(0xff0000);
			material2.doubleSided=true;

			plane=new Plane(material1,200,200);
			planeTarget=new Plane(material2,200,200);
			planeTarget.moveBackward(200);
			plane.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK,planeClickEvent);

			scene.addChild(plane);
			scene.addChild(planeTarget);

			startRendering();

		}
		private function planeClickEvent(e:InteractiveScene3DEvent):void {

			plane.yaw(40);

			slerp=0;
			startQ = Quaternion.createFromMatrix(planeTarget.transform);
			endQ= Quaternion.createFromMatrix(plane.transform);

		}
		override protected function onRenderTick(e:Event=null):void {

			slerp+=(1-slerp)*0.1;
			slerpQ= Quaternion.slerp(startQ,endQ,slerp);
			planeTarget.transform=slerpQ.matrix;

			renderer.renderScene(scene,camera,viewport);

		}
	}
}