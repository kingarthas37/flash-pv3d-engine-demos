//控制plane移动
private function planeMouseEvent(event:InteractiveScene3DEvent):void {

			var rotationAngle:int = Math.round((Math.atan2(Plane(event.target).x,Plane(event.target).z)*180/Math.PI)/(360/PLANECOUNT))*(360/PLANECOUNT);

			if (rotationAngle>=0) {
				rotationAngle = 180- rotationAngle;
			} else {
				rotationAngle = -(180+rotationAngle);
			}
			for (var i=0; i<PLANECOUNT; i++) {

				var plane= PlaneWithSlerp(imageObject.getChildByName("plane"+i));
				var planeTarget = Plane(imageObject.getChildByName("planeTarget"+i));

				var planeTargetAngle:Number = Math.atan2(planeTarget.x,planeTarget.z)*180/Math.PI + rotationAngle;

				planeTarget.x= Math.sin(planeTargetAngle*Math.PI/180)*RADIUS;
				planeTarget.z= Math.cos(planeTargetAngle*Math.PI/180)*RADIUS;

				var bezierObject:Object=[];//bezier曲线，用于控制plane的移动轨迹点，避免plane的直线运动
				for (var bezieri:int=2; bezieri<=Math.abs(rotationAngle/(360/PLANECOUNT)); bezieri++) {

					var bezierRotation:Number=0;

					if (rotationAngle>=0) {
						bezierRotation = 360/PLANECOUNT*(bezieri-1);
					} else {
						bezierRotation = -360/PLANECOUNT*(bezieri-1);
					}

					var bezierX:Number = Math.sin((Math.atan2(plane.x,plane.z)*180/Math.PI + bezierRotation)*Math.PI/180)*RADIUS;
					var bezierZ:Number = Math.cos((Math.atan2(plane.x,plane.z)*180/Math.PI + bezierRotation)*Math.PI/180)*RADIUS;

					bezierObject[bezieri-2] = {x:bezierX,z:bezierZ};

				}

				if (param.objectRotation()) {
					planeTarget.yaw(rotationAngle);
				}

				plane.slerp=0;
				planeStartQArr[i]=Quaternion.createFromMatrix(plane.transform);
				planeEndQArr[i]=Quaternion.createFromMatrix(planeTarget.transform);

				TweenMax.to(plane, 2, {
				  x:planeTarget.x,
				  y:planeTarget.y,
				  z:planeTarget.z,
				  bezier:bezierObject,
				  slerp:1,
				  ease:Cubic.easeOut,
				  onUpdateParams :[plane,i],
				  onUpdate:planeMoveCallback
				});
			}
		}