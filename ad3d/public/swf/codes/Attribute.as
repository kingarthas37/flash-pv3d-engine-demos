package codes{
	
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Quaternion;

	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import codes.extend.ShowTitle;

	public class Attribute {

		private var main;
		private var viewport;
		private var imageObject;
		private var camera;
		
		private var blurFilterArr:Array=new Array();
		private var glowFilter:GlowFilter;
		
		private var cameraFovCount:int=0;
		
		//创建plane旋转四元数
		private var planeStartQArr:Array=new Array();
		private var planeEndQArr:Array=new Array();
		private var planeSlerpQArr:Array=new Array();
		
		var currentPlane:int=-1;		
		
		public function Attribute(m,view,obj,c) {
			
			main=m;
			viewport=view;
			imageObject = obj;
			camera=c;

			if (main.attrBlur) {
			  for(var i=0;i<main.imageCount;i++) {
				var blurFilter:BlurFilter=new BlurFilter();
				blurFilterArr.push(blurFilter);
				}
			}
			
			if(main.attrBorder) {
				glowFilter=new GlowFilter(main.attrBorderColor,1,main.attrBorderStrong,main.attrBorderStrong,main.attrBorderStrong,1,true);
			}
			
			if(main.attrShowTitle) {
			  ShowTitle.setText(main,main.attrTitleText.length,main.attrTitleText);
			}
			
			
		}
		
		function setQuaternion():void {
			
			var planeStartQ:Quaternion=new Quaternion();
				var planeEndQ:Quaternion=new Quaternion();
				var planeSlerpQ:Quaternion=new Quaternion();

				planeStartQArr.push(planeStartQ);
				planeEndQArr.push(planeEndQ);
				planeSlerpQArr.push(planeSlerpQ);
			
			}
		
		function setRotation1(e):void {  //鼠标旋转
			
			var path:Number= mousePosition();
			
			for (var i=0; i<main.imageCount; i++) {

				var plane= Plane(imageObject.getChildByName("plane"+i));
				var planeTarget = imageObject.getChildByName("planeTarget"+i);
				
				var lastAngle:Number = Math.atan2(planeTarget.x,planeTarget.z)*180/Math.PI;
				var planeTargetAngle:Number = Math.atan2(planeTarget.x,planeTarget.z)*180/Math.PI + path;

				planeTarget.x= Math.sin(planeTargetAngle*Math.PI/180)*main.radius;
				planeTarget.z= Math.cos(planeTargetAngle*Math.PI/180)*main.radius;

				if (main.objectRotation) { 
				  var angle:Number=planeTargetAngle-lastAngle;
				  setObjectRotation(angle,planeTarget);
				}
				
				plane.transform = planeTarget.transform;
				
			}

		}
		
		private function mousePosition():Number {
			  if(main.cameraLocal=="outer"){
					  if(main.scrollStyle=="vertical") {
						    return (main.mouseY - main.swfHeight/2)/(main.radius/3)*main.mouseScrollSpeed; 
						  }else {
							return (main.mouseX - main.swfWidth/2)/(main.radius/3)*main.mouseScrollSpeed; 
				          }
				  } else {
					  if(main.scrollStyle=="vertical") {
						    return -(main.mouseY - main.swfHeight/2)/(main.radius/2)*main.mouseScrollSpeed; 
						  }else {
							return -(main.mouseX - main.swfWidth/2)/(main.radius/2)*main.mouseScrollSpeed; 
					  }
				  }
				
		}
		
		
		
		function setRotation2(path:int):void {  //按钮点击旋转

			for (var i=0; i<main.imageCount; i++) {

				var plane= Plane(imageObject.getChildByName("plane"+i));
				var planeTarget = imageObject.getChildByName("planeTarget"+i);

				var planeTargetAngle:Number = Math.atan2(planeTarget.x,planeTarget.z)*180/Math.PI + path;

				plane.slerp=0;
				planeTarget.x= Math.sin(planeTargetAngle*Math.PI/180)*main.radius;
				planeTarget.z= Math.cos(planeTargetAngle*Math.PI/180)*main.radius;

				
				if (main.objectRotation) { 
			  planeTarget.localRotationY=planeTarget.localRotationY-path;
			 //    setObjectRotation(path,planeTarget);
			    }
				
				planeStartQArr[i]=Quaternion.createFromMatrix(plane.transform);
				planeEndQArr[i]=Quaternion.createFromMatrix(planeTarget.transform);
				
				
				TweenMax.to(plane, 1, {
				  x:planeTarget.x,
				  y:planeTarget.y,
				  z:planeTarget.z,
				  slerp:1,
				  rotationY:plane.rotationY+30,
				  ease:Cubic.easeOut,
				  onUpdateParams :[plane,i,path,planeTargetAngle,planeTarget,planeStartQArr,planeEndQArr],
				  onUpdate:rotation2CallBack
				});

			}
		}
		private function rotation2CallBack(plane,index:int,path:Number,planeTargetAngle:Number,planeTarget,planeStartQArr,planeEndQArr):void {
			//trace(plane.name,plane.rotationY,plane.rotationY);
			//trace(imageObject.getChildByName("plane1").localRotationY);
			
			//planeSlerpQArr[index]=Quaternion.slerp(planeStartQArr[index],planeStartQArr[index],plane.slerp);
			plane.transform.copy3x3(planeSlerpQArr[index].matrix);
			//plane.transform=planeSlerpQArr[index].matrix;
						
		}
		
		private function setObjectRotation(angle:Number,planeTarget):void {
			
			 //旋转方法，此方法可解决旋转过程中放大变换造成的旋转错误
					var axis:Number3D = new Number3D(0, 1, 0);
			        axis.normalize();
 			        var rota:Number = angle*Number3D.toRADIANS;
 			        var rotaMatrix:Matrix3D = Matrix3D.rotationMatrix(axis.x,axis.y,axis.z,rota);
			      
				    planeTarget.transform.calculateMultiply3x3(rotaMatrix, planeTarget.transform);
			
			}
		
		function setAttrScale(plane:Plane,currentPlane:int,scales:Number):void {
			TweenMax.to(plane,.2, {
						scale:scales,
						onUpdate:onScaleUpdate,
						onUpdateParams:[plane]
						});

			if(main.attrReflection) {
				var planeRe:Plane = Plane(imageObject.getChildByName("planeRe"+currentPlane));
				TweenMax.to(planeRe,.2,{
						scale:scales,
						onUpdate:onScaleUpdate,
						onUpdateParams:[planeRe]
				});
			  }
		}
		
		private function onScaleUpdate(plane:Plane):void {
			plane.yaw(0);
		}
		
		function setAttrAlpha0():void {
			for (var i=0; i<main.imageCount; i++) {
				viewport.getChildLayer(imageObject.getChildByName("plane"+i)).alpha=1;
			}
		}
		
		function setAttrAlpha1(cur:int):void {
			for (var i=0; i<main.imageCount; i++) {
				if(cur!=i) {
				  viewport.getChildLayer(imageObject.getChildByName("plane"+i)).alpha=0.5;
				}
			}
		}
		
		function setAttrBlur(e) {
			
			for(var i=0;i<main.imageCount;i++) {
				
			var plane = imageObject.getChildByName("plane"+i);
			
            var depth:Number;
			if(main.cameraLocal=="outer") {
			  depth=(plane.z+main.radius)/main.radius*1.5+1;
			}  else {
			  depth=1-(plane.z-main.radius)/main.radius*1.5;
			}

			blurFilterArr[i].blurX= depth;
			blurFilterArr[i].blurY= depth;
			
			if(currentPlane!=i) {
			  viewport.getChildLayer(plane).filters= [blurFilterArr[i]];
			}
			}
			
		}
		
		function setGlowFilter(plane:Plane,isGlow:Boolean,i:int):void {
		  
          if(isGlow){
			viewport.getChildLayer(plane).filters= [glowFilter];
		  }
		  else {
			  if (main.attrBlur) {
		        viewport.getChildLayer(plane).filters= [blurFilterArr[i]]; }
			  else {
				viewport.getChildLayer(plane).filters= [];
			  }
          }
		  currentPlane= i;
	    }
		
		
		function setAttrReflection(e):void {
			
			for(var i=0;i<main.imageCount;i++) {
			var plane = imageObject.getChildByName("plane"+i);
		    var planeTarget = imageObject.getChildByName("planeTarget"+i);
			var planeRe = imageObject.getChildByName("planeRe"+i);
					
		    planeRe.copyTransform(plane);
			planeRe.pitch(180);
			planeRe.y=-main.imageHeight*plane.scale + plane.y;
					
			if (main.objectRotation) { 
			   // planeRe.transform.calculateMultiply3x3(rotaMatrix, planeRe.transform);
			}
			
			}
						
	    }
		
		function showTitle(i:int):void {
			ShowTitle.showTitle(i,true);
		}
			
		function hideTitle(i:int):void {
			ShowTitle.hideTitle(i,true);
		}

			
		function setCameraFov(count:int):void {
			if (count>0 && cameraFovCount<=5) {
				cameraFovCount+=count;
				CameraFovEvent();
			}
			
			else if (count<0 && cameraFovCount>=-3) {
				cameraFovCount+=count;
				CameraFovEvent();
			}
		}
			
		private function CameraFovEvent():void {
			TweenMax.to(camera,1, {
			  fov: 60+ cameraFovCount*10
		});

		}
		
	}
}