// ===== Values to easily find pointer paths =====
// first byte of the timer will be 255 while in spawn point, outside it resets to 0.
// spawn point seems to be [-11200, -10448]
// ===== Other notes =====
// the only progress percentage value that I could find updates on pogo collision. This is not good for firing off splits as it fires differently depending on where you land.. 

state("Pogostuck", "1RL - PATCH 10")
{
	//pointer dangles when paused with esc. Fine if paused with controller. Shouldn't be much of an issue, it fixes next time. All other paths invalidate randomly. 
    byte is_in_start_zone : "Pogostuck.exe", 0x00019AB1, 0x10, 0x592;
    byte time_ms : "Pogostuck.exe", 0x00019AB1, 0x10, 0x593;
    byte time_s : "Pogostuck.exe", 0x00019AB1, 0x10, 0x594;
    byte time_m : "Pogostuck.exe", 0x00019AB1, 0x10, 0x595;
    byte time_h : "Pogostuck.exe", 0x00019AB1, 0x10, 0x596;
	float pogo_x : "acknex.dll", 0x005809D8, 0x218, 0x8, 0xC, 0x2C, 0x3DC;
	float pogo_y : "acknex.dll", 0x005809D8, 0x218, 0x8, 0xC, 0x2C, 0x3E4;
}

init
{
	switch(modules.First().ModuleMemorySize)
	{
		case 348160:
			version = "1RL - PATCH 10";
			break;
		default:
			version = "1RL - PATCH 10";
			break;
	}
	refreshRate = 120;
}

startup
{
	settings.Add("first_banana", true, "First Banana");
	settings.Add("last_banana", true, "Last Banana");
	settings.Add("big_bone", true, "Big Bone");
	settings.Add("poes_peak", true, "Poe's Peak");
	settings.Add("cave", true, "Cave");
	settings.Add("twin_trees", true, "Twin Trees");
	settings.Add("cliff_banana", true, "Grapes Cliff");
	settings.Add("half_grapes", true, "Half Grapes");	
	settings.Add("tree_branch", true, "Tree Branch");

	settings.Add("egg", true, "Egg");
}

reset
{
	if(old.is_in_start_zone == 0 && current.is_in_start_zone == 255) {
		vars.first_banana = 0;
		vars.last_banana = 0;
		vars.big_bone = 0;
		vars.poes_peak = 0;
		vars.cave = 0;
		vars.twin_trees = 0;
		vars.cliff_banana = 0;
		vars.half_grapes = 0;
		vars.tree_branch = 0;

		vars.egg = 0;

		return true;
	}
}


update
{
	//print(modules.First().ModuleMemorySize.ToString());
	//print("startzone: " + current.is_in_start_zone.ToString());
	//print("ms: " + current.time_ms.ToString());
	//print("s: " + current.time_s.ToString());
	//print("m: " + current.time_m.ToString());
	//print("h: " + current.time_h.ToString());
	print("pogo_x: " + current.pogo_x.ToString());
	print("pogo_y: " + current.pogo_y.ToString());
}

gameTime
{
    return TimeSpan.FromMilliseconds(((byte)(249 * (current.time_ms / 255f))) + (250 * current.time_s) + (64000 * current.time_m) + (16384000 * current.time_h));
}

split
{	
	// x: -7623 y: -9834
	if (vars.first_banana == 0 && (current.pogo_x > -7623f))
	{
		vars.first_banana = 1;
		return settings["first_banana"];
	}

	// x: -6091 y: -9304
	if (vars.last_banana == 0 && (current.pogo_x > -6091f))
	{
		vars.last_banana = 1;
		return settings["last_banana"];
	}

	// x: -3270 y: -8678
	if (vars.big_bone == 0 && (current.pogo_x > -3270f))
	{
		vars.big_bone = 1;
		return settings["big_bone"];
	}

	// x: -1456 y: -7615
	if (vars.poes_peak == 0 && (current.pogo_x > -1456f))
	{
		vars.poes_peak = 1;
		return settings["poes_peak"];
	}

	// x: 136 y: -6175
	if (vars.cave == 0 && (current.pogo_x > 136f))
	{
		vars.cave = 1;
		return settings["cave"];
	}

	// x: 1781 y: -4280
	if (vars.twin_trees == 0 && (current.pogo_x > 1781f))
	{
		vars.twin_trees = 1;
		return settings["twin_trees"];
	}

	// x: 5373 y: -4550
	if (vars.cliff_banana == 0 && (current.pogo_x > 5373f) && (current.pogo_y > -4550f))
	{
		vars.cliff_banana = 1;
		return settings["cliff_banana"];
	}

	// x: 3343 y: -3462
	if (vars.half_grapes == 0 && (current.pogo_x < 3343) && (current.pogo_y > -3462))
	{
		vars.half_grapes = 1;
		return settings["half_grapes"];
	}

	// x:5596 y:-2342
	if (vars.tree_branch == 0 && (current.pogo_x > 5596f) && (current.pogo_y > -2342f))
	{
		vars.tree_branch = 1;
		return settings["tree_branch"];
	}
}

start
{	
	current.GameTime = TimeSpan.Zero;

	vars.first_banana = 0;
	vars.last_banana = 0;
	vars.big_bone = 0;
	vars.poes_peak = 0;
	vars.cave = 0;
	vars.egg = 0;
	vars.twin_trees = 0;
	vars.cliff_banana = 0;
	vars.half_grapes = 0;
	vars.tree_branch = 0;

	return old.is_in_start_zone == 255 && current.is_in_start_zone == 0;
}