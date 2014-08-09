package core
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;

	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flash.net.navigateToURL;
	import flash.net.URLRequest;

	import org.papervision3d.view.BasicView;

	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	
	import org.papervision3d.core.geom.Lines3D;
	import org.papervision3d.core.geom.renderables.Line3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	
	import org.papervision3d.materials.special.LineMaterial;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.special.LineMaterial;

	import org.papervision3d.events.InteractiveScene3DEvent;
	
	import org.papervision3d.core.math.Quaternion;

	import com.greensock.*;
	import com.greensock.easing.*;

	import core.com.Circle3D;
	import core.com.EventArg;
	import core.com.ShowTitle;
	


	public class Main3d extends BasicView
	{
		private var main:Main;
		
		private var swfWidth:int;
		private var swfHeight:int;
		
		private var _param:Object=new Object(); //json param
		private var _data:Array=new Array(); //json data
		
		private var images:Array=new Array();  //图片组
		private var imagesHover:Array=new Array();//图片高亮组
		private var imagesRe:Array=new Array();  //图片反射组

		private var planeObj:DisplayObject3D = new DisplayObject3D();//头像组
		private var planeReObj:DisplayObject3D = new DisplayObject3D();//头像反射组
		

		private var showTitle:ShowTitle;//显示title
		
		private var speedObj:Object = new Object();//图片旋转
		
		private var zoomStep:int=5; //camera 滚动step
		private var cameraFovCount:int=-3; //camera滚动镜头 
		
		private var planeLines:Lines3D; //连接图片line
		private var planeLine:Line3D;
		
		//路径和引力值
		private var pathObj:DisplayObject3D=new DisplayObject3D();//路径组
		private var pathLightArr:Array=new Array(); //path透明度
		private var pathPosArr:Array=new Array(); //path pos值
		
		private var pathTipObj:Sprite=new Sprite(); //tip obj
		private var tipFormat:TextFormat; 
		private var tipFormatLight:TextFormat;
		
		
		
		//摄像机移动参数		
		private var isCameraMove:Boolean=false; //摄像机拉近plane 判断
		private var isCameraFirstMove:Boolean=true; //控制摄像机当前位置
		
		private var cameraSlerp:CameraSlerp=new CameraSlerp();
		private var cameraStart:DisplayObject3D =new DisplayObject3D();
		private var cameraTarget:DisplayObject3D=new DisplayObject3D();
		
		private var cameraStartQ:Quaternion =new Quaternion();
		private var cameraEndQ:Quaternion =new Quaternion();
		private var cameraSlerpQ:Quaternion=new Quaternion();
		
		private var dialog:Dialog;
		
		private var btnBack:SimpleButton=new btn_back();
		
		private var planeClick:int=-1;
	
		
		public function Main3d(main,swfWidth,swfHeight,_param,_data,images,imagesHover,imagesRe)
		{
			this.main = main;
			this.swfWidth = swfWidth;
			this.swfHeight = swfHeight;
			this._param = _param;
			this._data = _data;
			this.images = images;
			this.imagesHover= imagesHover;
			this.imagesRe = imagesRe;
			
			super(swfWidth,swfHeight,true,true);
		 	main.addChild(viewport);
			
			init(); //初始化
			setCameraInit();//初始camera
			setPathInit();//初始轨迹
			setImageInit();//初始图片
			setTitleInit();//设置提示信息
			setSpeedInit(); //设置初始旋转速度
			setPlaneLine();//初始planeLine
			setDialogInfo(); //创建dialog
			
			startRendering();//渲染

		}
		
		private function init():void {

		  btnBack.x= (swfWidth-13)/2;
		  btnBack.y= (swfHeight + 30);
		  btnBack.alpha=0;
		  btnBack.addEventListener(MouseEvent.CLICK,cameraRestoreHandler);
		  main.addChild(btnBack);  
		  
		
		  var tipInfo:MovieClip=new tip_info();
		  tipInfo.x=swfWidth;
		  tipInfo.y=10;
		  tipInfo.alpha=0;
		  tipInfo.tipText.mouseEnabled=false;
		  tipInfo.tipText.text= "可使用鼠标滚轴缩放视角";
		  main.addChild(tipInfo);
		  TweenMax.to(tipInfo,1,{x:swfWidth-170,alpha:.8,ease:Expo.easeInOut});
		  
		}

		private function setCameraInit():void
		{
			cameraSlerp.y = _param.camera.y+30;
			cameraSlerp.z = -_param.camera.z-500;
			
			TweenMax.to(cameraSlerp,1.5, {
							  y:_param.camera.y - 3*(_param.camera.y/zoomStep) + 30,
							  z:-_param.camera.z + 3*(_param.camera.z/zoomStep)-500,
							  onUpdate:function() { cameraSlerp.lookAt(DisplayObject3D.ZERO); },
							  onComplete:function() { 
							    main.stage.addEventListener(MouseEvent.MOUSE_WHEEL,setCameraFovHandler);    
							  }
							});
			
			TweenMax.to(main.getChildByName("cosmoBg"),1.5,{
							  width: swfWidth*1.1 + 3*(swfWidth*.1)/zoomStep,   
							  height: swfHeight*1.1 + 3*(swfHeight*.1)/zoomStep
							});
			
		}

		private function setPathInit():void
		{
			pathLightArr= [0.2,0.3,0.4,0.5,0.6,0.7]; 
			pathPosArr = [00,20,40,60,80,99];
			
			
			main.addChildAt(pathTipObj,2); //添加pathTip容器
			
			tipFormat=new TextFormat();
			tipFormat.color= 0x333333;
			tipFormat.align ="center";
			tipFormat.font = "Arial";
			tipFormat.size = 11;
			tipFormat.bold=false;
			
			tipFormatLight=new TextFormat();
			tipFormatLight.color= 0x000000;
			tipFormatLight.align ="center";
			tipFormatLight.font = "Arial";
			tipFormatLight.size = 11;
			tipFormatLight.bold=true;
			
			for (var i=0; i<=5; i++)
			{
				//创建path
				var circle:Circle3D = new Circle3D(new LineMaterial(0x788acb),200 * (i+1),12,1);//distance:1200
				circle.name = "path"+(5-i);
				pathObj.addChild(circle);
				viewport.getChildLayer(circle).alpha = pathLightArr[5-i];
				
				//创建tipObj
				var tipObj:DisplayObject3D =new DisplayObject3D();
				tipObj.x = Math.sin(150*Math.PI/180) * (200 * (i+1));
				tipObj.z = Math.cos(150*Math.PI/180) * (200 * (i+1));
				tipObj.calculateScreenCoords(cameraSlerp); 
				tipObj.autoCalcScreenCoords=true;
				scene.addChild(tipObj);
				
				//设置tip文本
				var tipText:TextField =new TextField();
				tipText.mouseEnabled=false;
				tipText.name = "tipText"+(5-i);
				tipText.width=20;
				tipText.height=20;
				tipText.x=-10;
				tipText.y=-23;
				tipText.text= pathPosArr[5-i].toString();
				tipText.setTextFormat(tipFormat);
				
				//创建pathTip(movieclip)
				var pathTip:MovieClip =new path_tip();
				pathTip.addChild(tipText);
				pathTip.name= "tip"+(5-i);
				pathTip.alpha=.7;
				pathTip.buttonMode=true;
				pathTipObj.addChild(pathTip);
				
				addEventListener(Event.ENTER_FRAME,EventArg.createEvent(pathTipHandler,tipObj,pathTip,i));
				
			}
		}
		
		private function pathTipHandler(tipObj:DisplayObject3D,pathTip:MovieClip,i:int):void {
			
			pathTip.x= tipObj.screen.x + viewport.width/2;
			pathTip.y= tipObj.screen.y + viewport.height/2;
			
		}

		private function setImageInit():void
		{
			for (var i:int=0; i<_data.length; i++)
			{
				var bmp:BitmapMaterial = new BitmapMaterial(images[i],true);
				var bmpHover:BitmapMaterial =new BitmapMaterial(imagesHover[i],true);

				var plane:Plane = new Plane(bmp,_data[i].width,_data[i].height);
				
				plane.name = "plane" + i;
				plane.x = Math.sin((Math.random()*360)*Math.PI/180) * getRadius(_data[i].position);//计算plane坐标
				plane.z = Math.cos((Math.random()*360)*Math.PI/180) * getRadius(_data[i].position);
				plane.y = _data[i].height / 2 ;
				viewport.getChildLayer(plane).buttonMode = true;
				viewport.getChildLayer(plane).addEventListener(MouseEvent.MOUSE_OVER,EventArg.createEvent(planeOverHandler,plane,i,bmpHover));
				viewport.getChildLayer(plane).addEventListener(MouseEvent.MOUSE_OUT,EventArg.createEvent(planeOutHandler,plane,i,bmp));
				viewport.getChildLayer(plane).addEventListener(MouseEvent.CLICK,EventArg.createEvent(planeClickHandler,plane,i));
				planeObj.addChild(plane);

				var bmpRe:BitmapMaterial = new BitmapMaterial(imagesRe[i],true);
				var planeRe:Plane = new Plane(bmpRe,_data[i].width,_data[i].height);
				planeRe.name = "planeRe" + i;
				planeRe.copyTransform(plane);
				planeRe.moveDown(_data[i].height );
				planeReObj.addChild(planeRe);
				
			}
			
			scene.addChild(planeReObj);
			scene.addChild(pathObj);
			scene.addChild(planeObj);

			main.stage.addEventListener(Event.ENTER_FRAME,planeRotation);
		}

		private function setTitleInit():void
		{

			var titleTextArr:Array=new Array();

			for (var i:uint=0; i<_data.length; i++)
			{
				titleTextArr.push(_data[i].title);
			}

			showTitle = new ShowTitle(main,_data.length,titleTextArr);
		}
		
		private function setSpeedInit():void {
			 speedObj.speed= _param.speed; 
		}
		
		private function setPlaneLine():void {
			
			planeLines=new Lines3D();
			planeLine=new Line3D(planeLines,new LineMaterial(0x4e974d),2,new Vertex3D(),new Vertex3D());
			
			scene.addChild(planeLines);
		}
		

		


		private function planeRotation(event:Event):void
		{
			for (var i:uint=0; i<_data.length; i++)
			{
				var plane = planeObj.getChildByName("plane" + i);
				var planeRe = planeReObj.getChildByName("planeRe" + i);

				plane.x = Math.sin((Math.atan2(plane.x,plane.z)*180/Math.PI + speedObj.speed)*Math.PI/180) * getRadius(_data[i].position);
				plane.z = Math.cos((Math.atan2(plane.x,plane.z)*180/Math.PI + speedObj.speed)*Math.PI/180) * getRadius(_data[i].position);

				planeRe.x = plane.x;
				planeRe.z = plane.z;
				
			}
		}

		private function planeOverHandler(plane:Plane,i:uint,bmp:BitmapMaterial):void
		{
			TweenMax.to(speedObj, 2, {speed:0});
			
			showTitle.showTitle(i);
			
			plane.material=bmp;
			
			planeLines.addLine(planeLine);
			addEventListener(Event.ENTER_FRAME,EventArg.createEvent(planeFrameHandler,plane));
			
			setPathLight(i,true);
			
		}

		private function planeOutHandler(plane:Plane,i:uint,bmp:BitmapMaterial):void
		{
			TweenMax.to(speedObj, 1, {speed:_param.speed});
			showTitle.hideTitle(i);
			plane.material=bmp;
			
			planeLines.removeLine(planeLine);
			removeEventListener(Event.ENTER_FRAME,planeFrameHandler);
			
			setPathLight(i,false);
			
		}
		
		private function planeClickHandler(plane:Plane,i:uint):void {
			
			//camera移动时需要删除的事件和隐藏的obj
			main.stage.removeEventListener(Event.ENTER_FRAME,planeRotation);
			main.stage.removeEventListener(MouseEvent.MOUSE_WHEEL,setCameraFovHandler);
			pathTipObj.alpha=0;
			for(var l:int=0;l<_data.length;l++) {
		      viewport.getChildLayer(Plane(planeObj.getChildByName("plane"+l))).alpha= l==i ? 1:.3;
			}
			//
			
			if(planeClick==i) navigateToURL(new URLRequest(_data[i].url),"_blank");
			planeClick=i;
			
			isCameraMove = true;
			
			if(isCameraFirstMove) {
			  cameraStart.copyTransform(cameraSlerp);
			}
			
			dialog.displayDialog(i,isCameraFirstMove);
			
			isCameraFirstMove = false;
			
			cameraTarget.copyTransform(plane);
			cameraTarget.moveBackward(200);
			
			createTween(cameraTarget);  //摄像机移动到目标plane
			
			TweenMax.to(btnBack, 1.5, {y:swfHeight-40,alpha:1,ease:Expo.easeInOut});
		}
		
		private function cameraRestoreHandler(event:MouseEvent):void {
			isCameraMove = false;
			isCameraFirstMove = true;
			createTween(cameraStart);
			
			dialog.hideDialog();
			
			TweenMax.to(btnBack, 1, {y:swfHeight+30,alpha:0,ease:Expo.easeInOut});
			
			planeClick=-1;
		}
		
		private function createTween(e:DisplayObject3D):void {
			
			cameraSlerp.slerp = 0;

			cameraStartQ = Quaternion.createFromMatrix(cameraSlerp.transform);
			cameraEndQ= Quaternion.createFromMatrix(e.transform);

			TweenMax.to(cameraSlerp, 1, {
			  x:e.x,
			  y:e.y,
			  z:e.z,
			  slerp:1,
			  onUpdate:cameraMoveUpdateCallback,
			  onComplete:cameraMoveCompleteCallback
			});

		}
		
		private function cameraMoveUpdateCallback():void {
			cameraSlerpQ= Quaternion.slerp(cameraStartQ,cameraEndQ,cameraSlerp.slerp);
			cameraSlerp.transform.copy3x3(cameraSlerpQ.matrix);
								
		}
		
		private function cameraMoveCompleteCallback():void {
			if(!isCameraMove) {
				//恢复事件和obj
				main.stage.addEventListener(Event.ENTER_FRAME,planeRotation);
				main.stage.addEventListener(MouseEvent.MOUSE_WHEEL,setCameraFovHandler);
				pathTipObj.alpha=1;
				for(var l:int=0;l<_data.length;l++) {
		          viewport.getChildLayer(Plane(planeObj.getChildByName("plane"+l))).alpha= 1;
			    }
				//
			}
		}
		
		
		private function setPathLight(i:int,isLight:Boolean):void {
			
			var pos:int = _data[i].position;
			
			if(pos<20 && pos>=1) {
               pathLight(0,isLight);
			   pathLight(1,isLight);   
            }
            else if(pos<40 && pos>=20) {
               pathLight(1,isLight);
			   pathLight(2,isLight); 
            }
            else if(pos<60 && pos>=40) {
               pathLight(2,isLight);
			   pathLight(3,isLight); 
            }
            else if(pos<80 && pos>=60) {
               pathLight(3,isLight);
			   pathLight(4,isLight); 
            }
            else if(pos<99 && pos>=80) {
               pathLight(4,isLight);
			   pathLight(5,isLight); 
            }
            else if(pos==99) {
               pathLight(5,isLight); 
            }
			
		}
		private function pathLight(i:int,isLight:Boolean):void {
			viewport.getChildLayer(pathObj.getChildByName("path"+i)).alpha = isLight ? 1 : pathLightArr[i];
			pathTipObj.getChildByName("tip"+i).alpha = isLight ? .8 : .7;
			TextField(MovieClip(pathTipObj.getChildByName("tip"+i)).getChildByName("tipText"+i)).setTextFormat(isLight ? tipFormatLight : tipFormat);
		}
		
		private function planeFrameHandler(plane:Plane):void {
			planeLine.v1.x=plane.x;
			planeLine.v1.z=plane.z;
		}
			
		private function setCameraFovHandler(event:MouseEvent):void {
			
			var count:int = -event.delta/3;
			
			if ( (count>0 && cameraFovCount<= (zoomStep-1) ) || (count<0 && cameraFovCount>= -(zoomStep-1) )) { 
				
				cameraFovCount+=count;
				TweenMax.to(cameraSlerp,1, {
							  y:_param.camera.y + cameraFovCount*(_param.camera.y/zoomStep) + 30,
							  z:-_param.camera.z - cameraFovCount*(_param.camera.z/zoomStep)-500,
							  onUpdate:function() { cameraSlerp.lookAt(DisplayObject3D.ZERO); }
							});
				TweenMax.to(main.getChildByName("cosmoBg"),1,{
							  width: swfWidth*1.1 - cameraFovCount*(swfWidth*.1)/zoomStep,   
							  height: swfHeight*1.1 - cameraFovCount*(swfHeight*.1)/zoomStep
							});
			}

		}
		
		private function getRadius(position:int):Number {
			if(position ==0 ) {
		      return 0;
			}
			else {
			  return (1199 - position*10);
			}
	    }
		
		override protected function onRenderTick(e:Event=null):void {
			renderer.renderScene(scene,cameraSlerp,viewport);
		}
		
		private function setDialogInfo():void {
			dialog=new Dialog(main,_data);
		}
		
	}
}

import org.papervision3d.cameras.Camera3D;
class CameraSlerp extends Camera3D {
	public var slerp:Number=0;
}