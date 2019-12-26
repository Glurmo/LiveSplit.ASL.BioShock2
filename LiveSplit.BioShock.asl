state("bioshock")
{
	int isLoading: 0x8D666C;
	int fontainDrainCount: 0x8BC810, 0x0, 0x20, 0x4C, 0x1108;
	string25 mapName: 0x8E1524, 0x138, 0x0; 
	// Todo: Find a better address for mapName
	// we want the "loading" map, rather than the active map 
	// then it can split at the start of level change rather than the end 
}

startup 
{
	settings.Add("splitcrash", false, "Split Crash Site");
	settings.Add("splitfarmers", false, "Split Farmer's Market");
	vars.splitMaps = new List<string>() 
	{
		"1-welcome",    // Welcome to Rapture
		"1-medical",    // Medical Pavilion
		"2-fisheries",  // Neptune's Bounty
		"2-SubBay",     // Smuggler's Hideout
		"3-Arcadia",    // Arcadia
		"4-recreation", // Fort Frolic
		"5-hephaestus", // Hephaestus
		"5-ryan",       // Rapture Central Control
		"6-Resi",       // Olympus Heights
		"6-slums",      // Apollo Square
		"7-science",    // Point Prometheus
		"7-gauntlet",   // Proving Grounds
		"7-BossFight",  // Fontaine
	};
}

start 
{
	vars.splitMaps.Remove("0-lighthouse");
	if (settings["splitcrash"]) vars.splitMaps.Add("0-lighthouse"); // Crash Site

	vars.splitMaps.Remove("3-market");
	if (settings["splitfarmers"]) vars.splitMaps.Add("3-market"); // Farmer's Market

	return current.mapName == "0-lighthouse";
}

split 
{
	bool isNewMap = current.mapName != old.mapName && 
		vars.splitMaps.Contains(current.mapName) && 
		vars.splitMaps.Contains(old.mapName);

	bool isFinalHit = current.mapName == "7-BossFight" &&
		old.fontainDrainCount == 3 &&
		current.fontainDrainCount == 4;

	return isNewMap || isFinalHit;
}

isLoading
{
	return current.isLoading != 0;
}
