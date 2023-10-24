package flixel.util;

import flixel.util.FlxDestroyUtil.IFlxDestroyable;

/**
 * A generic container that facilitates pooling and recycling of objects.
 * WARNING: Pooled objects must have parameter-less constructors: function new()
 */
#if !display
@:generic
#end
class FlxPool<T:IFlxDestroyable> implements IFlxPool<T>
{
	public var length(get, never):Int;

	var _pool:Array<T> = [];
	var _class:Class<T>;
	//var balance = 0;
	//var made = 0;
	//var putted = 0;
	//var gotten = 0;

	/**
	 * Objects aren't actually removed from the array in order to improve performance.
	 * _count keeps track of the valid, accessible pool objects.
	 */
	var _count:Int = 0;

	public function new(classObj:Class<T>)
	{
		_class = classObj;
	}

	public function get():T
	{
		//balance--;
		if (_count == 0)
		{
			//made++;
			return Type.createInstance(_class, []);
		}
		//gotten++;
		return _pool[--_count];
	}

	public function put(obj:T):Void
	{
		// we don't want to have the same object in the accessible pool twice (ok to have multiple in the inaccessible zone)
		if (obj != null)
		{
			var i:Int = _pool.indexOf(obj);
			// if the object's spot in the pool was overwritten, or if it's at or past _count (in the inaccessible zone)
			if (i == -1 || i >= _count)
			{
				//balance++;
				//putted++;
				obj.destroy();
				_pool[_count++] = obj;
			}
		}
	}

	public function putUnsafe(obj:T):Void
	{
		if (obj != null)
		{
			//balance++;
			//putted++;
			obj.destroy();
			_pool[_count++] = obj;
		}
	}

	public function preAllocate(numObjects:Int):Void
	{
		while (numObjects-- > 0)
		{
			//balance++;
			//made++;
			//putted++;
			_pool[_count++] = Type.createInstance(_class, []);
		}
	}

	public function clear():Array<T>
	{
		_count = 0;
		var oldPool = _pool;
		_pool = [];
		return oldPool;
	}

	inline function get_length():Int
	{
		return _count;
	}
}

interface IFlxPooled extends IFlxDestroyable
{
	function put():Void;
}

interface IFlxPool<T:IFlxDestroyable>
{
	function preAllocate(numObjects:Int):Void;
	function clear():Array<T>;
}
