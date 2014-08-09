package core {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
		
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.papervision3d.core.proto.CameraObject3D;
	
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Plane3D;
	
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.parsers.Collada;
	
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.WireframeMaterial;

	import org.papervision3d.events.InteractiveScene3DEvent;
	
	import org.papervision3d.view.layer.ViewportLayer;
	
	import core.com.EventArg;
	import core.com.AssistLine3d;
	
	import flash.filters.DropShadowFilter;
	
	public class Edit3dHandler {
		
		private var main:Main;
		private var main3d:Main3d;
		private var camera:CameraObject3D;
		private var assistLine3d:AssistLine3d;
		
		var model:Collada;
		
		var objTransform:uint;
		private var plane3d:Plane3D =new Plane3D();
		
		//控制obj移动和旋转的参数变量
		private var moveX:Number=0;
		private var moveY:Number=0;
		private var moveZ:Number=0;
		private var rotaX:Number=0;
		private var rotaY:Number=0;
		private var rotaZ:Number=0;
		private var lastX:Number=0;
		private var lastY:Number=0;
		private var currentX:Number;
		private var currentY:Number;
		private var firstMoveX:Boolean;
		private var firstMoveY:Boolean;
		private var isSameObj:Boolean;
		
		private var texture:BitmapData;
		private var selTexture:BitmapData;
		
		private var material:BitmapMaterial;
	    private var selMaterial:BitmapMaterial;
		
		private var object1:DisplayObject3D;
		private var object2:DisplayObject3D;
		private var currentObj:DisplayObject3D;
		
		private var isFirstCopy:Boolean = true; //复制参数
		
		
		public function Edit3dHandler(main:Main,main3d:Main3d,camera:CameraObject3D,assistLine3d:AssistLine3d) {
			this.main=main;
			this.main3d=main3d;
			this.camera=camera;			
			this.assistLine3d=assistLine3d;
		}
		
		function initModel(main):void {
			
			object1= model.getChildByName("object1");
			object2=model.getChildByName("object2");
			
			var layerObj:ViewportLayer= main3d.viewport.getChildLayer(model);
			layerObj.layerIndex=1;
			
			object1.x=0;
			object1.y=0;
			object1.z=0;
			
			object2.x=0;
			object2.y=0;
			object2.z=100;
			
			main3d.viewport.getChildLayer(object1).buttonMode=true;
			main3d.viewport.getChildLayer(object2).buttonMode=true;
			
			var dropFilter:DropShadowFilter =new DropShadowFilter(0,0,0,.3,8,8);
			main3d.viewport.getChildLayer(object1).filters= [dropFilter];
			main3d.viewport.getChildLayer(object2).filters= [dropFilter];
			
			object2.visible=false;
			
			//添加obj侦听
			object1.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS,EventArg.createEvent(objDownHandler,object1));
			object1.addEventListener(InteractiveScene3DEvent.OBJECT_RELEASE,objUpHandler);
			
			object2.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS,EventArg.createEvent(objDownHandler,object2));
			object2.addEventListener(InteractiveScene3DEvent.OBJECT_RELEASE,objUpHandler);
			
			main.swfBg.bgSprite.addEventListener(MouseEvent.MOUSE_UP,swfBgUpHandler);
			main.swfBg.bgSprite.addEventListener(MouseEvent.CLICK,swfBgClickHandler);
		}
		
		function initMaterial(bm:Bitmap):void {
			
			//清空缓存
			if(texture)texture.dispose();
			if(selTexture)selTexture.dispose();
			
			if(material)material=null;
			if(selMaterial)selMaterial=null;
			
			//创建bitmapdata
			texture=new BitmapData(bm.width,bm.height,false);
			texture.draw(bm);
		
			selTexture=new BitmapData(bm.width,bm.height,false);
			selTexture.draw(bm);
			var selt:BitmapData=new BitmapData(bm.width,bm.height,false);
			var rect:Rectangle=new Rectangle(0,0,bm.width,bm.height);
			var point:Point=new Point(0,0);
			selTexture.merge(selt,rect,point,0x80,0x80,0xAA,0x80);
			
			//载入bitmapMaterial
			material = new BitmapMaterial(texture,true);
			material.interactive=true;
			
			selMaterial = new BitmapMaterial(selTexture,true);
			selMaterial.interactive=true;
		  	
			//贴图
			object1.material= material;
			object2.material= material;
			
		}
		
		private function objDownHandler(e:DisplayObject3D):void {
			//trace("obj down");
			
			if(e==currentObj) {
				rotaX=currentObj.rotationX;
			    rotaY=currentObj.rotationY;
			    rotaZ=currentObj.rotationZ;
			}
			else {
				rotaX = (e==object1) ? object1.rotationX : object2.rotationX;
				rotaY = (e==object1) ? object1.rotationY : object2.rotationY;
				rotaZ = (e==object1) ? object1.rotationZ : object2.rotationZ;
			}
			
			currentObj = DisplayObject3D(e);
			
		    object1.material=material;
		    object2.material=material;
		    currentObj.material=selMaterial;
			
			if(objTransform==0) {  //移动动作
			  moveX = moveObjDistance("x") - currentObj.x;
			  moveZ = moveObjDistance("z") - currentObj.z;
			  
			  assistLine3d.layerMoveLine.visible=true;
			  assistLine3d.axisX.material=assistLine3d.mat2;
			  assistLine3d.axisZ.material=assistLine3d.mat2;
			  assistLine3d.axisY.material=assistLine3d.mat1;  
			}
			else if(objTransform==1) {
			  moveY = moveObjDistance("y") - currentObj.y;
			  
			  assistLine3d.layerMoveLine.visible=true;
			  assistLine3d.axisX.material=assistLine3d.mat1;
			  assistLine3d.axisZ.material=assistLine3d.mat1;
			  assistLine3d.axisY.material=assistLine3d.mat2;
			}
			else {  //旋转动作
				
			  currentX=main.mouseX;
			  currentY=main.mouseY;
			  
			  main3d.scene.addChild(assistLine3d.rotaLines);
			  assistLine3d.rotaLines.x=currentObj.x;
			  assistLine3d.rotaLines.y=currentObj.y;
			  assistLine3d.rotaLines.z=currentObj.z;
			  
			  if(objTransform==2) {
					assistLine3d.rotaLines.rotationX=90;
					assistLine3d.rotaLines.rotationY=0;
					assistLine3d.rotaLines.rotationZ=0;
				} 
				else if(objTransform==3) {
					assistLine3d.rotaLines.rotationX=0;
					assistLine3d.rotaLines.rotationY=0;
					assistLine3d.rotaLines.rotationZ=90;
				} 
				else if(objTransform==4) {
					assistLine3d.rotaLines.rotationX=0;
					assistLine3d.rotaLines.rotationY=90;
					assistLine3d.rotaLines.rotationZ=0;
				}
				
				//获取2d坐标
			    currentObj.calculateScreenCoords(main3d.camera); 
				main.textInfo.setObjRotaPosition(currentObj.screen.x+main3d.viewport.width/2,currentObj.screen.y+main3d.viewport.height/2);
			}
			
			main.textInfo.showObjMoveText();
			main.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		
		private function objUpHandler(e:InteractiveScene3DEvent):void {
			//trace("obj up");
			mouseUpHandler();
		}
		
		private function swfBgUpHandler(e:MouseEvent):void {
			//trace("swf up");
			mouseUpHandler();
		}
		
		private function mouseUpHandler():void {
			
			firstMoveX=false;
			firstMoveY=false;
			
			if(objTransform==0 || objTransform==1) {
			    assistLine3d.layerMoveLine.visible=false; 
			}
			else {
				main3d.scene.removeChild(assistLine3d.rotaLines);
			}
			
			main.textInfo.hideObjMoveText();
			main.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
			
		}
		
		private function swfBgClickHandler(e:MouseEvent):void {
			//trace("swf click");
			currentObj=null;
			
			object1.material=material;
			object2.material=material;
		}
		
		private function enterFrameHandler(e:Event):void {
			switch (objTransform) {
				case 0:
				  moveObj(); 
				break;
				case 1:
				  moveObj();
				break;
				case 2:
				  rotationObj();
				break;
				case 3:
				  rotationObj();
				break;
				case 4:
				  rotationObj();
				break;
			}
		}
		
		
		///////////////////移动obj////////////////////////
		
		//获取点击时一次的鼠标当前坐标
		private function moveObjDistance(axis:String):Number {
			plane3d.setNormalAndPoint(numberAxis(),new Number3D(0,0,0));
			
			var p1:Number3D = camera.unproject(main3d.viewport.containerSprite.mouseX,main3d.viewport.containerSprite.mouseY);  //鼠标点击屏幕位置
			var p2:Number3D = new Number3D(camera.x,camera.y,camera.z); //摄像机位置
			
			p1 = Number3D.add(p1,p2);
			
			var inters:Number3D = new Number3D();
			inters = plane3d.getIntersectionLineNumbers(p1,p2);  //取得3d交点
			
			if(objTransform==0) {
			  if(axis=="x") return inters.x;
			  if(axis=="z") return inters.z;
			}
			else{
			  if(axis=="y") return inters.y;
			}
			return 0;
		}
		
		//获取鼠标move坐标
		private function moveObj():void {
			plane3d.setNormalAndPoint(numberAxis(),new Number3D(0,0,0)); //0,1,0 为y轴法线向量投射到x,z平面上

			var p1:Number3D = camera.unproject(main3d.viewport.containerSprite.mouseX,main3d.viewport.containerSprite.mouseY);  //鼠标点击屏幕位置
			var p2:Number3D = new Number3D(camera.x,camera.y,camera.z); //摄像机位置

			p1 = Number3D.add(p1,p2); //转换位3d坐标

			var inters:Number3D = new Number3D();
			inters = plane3d.getIntersectionLineNumbers(p1,p2);  //取得3d交点
			
			if(objTransform==0) {
			  currentObj.x=inters.x - moveX;
			  currentObj.z=inters.z - moveZ;
			}
			else {
			  currentObj.y=inters.y - moveY;   
			}
			
			assistLine3d.moveLines.x=currentObj.x;
			assistLine3d.moveLines.z=currentObj.z;
			assistLine3d.moveLines.y=currentObj.y;
			
			main.textInfo.objMoveInfo(currentObj.x,currentObj.y,currentObj.z);
			
		}
		
		private function numberAxis():Number3D {
			if(objTransform==0) {
				return new Number3D(0,1,0);
			}
			else {
				return new Number3D(0,0,1);
			}
		}
		
		///////////////////旋转obj////////////////////////
		private function rotationObj():void {
		
			var angle:Number=0;
			
			//控制鼠标第一次移动方向x,y
			lastX=main.mouseX;
			lastY=main.mouseY;
			
			if(Math.abs(lastX-currentX)>Math.abs(currentY-lastY) && firstMoveY==false) {
				firstMoveX=true;
				firstMoveY=false;
			}
			if(Math.abs(lastX-currentX)<Math.abs(currentY-lastY) && firstMoveX==false) {
				firstMoveX=false;
				firstMoveY=true;
			}
	
			if(firstMoveX) angle= lastX-currentX;
			if(firstMoveY) angle= currentY-lastY;
			/////////
			
			if (objTransform==2) {
			  currentObj.rotationX = rotaX + angle;
			}
			else if(objTransform==3) {
			  currentObj.rotationY = rotaY + angle;
			}
			else if(objTransform==4) {
			  currentObj.rotationZ = rotaZ + angle;
			}
			
			main.textInfo.objRotaInfo(currentObj.rotationX,currentObj.rotationY,currentObj.rotationZ);
		}
		
		
		function doubleModel():void {
		  object2.visible=true;
		  if(isFirstCopy) {
			  object1.z=-100;
			  object1.rotationX=0;
			  object1.rotationY=0;
			  object1.rotationZ=0;
			  rotaX=0;
			  rotaY=0;
			  rotaZ=0;
			  isFirstCopy=false;
		  }
		}
			
		function singleModel():void {
		  object2.visible=false;
		}
		
		function repositionObj():void {
		  object1.z = object2.visible ? -100:0;
		  object2.z= 100;
		  object1.x = object2.x =  object1.y = object2.y = object1.rotationX=object1.rotationY=object1.rotationZ= object2.rotationX = object2.rotationY = object2.rotationZ;  
		}

	}
}