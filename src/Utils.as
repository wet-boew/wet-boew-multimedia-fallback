/*!
 * Web Experience Toolkit (WET) / Boîte à outils de l'expérience Web (BOEW)
 * www.tbs.gc.ca/ws-nw/wet-boew/terms / www.sct.gc.ca/ws-nw/wet-boew/conditions
 */

package
{
	import flash.display.Sprite;
	import flash.display.Stage;

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

		public static function noCacheUrl(url:String):String
		{
			if (url.indexOf("?") > -1)
			{
				// this is already a dynamic URL so we are just appending a extra value
				return url + "&time=" + Utils.random(999999999);
			}
			else
			{
				// the rest of the files should be static
				return url + "?time=" + Utils.random(999999999);
			}
		}

		/**
		 *  Simplified random number generator that takes care of rounding up
		 * @param	top - highest value for the random number
		 * @return  random number from 0 - top parms
		 */


		public static function random(top:Number):Number
		{
			return Math.ceil(Math.random() * top);
		}
		;

		/**
	* Unescape a string and filter "asfunction" occurences ( can be used for XSS exploits).
	*
	* @param str	The string to decode.
	* @return 		The decoded string.
	**/
		public static function decode(str:String):String
		{
			if (str.indexOf('asfunction') == -1)
			{
				return unescape(str);
			}
			else
			{
				return '';
			}
		}
		;

		/**
		* Basic serialization: string representations of booleans and numbers are returned typed;
		* strings are returned urldecoded.
		*
		* @param val	String value to serialize.
		* @return		The original value in the correct primitive type.
		**/
		public static function serialize(val:String):Object
		{
			if (val == null)
			{
				return null;
			}
			else if (val == 'true')
			{
				return true;
			}
			else if (val == 'false')
			{
				return false;
			}
			else if (isNaN(Number(val)) || val.length > 5)
			{
				return Utils.decode(val);
			}
			else
			{
				return Number(val);
			}
		}
		;


		/**
		* Add a leading zero to a number.
		*
		* @param nbr	The number to convert. Can be 0 to 99.
		* @ return		A string representation with possible leading 0.
		**/
		public static function zero(nbr:Number):String
		{
			if (nbr < 10)
			{
				return '0' + nbr;
			}
			else
			{
				return '' + nbr;
			}
		}
		;
	}

}