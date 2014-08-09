package core.com
{
	import org.papervision3d.core.geom.Lines3D;
	import org.papervision3d.core.geom.renderables.Line3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.materials.special.LineMaterial;
 
	public class Circle3D extends Lines3D
	{
		public function Circle3D(mat:LineMaterial, radius : Number=100, divisions : int = 8, lineWeight : Number = 2, startAngle : Number = 0, endAngle : Number = 360)
		{
			super(mat);
			addCircle(0,0,0,radius, divisions, startAngle, endAngle, lineWeight);
		}
 
		public function addCircle(x:Number, y:Number, z:Number, r:Number, d:Number = 8, startAngle:Number =0, endAngle:Number = 360, linethickness:Number = 2):void
		{
			var temp : Number3D = new Number3D(r,0,0);
			var tempcurve:Number3D = new Number3D(0,0,0);
			var joinends : Boolean;
			var i:int;
			var pointcount : int;
 
			var angle:Number = (endAngle-startAngle)/d;
			var curveangle : Number = angle/2;
 
			tempcurve.x = r/Math.cos(curveangle * Number3D.toRADIANS);
			tempcurve.rotateY(curveangle+startAngle);
 
			if(endAngle-startAngle<360)
			{
				joinends = false;
				pointcount = d+1;
			}
			else
			{
				joinends = true;
				pointcount = d;
			}
 
 
 
			temp.rotateY(startAngle);
 
			var vertices:Array = new Array();
			var curvepoints:Array = new Array();
 
			for(i = 0; i< pointcount;i++)
			{
				vertices.push(new Vertex3D(x+temp.x, y+temp.y, z+temp.z));
				curvepoints.push(new Vertex3D(x+tempcurve.x, y+tempcurve.y, z+tempcurve.z));
				temp.rotateY(angle);
				tempcurve.rotateY(angle);
			}
 
			for(i = 0; i < d ;i++)
			{
				var line:Line3D = new Line3D(this, material as LineMaterial, linethickness, vertices[i], vertices[(i+1)%vertices.length]);
				line.addControlVertex(curvepoints[i].x, curvepoints[i].y, curvepoints[i].z );
 
				addLine(line);
			}
 
 
 
		}
 
	}
}