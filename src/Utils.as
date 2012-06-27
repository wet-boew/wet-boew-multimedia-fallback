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


		/** Strip tags and breaks from a string. **/
		public static function stripTagsBreaks(str:String):String
		{
			if (str.length == 0 || str == 'undefined')
			{
				return "";
			}
			var tmp:Array=str.split("\n");
			str=tmp.join("");
			tmp=str.split("\r");
			str=tmp.join("");
			var i:Number=str.indexOf("<");
			while (i != -1)
			{
				var j:Number=str.indexOf(">", i + 1);
				j == -1 ? j=str.length - 1 : null;
				str=str.substr(0, i) + str.substr(j + 1, str.length);
				i=str.indexOf("<", i);
			}
			return str;
		}
		;


		/**
		 * Chop string into a number of lines.
		 *
		 * @param str	The string to chop.
		 * @param cap	The maximum number of characters per line.
		 * @param nbr	The maximum number of lines.
		 **/
		public static function chopString(str:String, cap:Number, nbr:Number):String
		{
			for (var i:Number=cap; i < str.length; i+=cap)
			{
				if (i == cap * nbr)
				{
					if (str.indexOf(" ", i - 5) == -1)
					{
						return str;
					}
					else
					{
						return str.substr(0, str.indexOf(" ", i - 5));
					}
				}
				else if (str.indexOf(" ", i) > 0)
				{
					str=str.substr(0, str.indexOf(" ", i - 3)) + "\n" + str.substr(str.indexOf(" ", i - 3) + 1);
				}
			}
			return str;
		}
		;


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
		* Convert a time-representing string to a number.
		*
		* @param str	The input string. Supported are 00:03:00.1 / 03:00.1 / 180.1s / 3.2m / 3.2h
		* @return		The number of seconds.
		**/
		public static function seconds(str:String):Number
		{
			str=str.replace(',', '.');
			var arr:Array=str.split(':');
			var sec:Number=0;
			if (str.substr(-1) == 's')
			{
				sec=Number(str.substr(0, str.length - 1));
			}
			else if (str.substr(-1) == 'm')
			{
				sec=Number(str.substr(0, str.length - 1)) * 60;
			}
			else if (str.substr(-1) == 'h')
			{
				sec=Number(str.substr(0, str.length - 1)) * 3600;
			}
			else if (arr.length > 1)
			{
				sec=Number(arr[arr.length - 1]);
				sec+=Number(arr[arr.length - 2]) * 60;
				if (arr.length == 3)
				{
					sec+=Number(arr[arr.length - 3]) * 3600;
				}
			}
			else
			{
				sec=Number(str);
			}
			return sec;
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
		* Strip HTML tags and linebreaks off a string.
		*
		* @param str	The string to clean up.
		* @return		The clean string.
		**/
		public static function strip(str:String):String
		{
			var tmp:Array=str.split("\n");
			str=tmp.join("");
			tmp=str.split("\r");
			str=tmp.join("");
			var idx:Number=str.indexOf("<");
			while (idx != -1)
			{
				var end:Number=str.indexOf(">", idx + 1);
				end == -1 ? end=str.length - 1 : null;
				str=str.substr(0, idx) + " " + str.substr(end + 1, str.length);
				idx=str.indexOf("<", idx);
			}
			return str;
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

		public static var htmlEntities:Object={quot: 0x0022, amp: 0x0026, lt: 0x003c, gt: 0x003e, nbsp: 0x00a0, iexcl: 0x00a1, cent: 0x00a2, pound: 0x00a3, curren: 0x00a4, yen: 0x00a5, brvbar: 0x00a6, sect: 0x00a7, uml: 0x00a8, copy: 0x00a9, ordf: 0x00aa, laquo: 0x00ab, not: 0x00ac, shy: 0x00ad, reg: 0x00ae, macr: 0x00af, deg: 0x00b0, plusmn: 0x00b1, sup2: 0x00b2, sup3: 0x00b3, acute: 0x00b4, micro: 0x00b5, para: 0x00b6, middot: 0x00b7, cedil: 0x00b8, sup1: 0x00b9, ordm: 0x00ba, raquo: 0x00bb, frac14: 0x00bc, frac12: 0x00bd, frac34: 0x00be, iquest: 0x00bf, Agrave: 0x00c0, Aacute: 0x00c1, Acirc: 0x00c2, Atilde: 0x00c3, Auml: 0x00c4, Aring: 0x00c5, AElig: 0x00c6, Ccedil: 0x00c7, Egrave: 0x00c8, Eacute: 0x00c9, Ecirc: 0x00ca, Euml: 0x00cb, Igrave: 0x00cc, Iacute: 0x00cd, Icirc: 0x00ce, Iuml: 0x00cf, ETH: 0x00d0, Ntilde: 0x00d1, Ograve: 0x00d2, Oacute: 0x00d3, Ocirc: 0x00d4, Otilde: 0x00d5, Ouml: 0x00d6, times: 0x00d7, Oslash: 0x00d8, Ugrave: 0x00d9, Uacute: 0x00da, Ucirc: 0x00db, Uuml: 0x00dc, Yacute: 0x00dd, THORN: 0x00de, szlig: 0x00df, agrave: 0x00e0, aacute: 0x00e1, acirc: 0x00e2, atilde: 0x00e3, auml: 0x00e4, aring: 0x00e5, aelig: 0x00e6, ccedil: 0x00e7, egrave: 0x00e8, eacute: 0x00e9, ecirc: 0x00ea, euml: 0x00eb, igrave: 0x00ec, iacute: 0x00ed, icirc: 0x00ee, iuml: 0x00ef, eth: 0x00f0, ntilde: 0x00f1, ograve: 0x00f2, oacute: 0x00f3, ocirc: 0x00f4, otilde: 0x00f5, ouml: 0x00f6, divide: 0x00f7, oslash: 0x00f8, ugrave: 0x00f9, uacute: 0x00fa, ucirc: 0x00fb, uuml: 0x00fc, yacute: 0x00fd, thorn: 0x00fe, yuml: 0x00ff, OElig: 0x0152, oelig: 0x0153, Scaron: 0x0160, scaron: 0x0161, Yuml: 0x0178, fnof: 0x0192, circ: 0x02c6, tilde: 0x02dc, Alpha: 0x0391, Beta: 0x0392, Gamma: 0x0393, Delta: 0x0394, Epsilon: 0x0395, Zeta: 0x0396, Eta: 0x0397, Theta: 0x0398, Iota: 0x0399, Kappa: 0x039a, Lambda: 0x039b, Mu: 0x039c, Nu: 0x039d, Xi: 0x039e, Omicron: 0x039f, Pi: 0x03a0, Rho: 0x03a1, Sigma: 0x03a3, Tau: 0x03a4, Upsilon: 0x03a5, Phi: 0x03a6, Chi: 0x03a7, Psi: 0x03a8, Omega: 0x03a9, alpha: 0x03b1, beta: 0x03b2, gamma: 0x03b3, delta: 0x03b4, epsilon: 0x03b5, zeta: 0x03b6, eta: 0x03b7, theta: 0x03b8, iota: 0x03b9, kappa: 0x03ba, lambda: 0x03bb, mu: 0x03bc, nu: 0x03bd, xi: 0x03be, omicron: 0x03bf, pi: 0x03c0, rho: 0x03c1, sigmaf: 0x03c2, sigma: 0x03c3, tau: 0x03c4, upsilon: 0x03c5, phi: 0x03c6, chi: 0x03c7, psi: 0x03c8, omega: 0x03c9, thetasym: 0x03d1, upsih: 0x03d2, piv: 0x03d6, ensp: 0x2002, emsp: 0x2003, thinsp: 0x2009, zwnj: 0x200c, zwj: 0x200d, lrm: 0x200e, rlm: 0x200f, ndash: 0x2013, mdash: 0x2014, lsquo: 0x2018, rsquo: 0x2019, sbquo: 0x201a, ldquo: 0x201c, rdquo: 0x201d, bdquo: 0x201e, dagger: 0x2020, Dagger: 0x2021, bull: 0x2022, hellip: 0x2026, permil: 0x2030, prime: 0x2032, Prime: 0x2033, lsaquo: 0x2039, rsaquo: 0x203a, oline: 0x203e, frasl: 0x2044, euro: 0x20ac, image: 0x2111, weierp: 0x2118, real: 0x211c, trade: 0x2122, alefsym: 0x2135, larr: 0x2190, uarr: 0x2191, rarr: 0x2192, darr: 0x2193, harr: 0x2194, crarr: 0x21b5, lArr: 0x21d0, uArr: 0x21d1, rArr: 0x21d2, dArr: 0x21d3, hArr: 0x21d4, forall: 0x2200, part: 0x2202, exist: 0x2203, empty: 0x2205, nabla: 0x2207, isin: 0x2208, notin: 0x2209, ni: 0x220b, prod: 0x220f, sum: 0x2211, minus: 0x2212, lowast: 0x2217, radic: 0x221a, prop: 0x221d, infin: 0x221e, ang: 0x2220, and: 0x2227, or: 0x2228, cap: 0x2229, cup: 0x222a, int: 0x222b, there4: 0x2234, sim: 0x223c, cong: 0x2245, asymp: 0x2248, ne: 0x2260, equiv: 0x2261, le: 0x2264, ge: 0x2265, sub: 0x2282, sup: 0x2283, nsub: 0x2284, sube: 0x2286, supe: 0x2287, oplus: 0x2295, otimes: 0x2297, perp: 0x22a5, sdot: 0x22c5, lceil: 0x2308, rceil: 0x2309, lfloor: 0x230a, rfloor: 0x230b, lang: 0x2329, rang: 0x232a, loz: 0x25ca, spades: 0x2660, clubs: 0x2663, hearts: 0x2665, diams: 0x2666};


		//modified from http://www.cnblogs.com/laudy/articles/1186810.html
		public static function htmlUnescape(s:String):String
		{
			trace(s);
			var replacement:String;
			var i:int;
			var code:int;
			var already_matched:Array=[];
			var re:RegExp;
			var matches:Array;
			var match_part:String;
			var match:String;

			if (s == null || s == "")
				return "";
			//regex convert all numeric character references to regular chars
			matches=s.match(/&#(\d+);/g);
			var dec:String;
			for (i=0; i < matches.length; i++)
			{
				match=matches[i];
				match_part=match.substring(2, match.length - 1);
				if (already_matched.indexOf(match_part) > -1)
					continue;
				replacement=String.fromCharCode(uint(match_part));
				re=new RegExp(match, 'gi');
				s=s.replace(re, replacement);
				already_matched.push(match_part);
			}

			//regex convert all hexadecimal character references to regular chars
			var hex:uint;
			matches=s.match(/?([0-9a-f]+);/gi);
			for (i=0; i < matches.length; i++)
			{
				match=matches[i];
				match_part=match.substring(3, match.length - 1);
				if (already_matched.indexOf(match_part.toLowerCase()) > -1)
					continue;
				hex=uint("0x" + match_part);
				replacement=String.fromCharCode(hex);
				re=new RegExp(match, 'gi');
				s=s.replace(re, replacement);
				already_matched.push(match_part.toLowerCase());
			}

			//regex convert all named entities to regular chars
			matches=s.match(/&([0-9a-z]+);/gi);
			for (i=0; i < matches.length; i++)
			{
				match=matches[i];
				match_part=match.substring(1, match.length - 1);
				if (already_matched.indexOf(match_part) > -1)
					continue;
				code=Utils.htmlEntities[match_part];
				if (code > -1)
				{
					re=new RegExp(match, 'g');
					s=s.replace(re, String.fromCharCode(code));
					already_matched.push(match_part);
				}
				else
				{
					trace('Bad entity! ' + match);
				}
			}
			return s;
		}

	}

}