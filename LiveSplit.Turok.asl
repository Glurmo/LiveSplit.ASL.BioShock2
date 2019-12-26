state("sobek", "1.1")
{
    string40 level: 0x27D764, 0x0, 0x0;
    string40 map: 0x27D740, 0x0;
    int health: 0x27DA3C, 0xE0;
    int level8BossHealth:  0x27DBD4, 0xE0;
}

start 
{
    vars.splits.Clear();
    vars.visited.Clear();
    vars.trackSplit("the hub", "the ancient city", 1);
    vars.trackSplit("the hub", "the jungle", 1);
    vars.trackSplit("the hub", "the ruins", 1);
    vars.trackSplit("the hub", "the catacombs", 1);
    vars.trackSplit("the hub", "the treetop village", 1);
    vars.trackSplit("the hub", "the lost land", 1);
    vars.trackSplit("the hub", "the final confrontation", 1);
    if (settings["split-longhunter"]) vars.trackSplit("levels/level09.map", "levels/level48.map", 1);
    if (settings["split-mantis"]) vars.trackSplit("levels/level12.map", "levels/level49.map", 1);
    if (settings["split-thunder"]) vars.trackSplit("levels/level24.map", "levels/level03.map", 1);
    if (settings["split-campaigner"]) vars.trackSplit("levels/level25.map", "levels/level00.map", 1);

    return old.level == "title" && current.level == "the hub";
}

reset 
{
    return old.level != "title" && current.level == "title";
}

split 
{
    bool isLevelSplit = vars.shouldSplit(old.level, current.level);
    bool isMapSplit = vars.shouldSplit(old.map, current.map);
    bool isFinalSplit = current.health > 0 && // don't split if we died
                        (old.level8BossHealth > 0 && current.level8BossHealth == 0) &&
                        current.map == "levels/level00.map";
    return isLevelSplit || isMapSplit || isFinalSplit;
}

init
{
    int memSize = modules.First().ModuleMemorySize;
    if (memSize == 3047424) {
        version = "1.1"; // executable from TDH 1.1.7z
    }
}

startup 
{
    vars.splits = new Dictionary<string, Dictionary<string, List<int>>>();
    vars.visited = new Dictionary<string, Dictionary<string, int>>();

    settings.Add("split-boss", true, "Split Boss Entrances");
    settings.Add("split-longhunter", true, "Longhunter", "split-boss");
    settings.Add("split-mantis", true, "Mantis", "split-boss");
    settings.Add("split-thunder", true, "Thunder", "split-boss");
    settings.Add("split-campaigner", true, "Campaigner", "split-boss");

    vars.trackSplit = (Action<string, string, int>)((from, to, visit) =>
    {
        if (!vars.splits.ContainsKey(from)) vars.splits[from] = new Dictionary<string, List<int>>();
        if (!vars.splits[from].ContainsKey(to)) vars.splits[from][to] = new List<int>();
        vars.splits[from][to].Add(visit);
    });

    vars.shouldSplit = (Func<string, string, bool>)((from, to) =>
    {
        if (from == to) return false;

        // Track visit count to maps to prevent splitting on re-entry
        if (!vars.visited.ContainsKey(from)) vars.visited[from] = new Dictionary<string, int>();
        int visitCount = 0;
        vars.visited[from].TryGetValue(to, out visitCount);
        vars.visited[from][to] = ++visitCount;

        return vars.splits.ContainsKey(from) &&
               vars.splits[from].ContainsKey(to) &&
               vars.splits[from][to].Contains(visitCount);
    });

    vars.debug = (Action<string>)((msg) => print("[Turok ASL] " + msg));
}