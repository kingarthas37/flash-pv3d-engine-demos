package flab3d{
	/////////////////////////
	///-flab3d.com-03/01/09,//////////////////////////////flash3d研究所，全景观察制作功能////////////////////
	////////////////////////
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.net.URLRequest;
    
    import org.papervision3d.cameras.FreeCamera3D;
	import org.papervision3d.cameras.Camera3D;
    import org.papervision3d.materials.BitmapFileMaterial;
    import org.papervision3d.materials.utils.MaterialsList;
    import org.papervision3d.objects.primitives.Cube;
    import org.papervision3d.view.Viewport3D;
	
	public class RoomCube extends Cube{
		
    private var OldX:Number;
    private var OldY:Number;	
    
		
	private var mapFront:BitmapFileMaterial;
	private var mapBack:BitmapFileMaterial;
	private var mapLeft:BitmapFileMaterial;
	private var mapRight:BitmapFileMaterial;
	private var mapTop:BitmapFileMaterial;
	private var mapBottom:BitmapFileMaterial;	
	
	private var matList:MaterialsList;
	
	private var myCamera:Camera3D;
	private var myViewport:Viewport3D;
	
	
	
	public function RoomCube(_viewport:Viewport3D,_camera:Camera3D,_MatList:Array,_width:Number=4000,_depth:Number=4000,_height:Number=4000,segmentsS:int=7, segmentsT:int=7, segmentsH:int=7):void{
		    myCamera=_camera;
		    myViewport=_viewport;
		    
		    mapFront=new BitmapFileMaterial(_MatList[0]);
            mapFront.smooth=true;
            mapBack=new BitmapFileMaterial(_MatList[1]);
            mapBack.smooth=true;
            mapLeft=new BitmapFileMaterial(_MatList[2]);
            mapLeft.smooth=true;
            mapRight=new BitmapFileMaterial(_MatList[3]);
            mapRight.smooth=true;
            mapTop=new BitmapFileMaterial(_MatList[4]);
            mapTop.smooth=true;
            mapBottom=new BitmapFileMaterial(_MatList[5]);
            mapBottom.smooth=true;
		
		
		    matList=new MaterialsList();
		    matList.addMaterial(mapFront,"back");
		    matList.addMaterial(mapBack,"front");
		    matList.addMaterial(mapLeft,"left");
		    matList.addMaterial(mapRight,"right");
		    matList.addMaterial(mapTop,"top");
		    matList.addMaterial(mapBottom,"bottom");
		    
		    super(matList,_width,_depth,_height,segmentsS,segmentsT,segmentsH);
		    this.scale=-1;
            this.rotationZ=180;
		    
		    myViewport.addEventListener(MouseEvent.MOUSE_MOVE,onMMove);
	}
		
	    private var loaderArray:Array=[];
		private var sideName:Array=[];
		private var num:int=0;
		
		
		
		///-flab3d.com-03/01/09,//////////////////////////////全景观察制作功能
		///变换roomcube的贴图，六个面对应的名称分别是front,back,top,bottom,left,right
		///
		public function setMaterial(_fileName:String="",_sideName:String=""):void{
         
           sideName[num]=_sideName;
           loaderArray[num]=new Loader;
           
           loaderArray[num].load(new URLRequest(_fileName));
		   loaderArray[num].contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete);
		   num++;
		}	
		
		
		private function onLoadComplete(evt:Event):void{
		var bmd:BitmapData;          
        for(var i:int=0;i<sideName.length;i++){
		   switch(sideName[i]){
          case "front":
          bmd=Bitmap(loaderArray[i].content).bitmapData.clone();
          mapFront.bitmap=bmd;
          break;
          case "back":
          bmd=Bitmap(loaderArray[i].content).bitmapData.clone();
          mapBack.bitmap=bmd;
          break;
          case "left":
          bmd=Bitmap(loaderArray[i].content).bitmapData.clone();
          mapLeft.bitmap=bmd;
          break;
          case "right":
          bmd=Bitmap(loaderArray[i].content).bitmapData.clone();
          mapRight.bitmap=bmd;
          break;
          case "top":
          bmd=Bitmap(loaderArray[i].content).bitmapData.clone();
          mapTop.bitmap=bmd;
          break;
          case "bottom":
          bmd=Bitmap(loaderArray[i].content).bitmapData.clone();
          mapBottom.bitmap=bmd;
          break;
          case "all":
          mapFront.bitmap=Bitmap(loaderArray[i].content).bitmapData.clone();
          mapBack.bitmap=Bitmap(loaderArray[i].content).bitmapData.clone();
          mapLeft.bitmap=Bitmap(loaderArray[i].content).bitmapData.clone();
          mapRight.bitmap=Bitmap(loaderArray[i].content).bitmapData.clone();
          mapTop.bitmap=Bitmap(loaderArray[i].content).bitmapData.clone();
          mapBottom.bitmap=Bitmap(loaderArray[i].content).bitmapData.clone();
          break;
          default:
          
          break;
          }	
         loaderArray[i].contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadComplete);  
            
         }
		}
		
		private function onMMove(evt:MouseEvent):void {
		     OldX=myViewport.width/2;	
		     OldY=myViewport.height/2;	
			
		     if(-(myViewport.mouseY-OldY)/1.5<80&&-(myViewport.mouseY-OldY)/1.5>-80){
			 myCamera.rotationX=-(myViewport.mouseY-OldY)/1.5;
		     }
		
		     this.rotationY=(myViewport.mouseX-OldX)/1.25;
		}

		
	}
}
