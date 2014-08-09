package core.com
{
	import org.papervision3d.core.geom.Lines3D;
	import org.papervision3d.core.geom.renderables.Line3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	
	import org.papervision3d.objects.DisplayObject3D;

	import org.papervision3d.materials.special.LineMaterial;
	
	import org.papervision3d.view.layer.ViewportLayer;

	import core.Main3d;
	import core.com.Circle3D;
	
	public class AssistLine3d
	{
		private var main3d:Main3d;
		
		public var planeLines:Lines3D;
		
		public var moveLines:Lines3D;
		public var axisX:Line3D;
		public var axisY:Line3D;
		public var axisZ:Line3D;
		public var layerMoveLine:ViewportLayer;
		
		public var rotaLines:DisplayObject3D;
		private var circleX:Circle3D;
		private var circleY:Circle3D;
		private var circleZ:Circle3D;
		private var layerRotaLine:ViewportLayer;
		
		public var mat1:LineMaterial;
		public var mat2:LineMaterial;

		public function AssistLine3d(main3d:Main3d)
		{
			this.main3d=main3d;
			
			initPlaneLines();  //创建平面辅助线
			initMoveLines();  //创建移动辅助线
			initRotaLines();  //创建旋转辅助线
		}
		
		private function initPlaneLines():void {
			
			planeLines=new Lines3D();
			
			for(var i:uint=0;i<11;i++) {
				var lineX:Line3D=new Line3D(planeLines,new LineMaterial(0xffffff,.3),1,new Vertex3D(0,0,i*100),new Vertex3D(1000,0,i*100));
				planeLines.addLine(lineX);
			}
			
			for(var j:uint=0;j<11;j++) {
				var lineZ:Line3D=new Line3D(planeLines,new LineMaterial(0xffffff,.3),1,new Vertex3D(j*100,0,0),new Vertex3D(j*100,0,1000));
				planeLines.addLine(lineZ);
			}
			
			planeLines.x=-500;
			planeLines.z=-500;
			planeLines.y=-100;
			
			main3d.scene.addChild(planeLines);
		}
		
		private function initMoveLines():void {
			
			mat1=new LineMaterial(0xc7c7c7,.7);
			mat2=new LineMaterial(0x1b7dbc,.7);
			
			moveLines=new Lines3D();
			
			axisX=new Line3D(moveLines,mat1,2,new Vertex3D(0,0,0),new Vertex3D(200,0,0));
			axisY=new Line3D(moveLines,mat1,2,new Vertex3D(0,0,0),new Vertex3D(0,200,0));
			axisZ=new Line3D(moveLines,mat1,2,new Vertex3D(0,0,0),new Vertex3D(0,0,200));
			
			moveLines.addLine(axisX);
			moveLines.addLine(axisY);
			moveLines.addLine(axisZ);
			
			main3d.scene.addChild(moveLines);
			
			layerMoveLine = main3d.viewport.getChildLayer(moveLines);
			layerMoveLine.layerIndex=2;
			layerMoveLine.visible=false;
			
		}
			
		private function initRotaLines():void {
			
			rotaLines = new DisplayObject3D();
			
			circleX = new Circle3D(mat1,150,8,1);
			circleY = new Circle3D(mat1,150,8,1);
			circleZ = new Circle3D(mat2,150,8);
			
			circleX.rotationX=90;
			circleY.rotationY=90;
			circleZ.rotationZ=90;
						
			rotaLines.addChild(circleX);
			rotaLines.addChild(circleY);
			rotaLines.addChild(circleZ);
			
			layerRotaLine = main3d.viewport.getChildLayer(rotaLines);
			layerRotaLine.layerIndex=2;
			
		}
	}
}