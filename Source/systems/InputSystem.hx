/*
 * Author: Richard Lord
 * Copyright (c) Big Room Ventures Ltd. 2007
 * Version: 1.0.2
 * Modified and extended by: Tilman Schmidt (@KeyMaster_)
 * - Fixed key buffer size to contain enough bits for all keys
 * - Added buffering for entity component system framework
 * - Added keyUp and keyDown lookups
 *
 * Licence Agreement
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package systems;

import ash.core.Engine;
import ash.core.System;
import haxe.io.Bytes;
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.geom.Point;
class InputSystem extends System {
	var keyPressed:Bytes;
	var keyUp:Bytes;
	var keyDown:Bytes;
	
	var keyPressedBuffer:Bytes;
	var keyUpBuffer:Bytes;
	var keyDownBuffer:Bytes;
	
	var container:DisplayObject;
	
	var mouseMovedBuffer:Bool = false;
	public var mouseMoved:Bool = false;
	
	var mousePosBuffer:Point;
	public var mousePos(default, null):Point;
	
	var mouseDownBuffer:Bool = false;
	var mouseUpBuffer:Bool = false;
	var mousePressedBuffer:Bool = false;
	
	public var mouseDown(default, null):Bool = false;
	public var mouseUp(default, null):Bool = false;
	public var mousePressed(default, null):Bool = false;
	
	public function new(container:DisplayObject) {
		super();
		this.container = container;
		
		keyPressed = Bytes.alloc(28);
		keyUp = Bytes.alloc(28);
		keyDown = Bytes.alloc(28);
		
		keyPressedBuffer = Bytes.alloc(28);
		keyUpBuffer = Bytes.alloc(28);
		keyDownBuffer = Bytes.alloc(28);
		
		mousePos = new Point( container.mouseX, container.mouseY);
		mousePosBuffer = new Point( -1, -1);
		
		this.container.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
		this.container.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
		this.container.addEventListener(Event.ACTIVATE, actiDeactiListener);
		this.container.addEventListener(Event.DEACTIVATE, actiDeactiListener);
		this.container.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
		this.container.addEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
		this.container.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
		
	}
	
	override public function update(time:Float):Void {
		
		for (i in 0...28) {
			keyPressed.set(i, keyPressedBuffer.get(i));
			keyUp.set(i, keyUpBuffer.get(i));
			keyDown.set(i, keyDownBuffer.get(i));
			keyUpBuffer.set(i, 0);
			keyDownBuffer.set(i, 0);
		}
		
		mouseMoved = mouseMovedBuffer;
		mouseMovedBuffer = false;
		
		if (mouseMoved) {
			mousePos.x = mousePosBuffer.x;
			mousePos.y = mousePosBuffer.y;
			mousePosBuffer.x = -1;
			mousePosBuffer.y = -1;
		}
		
		mouseDown = mouseDownBuffer;
		mouseDownBuffer = false;
		mouseUp = mouseUpBuffer;
		mouseUpBuffer = false;
		
		mousePressed = mousePressedBuffer;
		
	}
	
	public function getKeyPressed(keyCode:Int):Bool {
		return (keyPressed.get(keyCode >>> 3) & (1 << ((keyCode - 1) & 7))) != 0;
	}
	
	public function getKeyUp(keyCode:Int):Bool {
		return (keyUp.get(keyCode >>> 3) & (1 << ((keyCode - 1) & 7))) != 0;
	}
	
	public function getKeyDown(keyCode:Int):Bool {
		return (keyDown.get(keyCode >>> 3) & (1 << ((keyCode - 1) & 7))) != 0;
	}
	
	function keyDownListener(ev:KeyboardEvent):Void {
		var pos:Int = ev.keyCode >>> 3;
        keyDownBuffer.set(pos, keyDownBuffer.get(pos) | 1 << ((ev.keyCode - 1) & 7));
        keyPressedBuffer.set(pos, keyPressedBuffer.get(pos) | 1 << ((ev.keyCode - 1) & 7));
	}
	
	function keyUpListener(ev:KeyboardEvent):Void {
		var pos:Int = ev.keyCode >>> 3;
        keyUpBuffer.set(pos, keyUpBuffer.get(pos) | 1 << ((ev.keyCode - 1) & 7));
        keyPressedBuffer.set(pos, keyPressedBuffer.get(pos) & ~(1 << ((ev.keyCode - 1) & 7)));
	}
	
	function mouseMoveListener(ev:MouseEvent) {
		mousePosBuffer.x = ev.stageX;
		mousePosBuffer.y = ev.stageY;
		mouseMovedBuffer = true;
	}
	
	function mouseDownListener(ev:MouseEvent) {
		mouseDownBuffer = true;
		mousePressedBuffer = true;
		mousePosBuffer.x = ev.stageX;
		mousePosBuffer.y = ev.stageY;
	}
	
	function mouseUpListener(ev:MouseEvent) {
		mouseUpBuffer = true;
		mousePressedBuffer = false;
		
		mousePosBuffer.x = ev.stageX;
		mousePosBuffer.y = ev.stageY;
	}
	
	function actiDeactiListener(ev:Event):Void {
		for (i in 0...28) {
			keyPressed.set(i, 0);
			keyDown.set(i, 0);
			keyUp.set(i, 0);
			keyPressedBuffer.set(i, 0);
			keyUpBuffer.set(i, 0);
			keyDownBuffer.set(i, 0);
		}
		mousePos.x = -1;
		mousePos.y = -1;
		mousePosBuffer.x = -1;
		mousePosBuffer.y = -1;
		
		mouseDown = false;
		mouseDownBuffer = false;
		
		mouseUp = false;
		mouseUpBuffer = false;
		
		mousePressed = false;
		mousePressedBuffer = false;
	}
}