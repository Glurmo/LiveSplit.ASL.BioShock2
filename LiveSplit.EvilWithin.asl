state("EvilWithin")
{
    int chapter: 0x2133158;
    int igt: 0x0212E270, 0x68, 0x28, 0x8CBC;
    // float gameSpeed: 0x09AB3AF0, 0x68, 0x38, 0x3B8, 0xAA8, 0x38;
    // float gameSpeed: 0x0212E270, 0x68, 0x38, 0x3B8, 0xAA8, 0x38;
}

isLoading
{
    // always use game time
    return true;
}

split
{
    return current.chapter > old.chapter && old.chapter > 0;
}

gameTime
{
    return TimeSpan.FromSeconds(Math.Max(current.igt, 0));
}
