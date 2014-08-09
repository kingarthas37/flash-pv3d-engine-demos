package codes{

	public class Param {

		private var param:Object;

		public function Param(p:Object) {
			param=p;
		}
		//基本设置
		function swfWidth():int {//flash宽度
			return getParam("swfwidth",400);
		}
		function swfHeight():int {//flash高度
			return getParam("swfheight",300);
		}
		function imageCount():int {//图片数量
			return getParam("imageCount",12);
		}
		function imageWidth():int {//图像宽度
			return getParam("imageWidth",120);
		}
		function imageHeight():int {//图像高度
			return getParam("imageHeight",200);
		}
		//动画轨迹设置
		function radius():int {//运动轨迹半径
			return getParam("radius",400);
		}
		function scrollStyle():String {  //滚动样式：水平，垂直滚动
			return getParam("scrollStyle","horizontal"); //horizontal,vertical
		}
		function cameraLocal():String {//摄像机初始位置
			return getParam("cameraLocal","outer");
		}
		function cameraPosition():Number {  //摄像机偏移值
			return getParam("cameraPosition",200);
		}
		function objectRotation():Boolean {//聚焦摄像机
			return getParam("objectrotation",false);
		}
		function userInteraction():String {//交互方式
			return getParam("userInteraction","mouse");  //mouse,button
		}
		function mouseScrollSpeed():Number {  //鼠标滚动速度 //快中慢：2,1,.5
			return getParam("mouseScrollSpeed",1);
			}
		function wheelScaleAble():Boolean { //支持鼠标滚轴缩放
			return getParam("wheelScaleAble",true);
		}
		
		//属性效果设置
		function attrBlur():Boolean {//模糊
			return getParam("attrBlur",true);
		}
		function attrAlpha():Boolean {//透明
			return getParam("attrAlpha",true);
		}
		function attrReflection():Boolean {//倒影
			return getParam("attrReflection",true);
		}
		function attrScale():Boolean {//放大
			return getParam("attrScale",true);
		}
		function attrBorder():Boolean {//边框
			return getParam("attrBorder",true);
		}
		function attrBorderColor():uint {//边框颜色
			return getParamColor("attrBorderColor",0x336699);
		}
		function attrBorderStrong():int {//边框显示强度
			return getParam("attrBorderStrong",5);
		}
		function attrShowTitle():Boolean { //显示title
			return getParam("attrShowTitle",true);
		}
		function attrTitleText():Array { //title值
			return getParam("attrTitleText",["11","2222222222","33333333333333333333","kingarthas4","kingarthas5","kingarthas6","kingarthas7","kingarthas8","kingarthas9","kingarthas10","kingarthas11","kingarthas12"]);
		}
			
		///////////////////////////////////
			
		private function getParam(pars,values) {
			if (param[pars]!=null && param[pars]=="") {
				return param[pars];
			} else {
				return values;
			}
		}
		
		private function getParamColor(pars,values) {
			if (param[pars]!=null && param[pars]=="") {
				var color:uint = param[pars].toString.replace("#","0x");
				return color;
			} else {
				return values;
			}
		}
	}
}