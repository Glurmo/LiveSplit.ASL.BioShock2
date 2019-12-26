state("toy2")
{
	byte levelID: 0xFCDC0;
	byte15 levelFlags: 0x12F0D8;

	short posX: 0x12F301;
	short posY: 0x12F305;
	short posZ: 0x12F309;

	byte cowboyHealth: 0x12C95A;
	byte blacksmithHealth: 0x12C8BE;
	byte peteHealth: 0x12C9F6;
}

start
{
	vars.inFinalBoss = false;
	return (
		current.levelID == 1 &&
		(old.posX == 760 && old.posY == 234 && old.posZ == -1412) &&
		(current.posX != 760 || current.posY != 234 || current.posZ != -1412)
	);
}

split
{
	var combinedBossHealth = current.cowboyHealth + current.blacksmithHealth + current.peteHealth;

	if (current.levelID == 15 && combinedBossHealth == 0)
	{
		vars.inFinalBoss = true;
	}
	else if (vars.inFinalBoss && current.cowboyHealth <= 9 && current.blacksmithHealth <= 9 && current.peteHealth <= 9)
	{
		vars.inFinalBoss = false;
		return true;
	}

	// Token pick-up or boss defeated
	return !Enumerable.SequenceEqual(old.levelFlags, current.levelFlags);
}

reset
{
	return old.levelID == 0 && current.levelID == 1;
}
