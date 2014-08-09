package {
	
	
	import flash.display.*;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	
	
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Plane3D;

	import org.papervision3d.view.BasicView;

	import org.papervision3d.core.math.Quaternion;

	import org.papervision3d.events.InteractiveScene3DEvent;

	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;

	import org.papervision3d.materials.WireframeMaterial;

	import org.papervision3d.materials.ColorMaterial;

	import org.papervision3d.objects.primitives.Sphere;

	
	
	public class main extends BasicView {
		
		
		var plane:Plane=new Plane(new ColorMaterial(0xff0000),200,200);
		
		public function main() {
			
			
			scene.addChild(plane);
			
			stage.addEventListener(MouseEvent.CLICK,addPlane);
			
			camera.y=500;
			camera.lookAt(plane);
			
			
			startRendering();
			
			}
			
			private function addPlane(e:MouseEvent):void {
				
				
	 var intersect:Number3D = getMousePointOnFloor();
	 var plane:Plane=new Plane(new ColorMaterial(0x336699),100,100);
	 scene.addChild(plane);
	 trace(intersect.x,mouseX-200);
	 plane.position = intersect;
				
				}
		
		
		private function getMousePointOnFloor():Number3D {
			
			  var ray:Number3D =  camera.unproject( viewport.containerSprite.mouseX,  viewport.containerSprite.mouseY);  
    
              ray = Number3D.add(ray, camera.position);   
       
              var  plane3D:Plane3D  = Plane3D.fromThreePoints( new Number3D(1,0,0), new Number3D(0,0,0), new Number3D(0,0,1));  
  
              var intersect:Number3D = plane3D.getIntersectionLineNumbers(camera.position, ray);
			  
			  return intersect;
			
			}
		
		}
	
	}