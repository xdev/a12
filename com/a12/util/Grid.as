/* $Id$ */

package com.a12.util
{

	import com.a12.util.Utils;

	public class Grid
	{

		private var _gridXArray:Array;
		private var _gridYArray:Array;
		private var _grid:MovieClip;
		private var _stageListener:Object;
		private var _keyListener:Object;
		private var _center:Boolean; // <--- set to 'True' if you want the grid to align center during stage resize
		private var _w:Number;
		private var _h:Number;
	
		public function Grid(clr, w, h, a)
		{
			_root.createEmptyMovieClip("_grid", 999999);
			_root._grid._alpha = 30;
		
			Utils.changeColor(_root._grid, clr);
		
			_center = a;
			_w = w;
			_h = h;
		
			_gridXArray = [];
			_gridYArray = [];
		
			enableStageListener();
			enableKeyListener();
		}
	
		public function addX(gridArray:Array) : Void
		{
			var len = gridArray.length
			for(var i=0;i<len;i++) {
				_gridXArray.push(gridArray[i]);
			}
			drawGrid();
		}
	
		public function addY(gridArray)
		{
			var len = gridArray.length
			for(var i=0;i<len;i++) {
				_gridYArray.push(gridArray[i]);
			}
			drawGrid();
		}
	
		private function enableStageListener():Void
		{
			// stage resize listener
			_stageListener = new Object();
			_stageListener._scope = this;
			_stageListener.onResize = function() {
				this._scope.drawGrid();
			}
			Stage.addListener(_stageListener);
		}
	
		private function enableKeyListener():Void
		{
			_keyListener = new Object();
			_keyListener._scope = this;
			_keyListener.onKeyDown = function() {
				//trace("DOWN -> Code: "+Key.getCode()+"\tACSII: "+Key.getAscii()+"\tKey: "+chr(Key.getAscii()));
				if (Key.getCode() == 71 && Key.isDown(17)) {
					this._scope.showGrid();
				}
			}
			_keyListener.onKeyUp = function() {
				//trace("UP -> Code: "+Key.getCode()+"\tACSII: "+Key.getAscii()+"\tKey: "+chr(Key.getAscii()));
				if (Key.getCode() == 71) {
					this._scope.hideGrid();
				}
			}
			Key.addListener(_keyListener);
		}
	
		private function drawGrid()
		{
		
			if (_center) {
				var xoff = Math.round((Stage.width - _w) / 2);
				var yoff = Math.round((Stage.height - _h) / 2);
			} else {
				var xoff = 0;
				var yoff = 0;
			}
		
			var len = _gridXArray.length;
			for (var i=0;i<len;i++) {
				_root._grid.createEmptyMovieClip("x"+i, i);
				_root._grid["x"+i].lineStyle(0, 0xFFFFFF, 100);
				_root._grid["x"+i].moveTo(_gridXArray[i] + xoff, 0);
				_root._grid["x"+i].lineTo(_gridXArray[i] + xoff, Stage.height);
			}
		
			var len = _gridYArray.length;
			for (var i=0;i<len;i++) {
				_root._grid.createEmptyMovieClip("y"+i, _gridXArray.length + i);
				_root._grid["y"+i].lineStyle(0, 0xFFFFFF, 100);
				_root._grid["y"+i].moveTo(0, _gridYArray[i] + yoff);
				_root._grid["y"+i].lineTo(Stage.width, _gridYArray[i] + yoff);
			}
		}
	
		public function showGrid() : Void
		{
			_root._grid._visible = 1;
		}
	
		public function hideGrid() : Void
		{
			_root._grid._visible = 0;
		}

	}

}