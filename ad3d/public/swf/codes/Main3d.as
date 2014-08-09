package codes{

	import flash.display.MovieClip;
	import flash.display.Sprite;

	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.papervision3d.view.BasicView;

	import org.papervision3d.events.InteractiveScene3DEvent;

	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;

	import org.papervision3d.materials.WireframeMaterial;

	import org.papervision3d.materials.ColorMaterial;

	import org.papervision3d.objects.primitives.Sphere;

	import codes.extend.EventArg;

	public class Main3d extends BasicView {

		private var targetObject:DisplayObject3D=new DisplayObject3D();//复制plane矩阵，控制点击plane移动
		private var imageObject:DisplayObject3D =new DisplayObject3D();//planeObject，关联所有plane

		private var PLANECOUNT:int;
		private var RADIUS:int;
		
		private var initAngle:Number;  //变换角度，用于摄像机初始位置的变换
		
		private var main:Main;
		private var loadData:LoadData;

		private var setAttr:Attribute;
		
		public function Main3d(m) {

			main = m;
			PLANECOUNT=main.imageCount;
			RADIUS= main.radius;

			super(main.swfWidth,main.swfHeight);
			main.addChildAt(viewport,1);
			viewport.interactive = true;
			
			if (main.cameraLocal=="inner") {
				camera.z=0.1;
				initAngle=0;
				camera.lookAt(DisplayObject3D.ZERO);
				
			} else {
				camera.z=-1000;
				initAngle=-180;
				camera.moveUp(cameraPosition(main.scrollStyle));
				camera.lookAt(imageObject);
			}

			if(main.scrollStyle=="vertical") {
				main.attrReflection=false;
				camera.roll(90);
				camera
			}
			

			loadData = new LoadData(main);

			scene.addChild(imageObject);

			setAttr = new Attribute(main,viewport,imageObject,camera);

			for (var i=0; i<PLANECOUNT; i++) {
		
				var plane:PlaneWithSlerp = new PlaneWithSlerp(new WireframeMaterial(0x333333),main.imageWidth,main.imageHeight);

				plane.x= Math.sin(initAngle * Math.PI/180)*RADIUS;
				plane.z= Math.cos(initAngle * Math.PI/180)*RADIUS;
				
				initAngle += 360/PLANECOUNT;

				plane.name= "plane"+i;
				
				if(main.scrollStyle=="vertical") {
				  plane.roll(90);
				}
var planeTarget:DisplayObject3D=new DisplayObject3D();
				//var planeTarget:Plane=new Plane(null,main.imageWidth,main.imageHeight);
				planeTarget.name="planeTarget"+i;

				if (main.objectRotation) {
					if(main.scrollStyle=="vertical") {
				      plane.pitch(360/PLANECOUNT*i);
				    }else {
					  plane.yaw(360/PLANECOUNT*i);
					}
					
				}
				planeTarget.copyTransform(plane);
				
				imageObject.addChild(plane);
				imageObject.addChild(planeTarget);
				
				viewport.getChildLayer(plane).buttonMode= true;

				viewport.getChildLayer(plane).addEventListener(MouseEvent.MOUSE_OVER,EventArg.createMouseEvent(planeMouseOverEvent,plane,i));
				viewport.getChildLayer(plane).addEventListener(MouseEvent.MOUSE_OUT,EventArg.createMouseEvent(planeMouseOutEvent,plane,i));
				viewport.getChildLayer(plane).addEventListener(MouseEvent.CLICK,EventArg.createMouseEvent(planeMouseClickEvent,plane,i));

				loadData.planeArr[i]=plane;

				if(main.attrReflection) {
					var planeRe:Plane=new Plane(new WireframeMaterial(0x333333),main.imageWidth,main.imageHeight);
					planeRe.name="planeRe"+i;
					imageObject.addChild(planeRe);
				    loadData.planeReArr[i]=planeRe;
				}
								
				setAttr.setQuaternion();

			}
			
			main.btn5.addEventListener(MouseEvent.CLICK,btn5Event);
			
			if(main.userInteraction == "mouse") {  //交互方式
			  main.addEventListener(Event.ENTER_FRAME,setAttr.setRotation1);
			}
			else {
			  main.btn1.buttonMode=true;
			  main.btn2.buttonMode=true;
			  main.btn1.addEventListener(MouseEvent.CLICK,btn1Event);
			  main.btn2.addEventListener(MouseEvent.CLICK,btn2Event);
			}
			
			if(main.attrReflection) {
			  main.addEventListener(Event.ENTER_FRAME,setAttr.setAttrReflection);
			}
			
			if (main.attrBlur) {
			  main.addEventListener(Event.ENTER_FRAME,setAttr.setAttrBlur); 
			}

			if(main.wheelScaleAble) {
			  main.stage.addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelEvent);
			}
			
			startRendering();

		}
		private function btn1Event(event:MouseEvent):void {
			setAttr.setRotation2(-360/PLANECOUNT);
		}
		private function btn2Event(event:MouseEvent):void {
			setAttr.setRotation2(360/PLANECOUNT);
		}
		
		private function planeMouseOverEvent(plane:PlaneWithSlerp,currentPlane:int):void {
			
			if(main.attrScale) {
			  setAttr.setAttrScale(plane,currentPlane,1.3);  //缩放(plane,放大1.5倍)
			}

			if (main.attrAlpha) {
			   setAttr.setAttrAlpha1(currentPlane);  //设置透明属性(1)
			}
			
			if(main.attrBorder) {
				setAttr.setGlowFilter(plane,true,currentPlane);  //设置边框属性
			}
			
			if(main.attrShowTitle) {
				setAttr.showTitle(currentPlane);
			}

		}
		private function planeMouseOutEvent(plane:Plane,currentPlane:int):void {
			if(main.attrScale) {
			 setAttr.setAttrScale(plane,currentPlane,1);
			}
			
			if (main.attrAlpha) {
				setAttr.setAttrAlpha0(); 
			}
			
			if(main.attrBorder) {
				setAttr.setGlowFilter(plane,false,currentPlane);
				setAttr.currentPlane= -1;
			}
			
			if(main.attrShowTitle) {
				setAttr.hideTitle(currentPlane);
			}
		}
		private function planeMouseClickEvent(plane:Plane,currentPlane:int):void {


		}
		
		private function mouseWheelEvent(e:MouseEvent):void {
			setAttr.setCameraFov(-e.delta/3);
		}
		
		
		private function btn5Event(event:MouseEvent):void {

			targetObject.copyTransform(camera);
			targetObject.moveBackward(300);

		}

		
		private function cameraPosition(style):Number {
			if(style=="vertical") {
		      return 0;
			}else {
			  return main.cameraPosition;
			}
		}
		
		override protected function onRenderTick(e:Event=null):void {
			
			
			super.onRenderTick();
		}
		
	}
}


import org.papervision3d.objects.primitives.Plane;
class PlaneWithSlerp extends Plane {
	public var slerp:Number=0;//plane插值
	public var scaleSlerp:Number=0;
	public function PlaneWithSlerp(m,w,h) {
		super(m,w,h);
	}
}