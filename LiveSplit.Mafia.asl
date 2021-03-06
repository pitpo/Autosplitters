﻿// English retail version.
state("game", "1.0en")
{
	bool isLoading1 : 0x2F94BC;		// the only static loading related address, goes to 1 in 1/3rd of loading
	bool isLoading2 : 0x2F9464, 0x10c; 	// triggers on "Please wait" and minor loads, goes back to 0 for a sec during loading
	bool m1Cutscene : 0x25608C;
	byte finalCutscene : 0x256444;
	string6 mission : 0x2F94A8, 0x0;
	string16 missionAlt : 0x2F94A8, 0x0;	// used for "submissions"
}

// Polish "Kolekcja Klasyki" version from 2006 (I leave it here for reference)
// If for some reason you want to run this version, change the name of main executable from start.exe to game.exe
state("game", "1.2plkk")
{
	bool isLoading1 : 0x247E74;
	bool isLoading2 : 0x247E1C, 0x10c;
	bool m1Cutscene : 0x23D730;
	byte finalCutscene : 0x2BDD7C;
	string6 mission : 0x247E60, 0x0;
	string15 missionAlt : 0x247E60, 0x0;
}

init
{
	if (modules.First().ModuleMemorySize == 3158016) {
		version = "1.0en";
	} 
	else if (modules.First().ModuleMemorySize == 2993526) {
		version = "1.2plkk";
	}
}

update
{
	if (version == "") { return; }		// If version is unknown, don't do anything (without it, it'd default to "1.0en" version)
}

// Start timer after skipping the first cutscene (you can comment this section out if you don't want this feature)
start
{
	return (!old.m1Cutscene && current.m1Cutscene && current.mission == "mise01");
}

// Reset timer on "An Offer You Can't Refuse" load (you can comment this section out if you don't want this feature)
reset
{
	return (current.mission == "mise01" && !old.isLoading1 && current.isLoading1);
}

// Split for every mission change (at the very beginning of every loading) [you can comment this section out if you don't want this feature]
split
{
	if (current.mission.Contains("mise") && old.mission != "00menu") {
		var currentSplit = timer.CurrentSplit.Name.ToLower();
	
		// Don't split on these mission changes
		if (current.mission == "mise06" || current.mission == "mise01") { return false; }
	
		// Split after Sarah
		else if (current.missionAlt == "mise07b-saliery" && currentSplit.Contains("sarah")) {
			return (old.missionAlt == "mise07-sara" && current.missionAlt == "mise07b-saliery");
		}
	
		// Split after The Whore
		else if (current.missionAlt == "mise08-kostel" && currentSplit.Contains("whore")) {
			return (old.missionAlt == "mise08-hotel" && current.missionAlt == "mise08-kostel");
		}
	
		// Final split
		else if (current.missionAlt == "mise20-galery") {
			return (old.finalCutscene == 0 && current.finalCutscene > 0);	// split on final cutscene trigger
		}
	
		// Split for everything else
		else {
			return (old.mission != current.mission);
		}
	} else { return false; }
}

// Load remover  (you can comment this section out if you don't want this feature)
// Using two addresses because I couldn't find anything that changes its value for the entire loading process
isLoading
{
	return ((current.isLoading1 || current.isLoading2) && current.mission != "00menu");
}