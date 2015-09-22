state("Bioshock2")
{
	bool isSaving : "Bioshock2.exe", 0xF42EE8;
	bool isLoading : "Bioshock2.exe", 0x10B8010, 0x278;
}

isLoading
{
	return current.isSaving || current.isLoading;
}
