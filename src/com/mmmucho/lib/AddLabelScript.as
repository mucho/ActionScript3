package com.mmmucho.lib 
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Scene;

	public function AddLabelScript(mc:MovieClip, label:*, func:Function = null, arg:Array = null):void
	{
		var frms:Array = [];
		var f:Function;
		if(func != null){
			f = function():void{ func.apply(mc, arg); };
		}

		if (label is Number) {
			frms.push(int(label));
		} else if(label is String) {
			var ss:Array = mc.scenes;
			for each(var s:Scene in ss) {
				var ls:Array = s.labels;
				for each(var l:FrameLabel in ls) {
					if (l.name == label) {
						frms.push(l.frame);
					}
				}
			}
		}

		for (var i:int = 0; i < frms.length; i++ ) {
			var frm = frms[i];
			if (frm > 0 && frm <= mc.totalFrames) {
				mc.addFrameScript(frm, f);
			}
		}
	}
}