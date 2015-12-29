// Automatically splits at the end of every level (episode if All Episodes run is detected)
// Automatically resets at the start of map 1 (e1m1 if All Episodes run is detected)
// LiveSplit's Game Time gives you relevant In-Game Time (ONLY on SINGLE SEGMENT runs) [single episode and doom 2 runs]
// For every 10 minutes of gameplay add 1.4 seconds to IGT. CnDoom starts the timer 0.14 seconds earlier.
// Should work with every PWAD and IWAD
// Huge THANK YOU to Chocolate Doom programmers for "keeping it simple" (especially for using the same "current level" variable for both D1 and D2 IWADs)
state("cndoom", "2.0.3.2")
{
	int episode : 0x117A34;
	int level : 0x1173C4;
	int loading : 0x10F328;
	int intermission : 0x56938;
}

init
{
	if (modules.First().ModuleMemorySize == 7077888) {
		version = "2.0.3.2";
	}
	
	// Set this to false if you want to split on every level of every episode in All Episodes run
	vars.splitOnEpisode = true;
	vars.category = timer.Run.CategoryName.ToLower();
}

update
{
	if (version == "") {
		return;
	}
}

start
{
	vars.previousMap = 0;	// Setting this to make m1 split possible
	return current.level == 1 && current.loading == 2 && old.loading == 3;
}

split
{
	var currentSplit = timer.CurrentSplit.Name.ToLower();
	
	if (currentSplit.Contains("ep") || (vars.category.Contains("episodes") && vars.splitOnEpisode == true)) {
		if (current.level == 8 && current.intermission == 1 && old.intermission == 0) {
			return true;
		}
	} else if (current.intermission == 1 && old.intermission == 0 && current.level != vars.previousMap) {
		vars.previousMap = current.level;	// Used to skip split if player returns to previous level (for some really important reason...)
		return true;
	}
	
}

reset
{
	// old.loading equals 0 when player is loading level from in-game state
	// old.loading equals 1 when player is loading level from command line boot (and when it's changing states from 3 to 2 to 1 to 0)
	if (vars.category.Contains("episodes")) {
		return current.level == 1 && current.episode == 1 && current.loading == 3 && (old.loading == 0 || old.loading == 1);
	} else {
		return current.level == 1 && current.loading == 3 && (old.loading == 0 || old.loading == 1);
	}
}

isLoading
{
	if (!vars.category.Contains("episode")) {
		// Doom 2 IWAD
		return current.loading == 3 || current.intermission != 0;
	}
	else if (!vars.category.Contains("episodes")) {
		// Doom 1 IWAD single episode
		return current.loading == 3 || current.intermission != 0 || current.level == 8;
	}
}