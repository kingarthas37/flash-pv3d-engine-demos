package flab3d{
	import caurina.transitions.Tweener;
	
	import flash.events.Event;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.math.Quaternion;
	import org.papervision3d.objects.DisplayObject3D;
	/////////////////////////
	///-flab3d.com-09/01/09,//////////////////////////////flash3d研究所，可自动移动插值的flab摄像机/////////////////////
	////////////////////////
    public class FlabCamera3D extends Camera3D{
       
    public var _camera:Camera3D;
    
    private var startQua:Quaternion = null;
	private var endQua:Quaternion = null;
	private var currentQua:Quaternion = null;
	
	public var slerp:Number = 0;
	public var distanceFrom:Number=700;
	
	private var cameraZero:DisplayObject3D = new DisplayObject3D();
	private var cameraTarget:DisplayObject3D = new DisplayObject3D();



       
    public function FlabCamera3D(fov:Number=60, near:Number=10, far:Number=5000, useCulling:Boolean=false, useProjection:Boolean=false):void{
    	super(fov, near, far, useCulling, useProjection);
    	
    }  
 
 			/**
		* [internal-use] Transforms world coordinates into camera space.
		*/
		// TODO OPTIMIZE (LOW)
		public override function transformView( transform:Matrix3D=null ):void {
			if ( this._transformDirty ) {
				updateTransform();
			}

			// Rotate Z
			super.transformView();
		}
		
		public function resetToZero():void{
		  tweenTo(cameraZero);
		}
	
	 private function createTraget(_do3d:DisplayObject3D,_distanceFrom:Number=600):DisplayObject3D{
	 	
	 	    distanceFrom=_distanceFrom;
	 		cameraTarget.copyTransform(_do3d);
			cameraTarget.moveBackward(distanceFrom);
			return cameraTarget;
	 }	
		
 	
   	 public function tweenTo(_do3d:DisplayObject3D,_distanceFrom:Number=700,_due:Number=2,_isRotational:Boolean=true,_slerp:Number=0):void
		{
		
		    _do3d=createTraget(_do3d,_distanceFrom);
		    
			slerp = _slerp;


			startQua = Quaternion.createFromMatrix(this.transform);
			endQua = Quaternion.createFromMatrix(_do3d.transform);
             
             
              
			if(_isRotational){
			Tweener.addTween(this,{x:_do3d.x,
			                       y:_do3d.y,
			                       z:_do3d.z,
			                       slerp:1,
			                       time:_due, delay:0,onUpdate:onUpdateTick,onComplete:onCompleteHandler});
			}else{
			Tweener.addTween(this,{x:_do3d.x,
			                       y:_do3d.y,
			                       z:_do3d.z,
			                       slerp:1,
			                       time:_due, delay:0,onComplete:onCompleteHandler});
			}
			
			
		}

 	
 	   //计算旋转
 	    private function onUpdateTick():void
		{
			currentQua = Quaternion.slerp(startQua, endQua, slerp);
			this.transform.copy3x3(currentQua.matrix);
	
			//startQua = Quaternion.createFromMatrix(this.transform);
		}
		
		private function onCompleteHandler():void{
		  this.dispatchEvent(new Event(Event.CHANGE));
		}
		


 	
 	///-flab3d.com-18/11/08,绕Y轴旋转的类//////////////////////////////
		///第一个参数是摄像机看着的物体，第二个参数是每祯旋转度数；第三个参数摄像机是离物体的距离，第四个是摄像机的高度

		private var angled:Number=0;

		public function orbitY(do3d:DisplayObject3D=null,primAngel:Number=0,angelIncrease:Number=1,distance:int=1000,heightY:Number=0):void {
			this.lookAt(do3d);

			var radius:int=distance;
			if(primAngel!=0){
			angled=primAngel;
			}else{
			angled+=angelIncrease;
             }

			var ss:Number = angled*Math.PI/180;
			//var zz:Number = radius*Math.PI/180;


			this.x = do3d.x + radius * Math.sin(ss);
			this.y=do3d.y+heightY;
			//this.y = do3d.x + radius * Math.cos(zz) * Math.sin(ss);
			this.z = do3d.z + radius * Math.cos(ss);
		}
		
		public function orbitYplus(do3d:DisplayObject3D=null,primAngel:Number=0,angelIncrease:Number=1,distance:int=1000,heightY:Number=0):void {
			this.lookAt(do3d);

			var radius:int=distance;
			if(primAngel!=0){
			angled=primAngel;
			}else{
			angled+=angelIncrease;
             }

			var ss:Number = angled*Math.PI/180;
			//var zz:Number = radius*Math.PI/180;


			this.x = do3d.x + radius * Math.sin(ss);
			this.y=do3d.y+heightY;
			//this.y = do3d.x + radius * Math.cos(zz) * Math.sin(ss);
			this.z = do3d.z + radius * Math.cos(ss);
		}
		/////////////////////////////////////////////
 	
 }
}