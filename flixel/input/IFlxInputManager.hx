package flixel.input;

import flixel.util.FlxDestroyUtil.IFlxDestroyable;

@:allow(flixel.system.frontEnds.InputFrontEnd)
interface IFlxInputManager extends IFlxDestroyable
{
	function reset():Void;
	function update():Void;
	function onFocus():Void;
	function onFocusLost():Void;
}
