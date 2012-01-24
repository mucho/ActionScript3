package com.mmmucho.lib 
{

	public class Color extends Object
	{
		static private const _ARGB_MAX:int = 255;
		static private const _H_MAX:int = 360;
		static private const _SV_MAX:int = 1;
		private var _alpha:int;
		private var _red:int;
		private var _green:int;
		private var _blue:int;
		private var _hue:Number;
		private var _saturation:Number;
		private var _brightness:Number;

		//------------------------------------------------------------------------------
		// Getter/Setters
		//------------------------------------------------------------------------------
		public function get a():Number 
		{
			return _alpha / 255;
		}
		
		public function set a(value:Number):void 
		{
			_alpha = Math.max(0, Math.min(_ARGB_MAX, int(value*_ARGB_MAX)));
		}
		
		public function get r():Number 
		{
			return _red / 255;
		}
		
		public function set r(value:Number):void 
		{
			_red = Math.max(0, Math.min(_ARGB_MAX, int(value * _ARGB_MAX)));
			fromRGB();
		}
		
		public function get g():Number 
		{
			return _green / 255;
		}
		
		public function set g(value:Number):void 
		{
			_green = Math.max(0, Math.min(_ARGB_MAX, int(value * _ARGB_MAX)));
			fromRGB();
		}
		
		public function get b():Number 
		{
			return _blue / 255;
		}
		
		public function set b(value:Number):void 
		{
			_blue = Math.max(0, Math.min(_ARGB_MAX, int(value * _ARGB_MAX)));
			fromRGB();
		}

		public function get h():Number
		{
			return _hue;
		}
		
		public function set h(value:Number):void
		{
			while (value < 0) {
				value += _H_MAX;
			}
			_hue = value % _H_MAX;
			fromHSV();
		}
		
		public function get s():Number
		{
			return _saturation;
		}
		
		public function set s(value:Number):void
		{
			_saturation = Math.max(0, Math.min(_SV_MAX, value));
			fromHSV();
		}
		
		public function get v():Number {
			return _brightness;
		}
		
		public function set v(value:Number):void
		{
			_brightness = Math.max(0, Math.min(_SV_MAX, value));
			fromHSV();
		}
		
		public function get argb():uint 
		{
			var color:uint = _alpha << 24 | _red << 16 | _green << 8 | _blue;
			return color;
		}
		
		public function set argb(value:uint):void 
		{
			_alpha = value >> 24;
			_red = value >> 16 & 0xff;
			_green = value >> 8 & 0xff;
			_blue = value & 0xff;
			fromRGB();
		}
		
		public function get rgb():uint 
		{
			var color:uint = _red << 16 | _green << 8 | _blue;
			return color;
		}
		
		public function set rgb(value:uint):void 
		{
			_red = value >> 16 & 0xff;
			_green = value >> 8 & 0xff;
			_blue = value & 0xff;
			fromRGB();
		}

		//------------------------------------------------------------------------------
		// Constructor
		//------------------------------------------------------------------------------
		public function Color(alpha:Number = 0, red:Number = 0, green:Number = 0, blue:Number = 0 )
		{
			_hue = 0;
			a = alpha;
			r = red;
			g = green;
			b = blue;
		}
		
		private function fromRGB():void
		{
			var max:int = Math.max(Math.max(_red, _green), _blue);
			var min:int = Math.min(Math.min(_red, _green), _blue);
			var dif:int = max - min;
			if ( max == 0 ) {
				//_hue = 0;
				//_saturation = 0;
				_brightness = 0;
			}else if (dif == 0) { 
				_saturation = 0;
				_brightness = max / 255;
			} else {
				if ( _red >= _green && _red > _blue ) {
					_hue = 60.0 * (_green - _blue) / dif;
				} else if ( _green >= _blue && _green > _red ) {
					_hue = 60.0 * (_blue - _red) / dif + 120.0;
				} else if ( _blue >= _red && b > _green ) {
					_hue = 60.0 * (_red - _green) / dif + 240.0;
				}
				if ( _hue < 0.0 ) _hue += _H_MAX;
				_hue = _hue % _H_MAX;
				_saturation = dif / max;
				_brightness = max / 255;
			}
    }
		
		private function fromHSV():void
		{
			if (_saturation==0) {
				_red = _green = _blue = int(_brightness * _ARGB_MAX);
			}else {
				var hi:int = int(_hue / (_H_MAX / 6)) % 6;
				var f:Number = _hue / (_H_MAX / 6) - hi;
				var v:Number = _brightness;
				var p:Number = _brightness / ( 1 - _saturation );
				var q:Number = _brightness / ( 1 - _saturation * f);
				var t:Number = _brightness / ( 1 - _saturation * ( 1 - f));
				var r:Number;
				var g:Number;
				var b:Number;
				switch (hi) { 
					case 0 :
						r = v;
						g = t;
						b = p;
						break; 
					case 1 : 
						r = q;
						g = v;
						b = p;
						break; 
					case 2 : 
						r = p;
						g = v;
						b = t;
						break; 
					case 3 : 
						r = p;
						g = q;
						b = v;
						break; 
					case 4 : 
						r = t;
						g = p;
						b = v;
						break; 
					case 5 : 
						r = v;
						g = p;
						b = q;
						break; 
				}
				_red = int(r * _ARGB_MAX);
				_green = int(g * _ARGB_MAX);
				_blue = int(b * _ARGB_MAX);
			}
		}

	}

}