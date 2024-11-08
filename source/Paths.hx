package;

import flixel.graphics.frames.FlxAtlasFrames;

class Paths
{
	public static final rootPath = "assets";

	public static inline function image(path:String)
		return '$rootPath/images/$path.png';

	public static inline function xml(path:String)
		return '$rootPath/images/$path.xml';

	public static inline function json(path:String)
		return '$rootPath/data/$path.json';

	public static inline function audio(path:String)
		return '$rootPath/$path.ogg';

	public static inline function sparrow(path:String)
		return FlxAtlasFrames.fromSparrow('assets/images/$path.png', 'assets/images/$path.xml');
}
