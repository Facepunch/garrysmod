//=========== (C) Copyright 1999 Valve, L.L.C. All rights reserved. ===========
//
// The copyright to the contents herein is the property of Valve, L.L.C.
// The contents may be used and/or copied only with the written permission of
// Valve, L.L.C., or in accordance with the terms and conditions stipulated in
// the agreement/contract under which the contents have been supplied.
//=============================================================================

// No spaces in event names, max length 32
// All strings are case sensitive
//
// valid data key types are:
//   string : a zero terminated string
//   bool   : unsigned int, 1 bit
//   byte   : unsigned int, 8 bit
//   short  : signed int, 16 bit
//   long   : signed int, 32 bit
//   float  : float, 32 bit
//   local  : any data, but not networked to clients
//
// following key names are reserved:
//   local      : if set to 1, event is not networked to clients
//   unreliable : networked, but unreliable
//   suppress   : never fire this event
//   time	: firing server time
//   eventid	: holds the event ID

"modevents"
{
	"player_death"				// a game event, name may be 32 charaters long
	{
		"userid"	"short"   	// user ID who died				
		"attacker"	"short"	 	// user ID who killed
		"weapon"	"string" 	// weapon name killed used 
	}
	
	"player_hurt_ex"
	{
		"userid"		"short"   	// ent index who was hurt				
		"attacker"		"short"	 	// ent index who attacked
		"health"		"byte"		// remaining health points
		"healthtaken"	"byte"		// remaining health points
	}
	
	"achievement_earned"
	{
		"player"		"byte"		// entindex of the player
		"achievement"	"short"		// achievement ID
	}
	
	"achievement_event" 
	{ 
		"achievement_name"	"string"	// non-localized name of achievement 
		"cur_val"	 "short"	 // # of steps toward achievement 
		"max_val"	 "short"	 // total # of steps in achievement 
	} 
	
	"show_freezepanel"
	{
		"killer"	"short"		// entindex of the killer entity
	}

	"hide_freezepanel"
	{
	}

	"freezecam_started"
	{
	}
	
}
