package core {
	
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.papervision3d.view.BasicView;
	
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.parsers.Collada;		
	
	import org.papervision3d.view.layer.util.ViewportLayerSortMode;
	
	import core.com.View3d;
	import core.com.AssistLine3d;
	
	public class Main3d extends BasicView {
		
		var main:Main;
		
		private var swfWidth:Number;
		private var swfHeight:Number;
		private var url:String;
		
		private var loadCount:uint=0;
					
		var model:Collada;
		
		var texture:Bitmap;
		
		var view3d:View3d;
		
		var view3dHandler:View3dHandler;
		var edit3dHandler:Edit3dHandler;
		
		private var setModel:SetModel;
		private var setTexture:SetTexture;
		
		private var components:Components;
		
		public function Main3d(main:Main,swfWidth:Number,swfHeight:Number,url:String) {
			
			this.main=main;
			this.swfWidth=swfWidth;
			this.swfHeight=swfHeight;
			this.url = url;
			
			super(swfWidth,swfHeight,false,true);
			main.addChildAt(viewport,1);
			viewport.containerSprite.sortMode = ViewportLayerSortMode.INDEX_SORT;

			init();
			
			startRendering();  //pv3d渲染
		}
		
		private function init():void {
			
			view3d= new View3d(main,swfWidth,swfHeight,camera);   //鼠标3D事件触发
			
			var assistLine3d:AssistLine3d=new AssistLine3d(this);
		
			view3dHandler=new View3dHandler(main,this,assistLine3d);
			edit3dHandler=new Edit3dHandler(main,this,camera,assistLine3d);
			
			components=new Components(main,this,swfWidth,swfHeight);
			
			setTexture = new SetTexture(main,this); //初始贴图
			setModel = new SetModel(main,this); //初始3d模型									   
									
			initModel(main.datas.modelURL);  //调用model
		}
			
			
		//处理模型
		function initModel(modelURL:String):void {
			if(model) {
				scene.removeChild(model);
				model=null;
			}
			setModel.loadModel(url+ "files/model/" + modelURL + "/dae." + main.datas.modelFormat);
		}
		
		//处理贴图
		function initTexture(fileName:String):void {
			if(texture) texture=null;
			setTexture.loadTexture(url+ "files/texture/" + main.datas.textureURL + "/" + fileName +".jpg");
		}
		
		
		function updateModel(collada:Collada):void {
			model=collada;
			scene.addChild(model);
			
			view3dHandler.model=model;
			edit3dHandler.model=model;
			
			edit3dHandler.initModel(main);
			
			initTexture(main.datas.texture[0].filename);
		}
		
		function updateTexture(bm:Bitmap):void {
			texture = bm;
			edit3dHandler.initMaterial(bm);
			
			
			
			loadCount++;
			if(loadCount==1) components.displayComponent();  //显示组件
		}
		
		override protected function onRenderTick(e:Event=null):void {
			renderer.renderScene(scene,camera,viewport);
		}

	}
	
}