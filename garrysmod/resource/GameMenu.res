"GameMenu"
{
	"1"
	{
		"label" "#GameUI_GameMenu_ResumeGame"
		"command" "ResumeGame"
		"OnlyInGame" "1"
	}
	
	"2"
	{
		"label" "#GameUI_GameMenu_PlayerList"
		"command" "OpenPlayerListDialog"
		"OnlyInGame" "1"
	}

	"4"
	{
		"label" ""
		"command" ""
		"OnlyInGame" "1"
	}
	
	"5"
	{
		"label" "Start New Game"
		"command" "engine menu_startgame"
		"notmulti" "1" 
	}
	"6"
	{
		"label" "#GameUI_GameMenu_LoadGame"
		"command" "OpenLoadGameDialog"
		"notmulti" "1"
	}
	"7"
	{
		"label" "#GameUI_GameMenu_SaveGame"
		"command" "OpenSaveGameDialog"
		"notmulti" "1"
		"OnlyInGame" "1"
	}
	"9"
	{
		"label" ""
		"command" ""
	}
	"5"
	{
		"label" "#GameUI_GameMenu_FindServers"
		"command" "OpenServerBrowser"
	}
	
	"15"
	{
		"label" " "
		"command" "spacer"
	}
	
	"10"
	{
		"label" "#GameUI_GameMenu_Options"
		"command" "OpenOptionsDialog"
	}
	
	"9"
	{
		"label" " "
		"command" "spacer"
	}
	


	"11"
	{
		"label" "#GameUI_GarrysMod_Achievements"
		"command" "engine menu_achievements"
	}
	
	"10"
	{
		"label" "#GameUI_GarrysMod_Extensions"
		"command" "engine menu_extensions"
	}
	
	"18"
	{
		"label" " "
		"command" "spacer"
	}
	
	"20"
	{
		"label" 	"#GModSchool"
		"command" 	"engine SchoolMe"
	}
	
	"100"
	{
		"label" " "
		"command" "spacer"
	}
	
	"120"
	{
		"label" "#GameUI_GameMenu_Friends"
		"command" "OpenFriendsDialog"
	}
	
	"150"
	{
		"label" " "
		"command" "spacer"
	}
	
	"170"
	{
		"label" "#GameUI_GameMenu_Disconnect"
		"command" "engine disconnect"
		"OnlyInGame" "1"
	}
		
	"200"
	{
		"label" "#GameUI_GameMenu_Quit"
		"command" "Quit"
	}
}

