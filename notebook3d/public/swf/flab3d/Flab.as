package flab3d{
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.core.math.Number3D;
	public class Flab {
		public function Flab():void {

		}
		//flab3d.com 08/12/17加入---用于制作低成本花草树木等等一直面向摄像机的效果，有很多用处/////////////
		private static var target1:Number3D=Number3D.ZERO;
		private static var core1:Number3D=Number3D.ZERO;
		private static  var toDEGREES:Number = 180/Math.PI;
		public static function lockLookAt(theCore:DisplayObject3D,theTarget:DisplayObject3D):void {
			theCore.rotationY=theCore.rotationX=theCore.rotationZ=0;
			target1.x=theTarget.x;
			target1.z=theTarget.z;
			core1.x=theCore.x;
			core1.z=theCore.z;
			target1.minusEq(core1);
			var angeled:Number=Math.atan(target1.x/target1.z);
			angeled*=toDEGREES;
			theCore.rotationY=angeled;

		}
	}
}