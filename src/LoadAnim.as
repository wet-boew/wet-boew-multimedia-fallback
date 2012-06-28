/*!
 * Web Experience Toolkit (WET) / Boîte à outils de l'expérience Web (BOEW)
 * www.tbs.gc.ca/ws-nw/wet-boew/terms / www.sct.gc.ca/ws-nw/wet-boew/conditions
 */

package
{
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;

	public class LoadAnim extends Sprite
	{

		private var _anim:Sprite;
		private var _rotate:Number=0;
		private var _animTimer:Timer;
		private var _animColor:Number;

		public function LoadAnim(color:Number=0xFFFFFF)
		{
			_animColor=color;
			_anim=new Sprite();
			addChild(_anim);
			makeAnim();
		}

		public function stopAnim():void
		{
			removeChild(_anim);
			_animTimer.removeEventListener(TimerEvent.TIMER, rotateMe);
			_animTimer.stop();
		}

		private function makeAnim():void
		{
			renderAnime();

			_animTimer=new Timer(70);
			_animTimer.addEventListener(TimerEvent.TIMER, rotateMe);
			_animTimer.start();

		}

		private function rotateMe(evt:TimerEvent):void
		{

			_rotate=_rotate + 30;
			if (_rotate == 360)
				_rotate=0;
			//trace("timer " + _rotate);
			renderAnime(_rotate);
		}

		private function renderAnime(startAng:Number=0):void
		{
			clearAnim();
			var theStar:Sprite=new Sprite()
			for (var i:uint=0; i <= 12; i++)
			{
				var theShape:Sprite=getShape();
				theShape.rotation=(i * 30) + startAng;
				theShape.alpha=0 + (1 / 12 * i);
				theStar.addChild(theShape);
			}
			_anim.addChild(theStar);
		}

		private function clearAnim():void
		{
			if (_anim.numChildren == 0)
				return;
			_anim.removeChildAt(0);
		}

		private function getShape():Sprite
		{
			var shape:Sprite=new Sprite();
			shape.graphics.beginFill(_animColor, 1);
			shape.graphics.moveTo(-1, -12);
			shape.graphics.lineTo(2, -12);
			shape.graphics.lineTo(1, -5);
			shape.graphics.lineTo(0, -5);
			shape.graphics.lineTo(-1, -12);
			shape.graphics.endFill();
			return shape;
		}
	}

}

