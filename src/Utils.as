/*!
 * Web Experience Toolkit (WET) / Boîte à outils de l'expérience Web (BOEW)
 * www.tbs.gc.ca/ws-nw/wet-boew/terms / www.sct.gc.ca/ws-nw/wet-boew/conditions
 */

package
{
	import flash.display.Loader;

	/**
	 * ...
	 * @author Mario Bonito
	 * @credits JWPlayer - There was some useful static functions for time management and string handling that were copied
	 */
	public class Utils
	{

		/**
		 *  Centers an object
		 * @param	h - height of container you wish to center to
		 * @param	w - width of container you wish to center to
		 * @param	obj - actual object reference
		 */

		public static function center(h:Number, w:Number, obj:Object):void
		{
			obj.x=w / 2 - (obj.width / 2);
			obj.y=h / 2 - (obj.height / 2);
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
		;
	}

}