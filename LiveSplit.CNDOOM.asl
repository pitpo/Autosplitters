// TODO:
// -version detection
// -add category support (all episodes runs)
// -add final map split
// -split on intermission
// -map 9 support
// -Doom 2 support
// -IWAD detection
state("cndoom", "2.0.3.2")
{
	int episode	: 0x117A34;
	int level : 0x1173C4;
	int loading : 0x10EF28;
}

start
{
	return current.level == 1 && current.loading == 0 && current.loading != old.loading;
}

split
{
	return current.level == old.level + 1;
}

reset
{
	return current.level == 1 && current.loading == 3 && old.loading == 0;
}