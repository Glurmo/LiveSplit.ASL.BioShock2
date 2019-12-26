// This is for segmented practice/testing, for full runs use the IGT timer included with LiveSplit.

state("DARKSOULS")
{
	int igt: 0xF78700, 0x68;
}

start
{
	vars.initialGameTime = 0;
	vars.relativeGameTime = 0;
}

isLoading
{
	return true;
}

gameTime
{
	const int RECALIBRATION_MS = 594; // IGT rolls back 594ms after quit outs
	if (vars.initialGameTime == 0)
	{
		vars.initialGameTime = current.igt;
	}
	if (current.igt > 0)
	{
		vars.relativeGameTime = current.igt - vars.initialGameTime;
	}
	else if (current.igt == 0 && old.igt > 0)
	{
		// quit out recalibrate
		vars.relativeGameTime -= RECALIBRATION_MS;
	}
	return TimeSpan.FromMilliseconds(vars.relativeGameTime);
}
