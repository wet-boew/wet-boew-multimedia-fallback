package
{
	/**
	 * ...
	 * @author Government of Canada
	 */
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextColorType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import org.osmf.elements.ImageLoader;

	public class UIFactory
	{

		private static var dHeight:uint=24;
		private static var dWidth:uint=24;
		private static var dAlpha:Number=0.5;

		public static function createPlayButton(h:Number, w:Number, id:String):MovieClip
		{
			var button:MovieClip=new MovieClip();
			// set the height and width of the movie
			var bg:Shape=new Shape();
			button.addChild(bg);
			bg.graphics.beginFill(0x000000);
			bg.graphics.drawRoundRect(0, 0, UIFactory.dWidth, UIFactory.dHeight, 3);
			bg.graphics.endFill();
			bg.alpha=dAlpha;
			// Create the triangle
			var triangleShape:Shape=new Shape();
			triangleShape.graphics.lineStyle(1, 0xffffff);
			triangleShape.graphics.beginFill(0xffffff);
			triangleShape.graphics.moveTo(UIFactory.dWidth / 3, UIFactory.dHeight / 3);
			triangleShape.graphics.lineTo(UIFactory.dWidth / 3, 2 * UIFactory.dHeight / 3);
			triangleShape.graphics.lineTo((2 * UIFactory.dWidth / 3), (2 * UIFactory.dHeight / 3) - ((UIFactory.dHeight / 3) / 2));
			triangleShape.graphics.lineTo(UIFactory.dWidth / 3, UIFactory.dHeight / 3);
			// Add it to the movie container
			button.addChild(triangleShape);
			// scale the button to the largest dimensions
			button.height=button.width=(w > h) ? (w > 233) ? 60 : w / 3 : (h > 233) ? 60 : h / 3;
			// label the button for easier access
			button.name=id;
			// center it
			Utils.center(h, w, button);
			// return the button
			return button;
		}

		public static function createHitRegion(h:Number, w:Number, id:String):MovieClip
		{

			var hr:MovieClip=new MovieClip();
			// set the height and width of the movie
			var dHeight:uint=h;
			var dWidth:uint=w;
			var bg:Shape=new Shape();
			hr.addChild(bg);
			hr.name=id;
			//square.graphics.beginFill(0x848284);
			bg.graphics.beginFill(0x000000);
			bg.graphics.drawRoundRect(0, 0, dWidth, dHeight, 3);
			bg.graphics.endFill();
			bg.alpha=0;
			hr.buttonMode=true;
			return hr;
		}

		//The resizing function
		// parameters @credits : http://circlecube.com/2009/01/how-to-as3-resize-a-movieclip-and-constrain-proportions-actionscript-tutorial/
		// required: mc = the movieClip to resize
		// required: maxW = either the size of the box to resize to, or just the maximum desired width
		// optional: maxH = if desired resize area is not a square, the maximum desired height. default is to match to maxW (so if you want to resize to 200x200, just send 200 once, ie resizeMe(image, 200);)
		// optional: constrainProportions = boolean to determine if you want to constrain proportions or skew image. default true.
		// optional: centerHor = centers the displayObject in the maxW area. default true.
		// optional: centerVert = centers the displayObject in the maxH area. defualt true.
		public static function resizeMe(mc:Loader, maxW:Number, maxH:Number=0, constrainProportions:Boolean=true, centerHor:Boolean=true, centerVert:Boolean=true):void
		{
			maxH=maxH == 0 ? maxW : maxH;
			mc.width=maxW;
			mc.height=maxH;
			if (constrainProportions)
			{
				mc.scaleX < mc.scaleY ? mc.scaleY=mc.scaleX : mc.scaleX=mc.scaleY;
			}
			if (centerHor)
			{
				mc.x=(maxW - mc.width) / 2;
			}
			if (centerVert)
			{
				mc.y=(maxH - mc.height) / 2;
			}
		}
	}

}