state("Bioshock2")
{
	bool isSaving : 0xF42EE8;
	bool isLoading : 0x10B8010, 0x278;
}

isLoading
{
	return current.isSaving || current.isLoading;
}
