/*
 * Web Experience Toolkit (WET) / Boîte à outils de l'expérience Web (BOEW)
 * wet-boew.github.io/wet-boew/License-eng.html / wet-boew.github.io/wet-boew/Licence-fra.html
 */

package org.wet_boew.wet_boew_multimedia_fallback
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

		import org.osmf.events.MediaPlayerStateChangeEvent;
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

				private var _loaded:Boolean=false;
				private var _mediaType:MediaType;

				private var poster:Loader;
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
						if (_player.mediaPlayer.canSeek){
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
				 * Listeners and State functions
				 * */

				private function init(evt:Event):void
				{

						Security.allowDomain("*");
						removeEventListener(Event.ADDED_TO_STAGE, init);
						// Stage alignment needs to be reset since the OSMF media player uses the scalemode to draw
						// the elements on the stage. It centers by default which causes problems for SWF dynamic sizing
						stage.addEventListener(Event.RESIZE, OnStageResize);
						stage.scaleMode=StageScaleMode.NO_SCALE;
						stage.align=StageAlign.TOP_LEFT;

						// Create a loader file that contains all the config parameters
						// add some defaults to the parameters that are not apparent
						settings=new Config(loaderInfo.parameters);

						// since the ExternalInterface library for flash needs the embed tag inorder to identify its self in the HTML DOM, we will feed it its id, since we cannot use embed tag for compliance
						_id=settings.getParameter("id");

						// start creating the video player
						_player=new MediaPlayerSprite();
						_player.mediaPlayer.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onStateChange);
						_player.mediaPlayer.addEventListener(TimeEvent.DURATION_CHANGE, onDurationChange);
						_player.mediaPlayer.addEventListener(TimeEvent.CURRENT_TIME_CHANGE, onTimeUpdate);
						_player.mediaPlayer.addEventListener(AudioEvent.MUTED_CHANGE, onVolumeChange);
						_player.mediaPlayer.addEventListener(AudioEvent.VOLUME_CHANGE, onVolumeChange);
						_player.mediaPlayer.addEventListener(TimeEvent.COMPLETE, onComplete);
						_player.mediaPlayer.autoPlay=settings.getParameter("autoplay") as Boolean;
						_player.mediaPlayer.autoDynamicStreamSwitch = true;
						_player.mediaPlayer.volume=Number(settings.getParameter("volume"));
						_player.scaleMode=settings.getScaleMode();
						_player.height=stage.stageHeight;
						_player.width=stage.stageWidth;

						// Put the video sprite to stage
						_player.resource=new URLResource(settings.getParameter("media"));
						addChild(_player);

						// load poster image for the multimedia

						poster=new Loader();
						poster.load(new URLRequest(settings.getParameter("posterimg")));
						poster.contentLoaderInfo.addEventListener(Event.COMPLETE, OnImgComplete);
						poster.name="posterimg";
						addChild(poster);

						registerCallbacks();
				}

				private function registerCallbacks():void
				{
						ExternalInterface.addCallback("play", Play);
						ExternalInterface.addCallback("doPlay", Play);
						ExternalInterface.addCallback("pause", Pause);
						ExternalInterface.addCallback("doPause", Pause);
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
				 * Event bindings for various components
				 */

				/**
				 * We need to introduce scaling for people that use zoom features in browsers
				 * */
				private function OnStageResize(evt:Event):void
				{
						this.poster.width=stage.stageWidth;
						this.poster.height=stage.stageHeight;
						this._player.width=stage.stageWidth;
						this._player.height=stage.stageHeight;
				}

				private function OnImgComplete(event:Event):void
				{
						var poster:Loader=Loader(event.currentTarget.loader);
						poster.width=stage.stageWidth;
						poster.height=stage.stageHeight;
				}

				private function onStateChange(evt:MediaPlayerStateChangeEvent ):void
				{
						if (evt.state == MediaPlayerState.PLAYING)
						{
								ExternalInterface.call("setTimeout", "jQuery('#" + this._id + " :first-child').trigger('canplay')", 0);
								ExternalInterface.call("setTimeout", "jQuery('#" + this._id + " :first-child').trigger('play')", 0);
								ExternalInterface.call("setTimeout", "jQuery('#" + this._id + " :first-child').trigger('playing')", 0);
								if (_player.media is AudioElement)
								{
										getChildByName("posterimg").visible=true;
								}
								else
								{
										getChildByName("posterimg").visible=false;
								}
						}
						else if (evt.state == MediaPlayerState.PAUSED)
						{
								ExternalInterface.call("setTimeout", "jQuery('#" + this._id + " :first-child').trigger('pause')", 0);
								getChildByName("playbutton").visible=true;
						}
						else if (evt.state == MediaPlayerState.BUFFERING)
						{
								ExternalInterface.call("setTimeout", "jQuery('#" + this._id + " :first-child').trigger('waiting')", 0);
								getChildByName("playbutton").visible=true;
						}
				}

				private function onDurationChange(evt:TimeEvent):void
				{
						if (evt.target.duration > 0){
								ExternalInterface.call("setTimeout", "jQuery('#" + this._id + " :first-child').trigger('durationchange')", 0);
						}
				}

				private function onTimeUpdate(evt:TimeEvent):void
				{
								ExternalInterface.call("setTimeout", "jQuery('#" + this._id + " :first-child').trigger('timeupdate')", 0);
				}

				private function onVolumeChange(evt:AudioEvent):void
				{
						ExternalInterface.call("setTimeout", "jQuery('#" + this._id + " :first-child').trigger('volumechange')", 0);
				}

				private function onComplete(evt:TimeEvent):void
				{
						ExternalInterface.call("setTimeout", "jQuery('#" + this._id + " :first-child').trigger('ended')", 0);
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