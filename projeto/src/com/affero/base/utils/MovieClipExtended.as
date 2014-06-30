
package com.affero.base.utils {
	import flash.display.FrameLabel;
	import flash.display.MovieClip;

	public class MovieClipExtended extends MovieClip {
		
		public const FRAME_SCRIPT_LABEL:String = '_FrameScript';
		
		public var target:MovieClip;
		
		public function MovieClipExtended(target:MovieClip) {
			if (!target)
				throw new ArgumentError('mc: target cannot be null');
				
			this.target = target;
		}
		
		public function addLabelScript(labelName:String, script:Function):MovieClipExtended {
			for each (var label:FrameLabel in this.target.currentLabels) {
				if (label.name === labelName) {
					this.target.addFrameScript(label.frame - 1, script);
					return this;
				}
			}
			
			throw new Error('mc.addLabelScript: label "' + labelName + '" not found on target ' + this.target);
			return this;
		}
		
		public function everyLabelScript(script:Function):MovieClipExtended {
			for each (var label:FrameLabel in this.target.currentLabels) {
				this.target.addFrameScript(label.frame - 1, script);
			}
			
			return this;
		}
		
		public function everyFrameScript(script:Function):MovieClipExtended {
			for (var i:uint = 0; i < this.target.totalFrames; ++i) {
				this.target.addFrameScript(i, script);
			}
			
			return this;
		}
		
		public function setupTimelineScripts():MovieClipExtended {
			for each (var label:FrameLabel in this.target.currentLabels) {
				if (label.name.lastIndexOf(FRAME_SCRIPT_LABEL) === label.name.length - FRAME_SCRIPT_LABEL.length) {
					if (this.target.hasOwnProperty(label.name)) {
						this.target.addFrameScript(label.frame - 1, this.target[label.name]);
					} else {
						throw new Error('mc.setupTimelineScripts: script "' + label.name + '" not found on target' + this.target);
					}
				}
			}
			
			return this;
		}

	}
}
