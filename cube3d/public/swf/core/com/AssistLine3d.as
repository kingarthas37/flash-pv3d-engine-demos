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
		
		public function AssistLine3d(main3d:Main3d,lineModel:int)
		{
			this.main3d=main3d;
			
			initPlaneLines(lineModel);  //创建平面辅助线
			initMoveLines();  //创建移动辅助线
		}
		
		private function initPlaneLines(lineModel:int):void {
			
			planeLines=new Lines3D();
			
			var lineColor:uint= 0x4e974d;
			var lineAlpha:Number =.5
			var lineBorder:Number=1;
						
			if(lineModel==3) {
			//x
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,0,0),new Vertex3D(999,0,0)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,0,333),new Vertex3D(999,0,333)));
		    planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,0,666),new Vertex3D(999,0,666)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,0,999),new Vertex3D(999,0,999)));
			
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,333,0),new Vertex3D(999,333,0)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,333,999),new Vertex3D(999,333,999)));
			
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,666,0),new Vertex3D(999,666,0)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,666,999),new Vertex3D(999,666,999)));
			
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,999,0),new Vertex3D(999,999,0)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,999,333),new Vertex3D(999,999,333)));
		    planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,999,666),new Vertex3D(999,999,666)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,999,999),new Vertex3D(999,999,999)));
							
			//y
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,0,0),new Vertex3D(0,0,999)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(333,0,0),new Vertex3D(333,0,999)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(666,0,0),new Vertex3D(666,0,999)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(999,0,0),new Vertex3D(999,0,999)));
			
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,333,0),new Vertex3D(0,333,999)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(999,333,0),new Vertex3D(999,333,999)));
			
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,666,0),new Vertex3D(0,666,999)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(999,666,0),new Vertex3D(999,666,999)));
			
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,999,0),new Vertex3D(0,999,999)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(333,999,0),new Vertex3D(333,999,999)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(666,999,0),new Vertex3D(666,999,999)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(999,999,0),new Vertex3D(999,999,999)));
			
			
			//z
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,0,0),new Vertex3D(0,999,0)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,0,333),new Vertex3D(0,999,333)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,0,666),new Vertex3D(0,999,666)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,0,999),new Vertex3D(0,999,999)));
			
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(333,0,0),new Vertex3D(333,999,0)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(333,0,999),new Vertex3D(333,999,999)));
			
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(666,0,0),new Vertex3D(666,999,0)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(666,0,999),new Vertex3D(666,999,999)));
			
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(999,0,0),new Vertex3D(999,999,0)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(999,0,333),new Vertex3D(999,999,333)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(999,0,666),new Vertex3D(999,999,666)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(999,0,999),new Vertex3D(999,999,999)));
			
			}
			
			else if(lineModel==2) {
				
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,0,0),new Vertex3D(999,0,0)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,0,500),new Vertex3D(999,0,500)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,0,999),new Vertex3D(999,0,999)));
			
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,500,0),new Vertex3D(999,500,0)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,500,999),new Vertex3D(999,500,999)));
			
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,999,0),new Vertex3D(999,999,0)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,999,500),new Vertex3D(999,999,500)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,999,999),new Vertex3D(999,999,999)));
//							
//			//y
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,0,0),new Vertex3D(0,0,999)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(500,0,0),new Vertex3D(500,0,999)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(999,0,0),new Vertex3D(999,0,999)));
			
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,500,0),new Vertex3D(0,500,999)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(999,500,0),new Vertex3D(999,500,999)));
			
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,999,0),new Vertex3D(0,999,999)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(500,999,0),new Vertex3D(500,999,999)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(999,999,0),new Vertex3D(999,999,999)));
			
//			
//			//z
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,0,0),new Vertex3D(0,999,0)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,0,500),new Vertex3D(0,999,500)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(0,0,999),new Vertex3D(0,999,999)));
			
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(500,0,0),new Vertex3D(500,999,0)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(500,0,999),new Vertex3D(500,999,999)));
			
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(999,0,0),new Vertex3D(999,999,0)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(999,0,500),new Vertex3D(999,999,500)));
			planeLines.addLine(new Line3D(planeLines,new LineMaterial(lineColor,lineAlpha),lineBorder,new Vertex3D(999,0,999),new Vertex3D(999,999,999)));
				
			}
			
			planeLines.x=-500;
			planeLines.z=-500;
			planeLines.y=-500;
			
			main3d.scene.addChild(planeLines);
		}
		
		private function initMoveLines():void {
			
			moveLines=new Lines3D();
			
			axisX=new Line3D(moveLines,new LineMaterial(0x002fde),3,new Vertex3D(0,0,0),new Vertex3D(1100,0,0));
			axisY=new Line3D(moveLines,new LineMaterial(0x46c719),3,new Vertex3D(0,0,0),new Vertex3D(0,1100,0));
			axisZ=new Line3D(moveLines,new LineMaterial(0xca1111),3,new Vertex3D(0,0,0),new Vertex3D(0,0,1100));
			
			moveLines.addLine(axisX);
			moveLines.addLine(axisY);
			moveLines.addLine(axisZ);
			
			main3d.scene.addChild(moveLines);
			
			moveLines.x=-500;
			moveLines.z=-500;
			moveLines.y=-500;
			
			
		}
			
	}
}