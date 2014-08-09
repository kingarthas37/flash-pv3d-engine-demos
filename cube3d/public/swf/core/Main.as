package core
{

	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.IOErrorEvent;

	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import flash.utils.Timer;

	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	
	import flash.text.TextField;
	import flash.text.TextFormat;


	import com.adobe.serialization.json.JSON;



	public class Main extends Sprite
	{
		
		private var vars:Object; //flash参数
		private var swfWidth:int; 
		private var swfHeight:int;
		private var url:String;
		private var urlValue:String;
		
		
		private var datas:Object=new Object();//数据
		private var _param:Object=new Object(); 
		private var _data:Array=new Array();
		
		
		private var images:Array=new Array();//图片数据
		private var imagesHover:Array=new Array();//图片高亮数据
		private var imagesRe:Array=new Array();//图片倒影数据

		private var imageCount:int = 0;//读取图片记录
		
		//progress
		private var textInfo:TextField=new TextField();
		private var format:TextFormat =new TextFormat();
		private var progressBg:Sprite=new progress_bg();
		private var progressBar1:MovieClip=new progress_bar();
		private var progressBar2:MovieClip=new progress_bar();
		private var progressBar3:MovieClip=new progress_bar();
		
		private var timerStart:Timer; //执行flash

		public function Main()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			//stage.showDefaultContextMenu = false;
			
			loadVars();//载入网页参数
			
			setLoadInfo(); //设置文本和进度信息

			loadDatas();//载入数据
			
		}
		
		private function loadVars():void {
			vars = loaderInfo.parameters;
			swfWidth = vars["width"]!=null ? vars["width"] : 600;
			swfHeight = vars["height"]!=null ? vars["height"] : 600;
			url = vars["dataurl"]!=null ? vars["dataurl"] : "datas/load_json.txt";
			urlValue = vars["datavalue"]!=null ? "?value=" + escape(vars["datavalue"]) : "";
		}
		
		
		private function setLoadInfo():void {
			
			progressBg.x= swfWidth/2;
			progressBg.y= swfHeight/2;
			addChild(progressBg);
			
			progressBar1.x= -78;
			progressBar1.y = -12;
			progressBg.addChild(progressBar1);
			
			progressBar2.x= -26;
			progressBar2.y = -12;
			progressBg.addChild(progressBar2);
			
			progressBar3.x= 26;
			progressBar3.y = -12;
			progressBg.addChild(progressBar3);
			
			format.color= 0xd4d4d4;
			format.font= "Arial";
			format.size=12;
			format.align="center";
			
			textInfo.mouseEnabled = false;
			textInfo.height=20;			
			textInfo.x=swfWidth/2 -  50;
			textInfo.y= swfHeight/2 -2;
			textInfo.text="正在初始化...";
			textInfo.setTextFormat(format);
						
			addChild(textInfo);
			
		}

		private function loadDatas():void {
			
		//  var vars = "";
		//  var reg = /value=(.+)/;
		 // var re:Object=reg.exec(url);
		  
		//  if(re[1]) {
 		//   vars = "?values=" + escape(re[1]);
		//  }
			 
			var dataURL:URLRequest = new URLRequest(url + urlValue);
			var dataLoader:URLLoader=new URLLoader();
			dataLoader.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			dataLoader.addEventListener(ProgressEvent.PROGRESS,dataLoading);
			dataLoader.addEventListener(Event.COMPLETE,dataLoaded);
			
			//aaa.text = url + urlValue;
			try
			{
				dataLoader.load(dataURL);
			}
			catch (e:Error)
			{
				textInfo.text= e.toString();	
			}
		}
		
		private function dataLoading(event:Event):void {
			
			textInfo.text= "加载数据...";
			textInfo.setTextFormat(format);
		}

		private function dataLoaded(event:Event):void
		{
			 
			progressBar1.ing.x = 0;
			datas = JSON.decode(event.target.data);
			_param =  datas.param;
			_data = datas.data;
			
			loadBackground();
		}
		
		private function loadBackground():void {
												
			var bgURL:URLRequest=new URLRequest(datas.bg[Math.floor(Math.random()*datas.bg.length)].url);
			var bgLoader:Loader=new Loader();
			
			bgLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,bgLoading);
			bgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,bgLoaded);
			bgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			
			try { bgLoader.load(bgURL); }
			  catch(e:Error) {
			}
			
			
		}
		
		private function bgLoading(event:ProgressEvent):void {
			progressBar2.ing.x = event.bytesLoaded/event.bytesTotal * 50-50;
			textInfo.text= "加载文件("+ Math.round(event.bytesLoaded/event.bytesTotal*100) +"%)...";
			textInfo.setTextFormat(format);
		}
			
		private function bgLoaded(event:Event):void {
			
			var e:Bitmap = Bitmap(event.target.content);
			e.width=swfWidth*1.1;
			e.height=swfHeight*1.1;
			e.x= -e.width/2;
			e.y= -e.height/2;
						
			var bgObj:Sprite=new Sprite();
			bgObj.name="cosmoBg";
			bgObj.addChild(e);
			
			bgObj.x= swfWidth/2;
			bgObj.y= swfHeight/2;
						
			addChildAt(bgObj,0);
			
			var bgMask:MovieClip=new bg_mask();
			addChildAt(bgMask,1);
			
			loadImages(imageCount);
		}

		private function loadImages(i:int):void
		{
			var imageURL:URLRequest = new URLRequest(_data[i].image);

			var imageLoader:Loader=new Loader();
			imageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,imageLoading);
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,imageLoaded);
			imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			try
			{
				imageLoader.load(imageURL);
			}
			catch (e:Error)
			{

			}

		}


		private function imageLoading(event:ProgressEvent):void
		{
			progressBar3.ing.x = (imageCount+1)/_data.length * 50-50;
			textInfo.text= "加载图片(" + (imageCount+1) + "/"+ _data.length + ")...";
			textInfo.setTextFormat(format);
			
		}
		private function imageLoaded(event:Event):void
		{			

			var e:Bitmap = Bitmap(event.target.content);
			
			var imageWidth:uint= _data[imageCount].width;
			var imageHeight:uint = _data[imageCount].height;

			var loadbmp:Bitmap = Bitmap(event.target.content);
			
			var bmd:BitmapData = new BitmapData(imageWidth,imageHeight,false);//创建plane bitmapData类
			bmd.draw(loadbmp,new Matrix(imageWidth/e.width,0,0,imageHeight/e.height,0,0));  //设置matrix比例
			
			var bmdHover:BitmapData = bmd.clone();
			
			var border:uint=4;  //设置边框
			var borderColor:uint=0x4999cd;//设置边框颜色
			var borderColorHover:uint = 0x4e974d; //边框高亮色
			
			var rectTop:Rectangle=new Rectangle(0,0,imageWidth,border);
			var rectLeft:Rectangle=new Rectangle(0,border,border,imageHeight-border);
			var rectRight:Rectangle=new Rectangle(imageWidth-border,border,border,imageHeight-border);
			var rectBottom:Rectangle=new Rectangle(0,imageHeight-border,imageWidth,border);
			
			bmd.fillRect(rectTop,borderColor);
			bmd.fillRect(rectLeft,borderColor);
			bmd.fillRect(rectRight,borderColor);
			bmd.fillRect(rectBottom,borderColor);
			
			bmdHover.fillRect(rectTop,borderColorHover);
			bmdHover.fillRect(rectLeft,borderColorHover);
			bmdHover.fillRect(rectRight,borderColorHover);
			bmdHover.fillRect(rectBottom,borderColorHover);
			
			images.push(bmd);
			imagesHover.push(bmdHover);
			
			var bmdRe:BitmapData = new BitmapData(imageWidth,imageHeight,true);//创建planeRe bitmapData类
			bmdRe.draw(loadbmp,new Matrix(imageWidth/e.width,0,0,-imageHeight/e.height,0,imageHeight));  //设置matrix比例

			var alphaSetp:int = 30;//设置阴影渐变色过渡数
			for (var i:int=0; i<alphaSetp; i++)
			{
				var ct:ColorTransform = new ColorTransform();
				ct.alphaMultiplier = (1 - i / alphaSetp)*.4;//设置渐变阴影值
				var rect:Rectangle = new Rectangle(0, i*(imageHeight/alphaSetp), imageWidth, imageHeight/alphaSetp);
				bmdRe.colorTransform(rect, ct);
			}
			
			imagesRe.push(bmdRe);

			imageCount++;

			if (imageCount < _data.length)
			{
				loadImages(imageCount);
			}
			else
			{
				textInfo.text= "加载完成!";
				textInfo.setTextFormat(format);
				
				timerStart = new Timer(500,1);  
			    timerStart.addEventListener(TimerEvent.TIMER, onTimerStartHandler);
			    timerStart.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteHandler); 
                timerStart.start();
			}
	  }
	  
	  private function onTimerStartHandler(event:TimerEvent):void {
		  
		  
		  removeChild(progressBg);
		  removeChild(textInfo);
		  //-----------------加载3d---------------------//
				
		  var main3d:Main3d = new Main3d(this,swfWidth,swfHeight,datas,_param,_data,images,imagesHover,imagesRe);  
		  
		  //-----------------加载3d---------------------//
		  
	  }
	  
	  private function onTimerCompleteHandler(event:TimerEvent):void {
		  timerStart.stop();
		  timerStart.removeEventListener(TimerEvent.TIMER,onTimerStartHandler);
	  }
	
	  private function ioErrorHandler(event:IOErrorEvent):void {
		textInfo.text= "加载数据失败!";
		textInfo.setTextFormat(format);
	  } 
	   
	}

}