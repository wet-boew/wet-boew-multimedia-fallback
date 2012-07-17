/*!
 * Web Experience Toolkit (WET) / Boîte à outils de l'expérience Web (BOEW)
 * www.tbs.gc.ca/ws-nw/wet-boew/terms / www.sct.gc.ca/ws-nw/wet-boew/conditions
 */

package
{
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.net.URLRequest;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	import org.osmf.events.LoadEvent;
	import org.osmf.events.BufferEvent;

	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.events.MetadataEvent;
	import org.osmf.events.PlayEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.events.AudioEvent;	
	
	import org.osmf.media.MediaPlayerSprite;
	import org.osmf.media.MediaType;
	import org.osmf.media.MediaPlayerState;
	import org.osmf.media.URLResource;
	import org.osmf.elements.AudioElement;

	public class Main extends MovieClip
	{
		private var _id:String;
		
		private var _h:Number;
		private var _w:Number;
		
		private var _loaded:Boolean=false;
		private var _mediaType:MediaType;
		
		private var _player:MediaPlayerSprite;
		private var settings:Config;
		//TODO : Remove this variable (used for the audio description shell functionality)
		private var _audioDesc:Boolean = false;

		/**
		 *
		 */
		public function Main()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		

		public function Play():void
		{
			_player.mediaPlayer.play();
		}
		
		public function Pause():void
		{
			_player.mediaPlayer.pause();
		}
		
		public function Paused():Boolean
		{
			return !_player.mediaPlayer.playing;
		}
		
		public function CurrentTime():Number
		{
			return _player.mediaPlayer.currentTime
		}
		
		public function SetCurrentTime(newTime:Number):void
		{
			if (_player.mediaPlayer.canSeekTo(newTime) || newTime < 0)
			{
				if (newTime >= _player.mediaPlayer.duration)
				{
					_player.mediaPlayer.seek(_player.mediaPlayer.duration);
				}
				else if (newTime < 0)
				{
					_player.mediaPlayer.seek(0);
					_player.mediaPlayer.stop();
					onComplete(null);
				}
				else
				{
					_player.mediaPlayer.seek(newTime);
				}
			}
		}
		
		public function Duration():Number
		{
			return _player.mediaPlayer.duration;
		}
		
		public function Seeking():Boolean
		{
			return _player.mediaPlayer.seeking;
		}
		
		public function Buffered():Number
		{
			return _player.mediaPlayer.bufferLength;
		}
		
		public function Volume():Number
		{
			return _player.mediaPlayer.volume;
		}
		
		public function SetVolume(volume:Number):void
		{
			_player.mediaPlayer.volume = volume;
		}
		
		public function Muted():Boolean
		{
			return _player.mediaPlayer.muted;
		}
		
		public function SetMuted(muted:Boolean):void
		{
			_player.mediaPlayer.muted = muted;
		}
		
		
		
		/**
		 *  Listeners and State functions
		 * */
		
		private function init(evt:Event):void
		{
			Security.allowDomain("*");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// Stage alignment needs to be reset since the OSMF media player uses the scalemode to draw
			//  the elements on the stage. It centers by default which causes problems for SWF dynamic sizing
			stage.addEventListener(Event.RESIZE, OnStageResize);
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.align=StageAlign.TOP_LEFT;
			
			
			// Create a loader file that contains all the config parameters
			// add some defaults to the parameters that are not apparent
			settings=new Config(loaderInfo.parameters);
			// set the canvas area dimensions ( this is a redundant way of doing this, we need to find a way to call the expected height and width from the loader more elegantly )
			_h=int(settings.getParameter("height"));
			_w=int(settings.getParameter("width"));
			// since the ExternalInterface library for flash needs the embed tag inorder to identify its self in the HTML DOM, we will feed it its id, since we cannot use embed tag for compliance
			_id=settings.getParameter("id");
			
			// start creating the video player
			// we need to set some default rules 
			
			_player=new MediaPlayerSprite();
			_player.mediaPlayer.addEventListener(LoadEvent.BYTES_LOADED_CHANGE, onBytesUpdate);
			_player.mediaPlayer.addEventListener(BufferEvent.BUFFERING_CHANGE, onBufferUpdate);
			_player.mediaPlayer.addEventListener(PlayEvent.PLAY_STATE_CHANGE, onPlayStateChange);
			_player.mediaPlayer.addEventListener(TimeEvent.CURRENT_TIME_CHANGE, onTimeUpdate);
			_player.mediaPlayer.addEventListener(AudioEvent.MUTED_CHANGE, onVolumeChange);
			_player.mediaPlayer.addEventListener(AudioEvent.VOLUME_CHANGE, onVolumeChange);
			_player.mediaPlayer.addEventListener(TimeEvent.COMPLETE, onComplete);
			_player.mediaPlayer.autoPlay=settings.getParameter("autoplay") as Boolean;
			_player.mediaPlayer.autoDynamicStreamSwitch = true;
			_player.mediaPlayer.volume=Number(settings.getParameter("volume"));
			_player.scaleMode=settings.getScaleMode();
			
			// Set the dimensions since we know them from the loader object
			_player.width=_w;
			_player.height=_h;
			// Put the video sprite to stage
			_player.resource=new URLResource(settings.getParameter("media"));
			addChild(_player);
			
			// load poster image for the multimedia
			
			var imgLoader:Loader=new Loader();
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnImgComplete);
			imgLoader.load(new URLRequest(settings.getParameter("posterimg")));
			imgLoader.name="posterimg";
			addChild(imgLoader);
			
			registerCallbacks();
			// call the resize to deal with pagezoom issues identified
			OnStageResize(null);
		}
		
		private function registerCallbacks():void
		{
			ExternalInterface.addCallback("play", Play);
			ExternalInterface.addCallback("pause", Pause);
			ExternalInterface.addCallback("paused", Paused);
			ExternalInterface.addCallback("currentTime", CurrentTime);
			ExternalInterface.addCallback("setCurrentTime", SetCurrentTime);
			ExternalInterface.addCallback("duration", Duration);
			ExternalInterface.addCallback("seeking", Seeking);
			ExternalInterface.addCallback("buffered", Buffered);
			ExternalInterface.addCallback("volume", Volume);
			ExternalInterface.addCallback("setVolume", SetVolume);
			ExternalInterface.addCallback("muted", Muted);
			ExternalInterface.addCallback("setMuted", SetMuted);
			
			//ExternalInterface.addCallback("toggleAudioDescription", toggleAudioDescription);
		}
		
		/**
		 *  Event bindings for various components
		 */
		
		private function resizeVideo():void
		{
			this._player.width=stage.stageWidth;
			this._player.height=stage.stageHeight;
			Utils.center(stage.stageWidth, stage.stageHeight, this._player);
		}
		
		/**
		 *  We need to introduce scaling for people that use zoom features in browsers
		 * */
		private function OnStageResize(evt:Event):void
		{
			// For the meantime we will do independant scaling. The next beta release will extend the resize each Object through state calls
			
			_player.width=getChildByName("canvas").width=getChildByName("posterimg").width=stage.stageWidth;
			_player.height=getChildByName("canvas").height=getChildByName("posterimg").height=stage.stageHeight;
		}
		
		private function OnImgComplete(event:Event):void
		{
			var imageLoader:Loader=Loader(event.target.loader);
			Utils.resizeMe(imageLoader, stage.stageWidth, stage.stageHeight, false);
			Bitmap(imageLoader.content).smoothing=true;
		}
		
		private function onBytesUpdate(evt:LoadEvent):void
		{
			//ExternalInterface.call("mPlayerRemote.update", this._id, "loaded", Math.floor((evt.target.bytesLoaded / evt.target.bytesTotal) * 100));
		}
		
		private function onBufferUpdate(evt:BufferEvent):void
		{
			//ExternalInterface.call("mPlayerRemote.update", this._id, "buffer", evt.target.bufferLength);
		}

		private function onPlayStateChange(evt:PlayEvent):void
		{
			if (_player.mediaPlayer.playing)
			{
				ExternalInterface.call("setTimeout", "pe.triggermediaevent('" + this._id + "', 'play')", 0);
				ExternalInterface.call("setTimeout", "pe.triggermediaevent('" + this._id + "', 'playing')", 0);
				if (_player.media is AudioElement)
				{
					getChildByName("posterimg").visible=true;
				}
				else
				{
					getChildByName("posterimg").visible=false;
				}
			}
			else
			{
				ExternalInterface.call("setTimeout", "pe.triggermediaevent('" + this._id + "', 'pause')", 0);
				getChildByName("playbutton").visible=true;
			}
		}

		private function onTimeUpdate(evt:TimeEvent):void
		{
				ExternalInterface.call("setTimeout", "pe.triggermediaevent('" + this._id + "', 'timeupdate')", 0);
		}
		
		private function onVolumeChange(evt:AudioEvent):void
		{
			ExternalInterface.call("setTimeout", "pe.triggermediaevent('" + this._id + "', 'volumechange')", 0);
		}

		private function onComplete(evt:TimeEvent):void
		{
			ExternalInterface.call("setTimeout", "pe.triggermediaevent('" + this._id + "', 'ended')", 0);
			//getChildByName("posterimg").visible=true;
		}

		
		// toggleAudioDescription : toggle the audio description track
		/*private function toggleAudioDescription(evt:Event):void
		{
			//TODO: Functionality to enable audio description
			_audioDesc = !_audioDesc;
			//ExternalInterface.call("mPlayerRemote.update", this._id, (this._audioDesc) ? "audiodescription" : "noaudiodescription");
		}*/
	}

}