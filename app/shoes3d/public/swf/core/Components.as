package core {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import fl.events.ColorPickerEvent;
	
	import flash.text.TextFormat;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	public class Components {
		
		private var main:Main;
		private var main3d:Main3d;
		private var swfWidth:Number;
		private var swfHeight:Number;
		
		private var cpt:MovieClip;
		private var format:TextFormat =new TextFormat("Arial",12);
		
		private var color:uint;
		
		public function Components(main:Main,main3d:Main3d,swfWidth:Number,swfHeight:Number) {
			
			this.main=main;
			this.main3d=main3d;
			this.swfWidth=swfWidth;
			this.swfHeight=swfHeight;
			
			initComponents();
			
		}
		
		private function initComponents():void {
			
			cpt =new component_sprite();
			cpt.x=5;
			cpt.y=swfHeight;
			//cpt.y=swfHeight-27;
			main.addChild(cpt);
			
			cpt.cmb_displayMode.addEventListener(Event.CHANGE,changeDisplayModeHandler);
			setStyle2(cpt.cmb_displayMode);
			
			color = 0x006699;
			cpt.picker.selectedColor = color;
			//导入cmb_color数据
			for(var i:uint=0;i<main.datas.texture.length;i++) {
				cpt.cmb_color.addItem({data:main.datas.texture[i].filename,label:main.datas.texture[i].name});
			}
			
			cpt.btn_play.addEventListener(MouseEvent.CLICK,playHandler);
			cpt.btn_copy.addEventListener(MouseEvent.CLICK,copyHandler);
			cpt.cmb_transform.addEventListener(Event.CHANGE,transHandler);
			cpt.btn_plane.addEventListener(MouseEvent.CLICK,showPlaneHandler);
			cpt.btn_reposition.addEventListener(MouseEvent.CLICK,repositionHandler);
			cpt.cmb_bg.addEventListener(Event.CHANGE,bgHandler);
			cpt.picker.addEventListener(ColorPickerEvent.CHANGE,bgColorChangeHandler);
			cpt.cmb_color.addEventListener(Event.CHANGE,colorChangeHandler);
				
			setStyle2(cpt.cmb_color);
			setStyle2(cpt.cmb_bg);
			setStyle1(cpt.btn_play);
			setStyle1(cpt.btn_plane);
			
			setStyle1(cpt.btn_copy);
			setStyle2(cpt.cmb_transform);
			setStyle1(cpt.btn_reposition);
			
		}
		
		private function colorChangeHandler(e:Event):void {
			main3d.view3dHandler.colorChange(e.target.selectedItem.data,e.target.selectedIndex);
		}
		
		
		private function bgHandler(e:Event):void {
			main.swfBg.changeBg(e.target.selectedIndex,color);
		}
		
		private function bgColorChangeHandler(e:ColorPickerEvent):void {
			color=e.target.selectedColor;
			main.swfBg.changeBg(cpt.cmb_bg.selectedIndex,color);
		}
		
		private function playHandler(e:MouseEvent):void {
			if(e.target.selected) {
			  main3d.view3dHandler.playModel();
			}
			else {
			  main3d.view3dHandler.stopModel();
			}
		}
		
		private function showPlaneHandler(e:MouseEvent):void {
			if(e.target.selected) {
				main3d.view3dHandler.displayPlane();
			}
			else {
				main3d.view3dHandler.hidePlane();
			}
		}
		
		private function copyHandler(e:MouseEvent):void {
			if(e.target.selected) {
				main3d.edit3dHandler.doubleModel();
				}
			else {
				main3d.edit3dHandler.singleModel();
				}
		}
		
		
		private function transHandler(e:Event):void {
			main3d.edit3dHandler.objTransform=e.target.selectedIndex;
		}
		
		private function repositionHandler(e:MouseEvent):void {
			main3d.edit3dHandler.repositionObj();
		}
		
		
		private function changeDisplayModeHandler(e:Event):void {
		
			if(e.target.selectedItem.data=="view") {
				
				Sprite(main.getChildAt(2)).mouseEnabled=true;
				
				cpt.cmb_color.visible=true;
				cpt.cmb_color.y=0;
				cpt.cmb_bg.visible=true;
				cpt.cmb_bg.y=0;
				cpt.btn_play.visible=true;
				cpt.btn_play.y=0;
				cpt.btn_plane.visible=true;
				cpt.btn_plane.y=0;
				cpt.picker.visible=true;
				cpt.picker.y=1;
				
				cpt.btn_copy.visible=false;
				cpt.btn_copy.y=30;
				cpt.cmb_transform.visible=false;
				cpt.cmb_transform.y=30;
				cpt.btn_reposition.visible=false;
				cpt.btn_reposition.y=30;
				}
			else {
				
				Sprite(main.getChildAt(2)).mouseEnabled=false;
				
				cpt.cmb_color.visible=false;
				cpt.cmb_color.y=30;
				cpt.cmb_bg.visible=false;
				cpt.cmb_bg.y=30;
				cpt.btn_play.visible=false;
				cpt.btn_play.y=30;
				cpt.btn_plane.visible=false;
				cpt.btn_plane.y=30;
				cpt.picker.visible=false;
				cpt.picker.y=31;
				
				cpt.btn_copy.visible=true;
				cpt.btn_copy.y=0;
				cpt.cmb_transform.visible=true;
				cpt.cmb_transform.y=0;
				cpt.btn_reposition.visible=true;
				cpt.btn_reposition.y=0;
			}
			
		}
			
		private function setStyle1(_component:Object):void {
			_component.setStyle("textFormat",format);
		}
		
		private function setStyle2(_component:Object):void {
			_component.textField.setStyle("textFormat",format);
			_component.dropdown.setRendererStyle("textFormat", format);
		}
		
		function displayComponent():void {
			TweenLite.to(cpt,1,{y:swfHeight-27,ease:Expo.easeInOut});
		}
		
	}
	
}