package {import flash.display.BitmapData;
 import flash.events.Event;
 import flash.events.MouseEvent;
 import flash.geom.Point;
 
 import org.papervision3d.core.geom.renderables.Vertex3D;
 import org.papervision3d.core.math.Number3D;
 import org.papervision3d.core.math.Plane3D;
 import org.papervision3d.core.proto.MaterialObject3D;
 import org.papervision3d.events.InteractiveScene3DEvent;
 import org.papervision3d.lights.PointLight3D;
 import org.papervision3d.materials.BitmapMaterial;
 import org.papervision3d.objects.primitives.Plane;
 import org.papervision3d.view.BasicView;
 
 public class test1 extends BasicView
 {
  private const NUM_PLANES:int = 11;
 
  private var planeToDragOn:Plane3D;
  private var currentPlane:Plane;
 
  private var light:PointLight3D;
 
  public function test1()
  {
   super(550,400,true,true);
 
   camera.y = 100;
 
   for(var i:int = 0; i < NUM_PLANES; i++)
   {
    var material:MaterialObject3D = createMaterial();
    material.interactive = true;
    
    material.doubleSided = true;
    var plane:Plane = new Plane(material, 100, 100, 4, 4);
    plane.x = (i - NUM_PLANES/2) * 200;
 
    scene.addChild(plane);
    plane.lookAt(camera);
 
    plane.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, objectPressHandler);
    stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
   }
 
   var up:Number3D = new Number3D(0, 1, 0);
   planeToDragOn = new Plane3D(up, new Number3D(0,0,0));
 
   startRendering();  
  }
 
  private function createMaterial():MaterialObject3D
  {
   var bitmapData:BitmapData = new BitmapData(300, 200, false, Math.random() * 0xffffff);
   var bitmapBorder:BitmapData = new BitmapData(320, 220, false, 0x336699);
 
   bitmapBorder.copyPixels(bitmapData, bitmapData.rect, new Point(10, 10));
 
   var bitmapMaterial:BitmapMaterial = new BitmapMaterial(bitmapBorder, true);
   bitmapMaterial.smooth = true;
 
   return bitmapMaterial;
  }
 
  private function objectPressHandler(event:InteractiveScene3DEvent):void
  {
   currentPlane = event.displayObject3D as Plane;
  }
 
  private function mouseUpHandler(event:MouseEvent):void
  {
   currentPlane = null;
  }
 
  override protected function onRenderTick(event:Event=null):void
  {
   var ray:Number3D = camera.unproject(viewport.containerSprite.mouseX, viewport.containerSprite.mouseY);
   ray = Number3D.add(ray, camera.position);
 
   var cameraVertex3D:Vertex3D = new Vertex3D(camera.x, camera.y, camera.z);
   var rayVertex3D:Vertex3D = new Vertex3D(ray.x, ray.y, ray.z);
 
   var intersectPoint:Vertex3D = planeToDragOn.getIntersectionLine(cameraVertex3D, rayVertex3D);
 
   if(currentPlane)
   {
    currentPlane.x = intersectPoint.x;
    currentPlane.y = intersectPoint.y;
    currentPlane.z = intersectPoint.z;
    currentPlane.lookAt(camera);
   }
 
   renderer.renderScene(scene, camera, viewport);
  }
 }
 
}
