package 
{

	import flash.events.Event;
	import flash.events.MouseEvent;


	import org.papervision3d.view.BasicView;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.objects.DisplayObject3D;



	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Plane3D;



	public class test1 extends BasicView
	{

		private var plane3d:Plane3D;

		public function test1()
		{

			super(550,400,true,true);

			camera.z = -1000;
			camera.y = 800;
			camera.lookAt(DisplayObject3D.ZERO);

			var plane:Plane = new Plane(null,100,100);

			scene.addChild(plane);


var plane1:Plane=new Plane(null,1000,1000);

//plane1.pitch(90);
scene.addChild(plane1);

			plane3d = new Plane3D  ;


			stage.addEventListener(MouseEvent.CLICK,stageClickHandler);



			startRendering();


		}

		private function stageClickHandler(event:MouseEvent):void
		{
			
			
			plane3d.setNormalAndPoint(new Number3D(0,0,1),new Number3D(1,1,0)); //0,1,0 为y轴法线向量投射到x,z平面上

			var p1:Number3D = camera.unproject(viewport.containerSprite.mouseX,viewport.containerSprite.mouseY);  //鼠标点击屏幕位置
			var p2:Number3D = new Number3D(camera.x,camera.y,camera.z); //摄像机位置

			p1 = Number3D.add(p1,p2); //转换位3d坐标

			var inters:Number3D = new Number3D();
			inters = plane3d.getIntersectionLineNumbers(p1,p2);  //取得3d交点

			var plane:Plane=new Plane(null,100,100);
			plane.x=inters.x;
			plane.y=inters.y;
			plane.z=inters.z;
			
			scene.addChild(plane);

		}




	}

}