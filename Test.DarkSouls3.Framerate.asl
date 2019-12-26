// Test to see if FPS has an effect on movement speed / stamina regen

state("DarkSoulsIII")
{
    int igt: 0x469BDF8, 0x9c;
    float X: 0x46C4AA8, 0x5a8, 0x18, 0x18, 0x28, 0x80;
    float Y: 0x46C4AA8, 0x5a8, 0x18, 0x18, 0x28, 0x88;
    float Z: 0x46C4AA8, 0x5a8, 0x18, 0x18, 0x28, 0x84;
    int healthRemaining: 0x46C4AA8, 0x80, 0x1f70, 0x18, 0xd8;
    int staminaRemaining: 0x46C4AA8, 0x80, 0x1f70, 0x18, 0xf0;
}

init 
{
    vars.initialGameTime = 0;
    vars.startedMovement = false;
}

start 
{
    vars.initialGameTime = 0;
    vars.startedMovement = false;
  
    return current.igt > old.igt && old.igt != 0;
}

isLoading
{
    return true;
}

split
{
    if (vars.startedMovement) 
    {
        return ( 
            (current.staminaRemaining <= 6 && old.staminaRemaining > 6) || 
            (current.healthRemaining == 0)
        );
    }
    else 
    {
        if (current.Y < 126.00 && current.Y > 0.00) 
        {
            vars.startedMovement = true;
            return true;
        }
    }
}

gameTime
{
    if (vars.initialGameTime == 0)
    {
        vars.initialGameTime = current.igt;
    }
  
    if (current.igt > 0)
    {
        return TimeSpan.FromMilliseconds(current.igt - vars.initialGameTime);
    }
}
