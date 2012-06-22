package
{
	import org.osmf.display.ScaleMode;

	/**
	 * ...
	 * @author Government of Canada
	 */


	public class Config
	{

		private var options:Object={};

		// This is the general location for all the values to be imported from the HTML DOM Object
		public function Config(config:Object)
		{
			// Set the defaults for the init
			options.media=(config.media) ? config.media : "";
			options.height=(config.height) ? config.height : "110"; // default to lowest possible while preserving 16:9 ratio
			options.captionType=(config.captionType) ? config.captionType : "xml"; // default to timedtext
			options.width=(config.width) ? config.width : "195";
			options.id=(config.id) ? config.id : "mediaplayer";
			options.lang=(config.lang) ? config.lang : "eng";
			options.scale=(config.scale) ? config.scale : "default";
			options.autoplay=(config.autoplay) ? config.autoplay : "false";
			options.posterimg=(config.posterimg) ? config.posterimg : "wmms.png"; // We could create a generic png with the GC as a fallback
			options.volume=(config.volume) ? String(int(config.volume) / 100) : "1"; // set the default volume level to 80%
		}

		public function getScaleMode():String
		{

			// Prevent null errors
			var size:String=(options.scale) ? options.scale.toLowerCase() : "";
			// Return the appropiate settings
			switch (size)
			{
				case "fill":
					return ScaleMode.STRETCH;
					break;
				case "zoom":
					return ScaleMode.ZOOM;
					break;
				case "none":
					return ScaleMode.NONE;
				default:
					return ScaleMode.LETTERBOX;
			}

		}

		public function dumpConfig():void
		{
			var output:String=new String();
			for (var p:String in options)
			{
				output+=p + ":" + options[p] + "\n";
			}
			trace("[Config Dump] \n" + output);
		}

		public function getParameter(p:String):String
		{
			return this.options[p] as String;
		}

	}

}