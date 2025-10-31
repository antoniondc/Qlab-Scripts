(* 

12/22/2023
Tested with QLab v5.3.3 on macOS Sonoma 14.2

Yamaha Program Change Generator
This script will generate a single program change cue (scene recall) for Yamaha consoles when called.
Change the variables listed below and then the script will prompt you for the cue number.

File Name: Yamaha QL - Program Change (Scene) Cue Range Generator

Written by Chase Elison
chase@chaseelison.com

*)

set qlabFirstColor to "Magenta" -- Leave as "" if you want no color
set qlabUseSecondColor to false
set qlabSecondColor to "" -- Leave as "" if you want no color

set qlabCuePatch to 1 -- The patch number, for either Network or MIDI.
set qlabMidiDeviceID to 1
set cueNamePrefix to "YAMAHA QL5 - RECALL SCENE " -- What the cue name says before the number.
set cueNameSuffix to "" -- Anything you want to write after the number.
set dialogText to "Making a Yamaha MIDI Scene (Program Change)
"
set unitName to "Scene"
set addToValue to -1 --Yamaha's program changes start at 0 for scene 1.

use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

tell application id "com.figure53.QLab.5" to tell front workspace
	
	
	display dialog dialogText & "First " & unitName & " Number?" default answer "1" with title "QLab 5 EOS Cue Range Generator" with icon 1 buttons {"OK", "Cancel"} default button "OK"
	if button returned of result = "cancel" then
		return
	else
		set firstCueNumber to (text returned of result) as integer
	end if
	
	display dialog dialogText & "Last " & unitName & " Number?" default answer "1" with title "QLab 5 EOS Cue Range Generator" with icon 1 buttons {"OK", "Cancel"} default button "OK"
	if button returned of result = "cancel" then
		return
	else
		set lastCueNumber to (text returned of result) as integer
	end if
	
	set increment to 1
	
	set currentCueNumber to firstCueNumber
	repeat while (currentCueNumber is less than or equal to lastCueNumber) and (currentCueNumber is greater than or equal to firstCueNumber)
		
		set programChangeNumber to currentCueNumber
		
		set qlabCueName to cueNamePrefix & programChangeNumber & cueNameSuffix
		
		make type "MIDI"
		set qlabNewCue to last item of (selected as list)
		
		set midi patch number of qlabNewCue to qlabCuePatch
		
		set message type of qlabNewCue to voice
		set command of qlabNewCue to program_change
		set channel of qlabNewCue to qlabMidiDeviceID
		set byte one of qlabNewCue to ((programChangeNumber as integer) + addToValue)
		
		set q number of qlabNewCue to ""
		set q name of qlabNewCue to qlabCueName
		
		
		try
			if qlabFirstColor is not "" then
				set q color of qlabNewCue to qlabFirstColor
				if qlabUseSecondColor then
					set use q color 2 of qlabNewCue to true
					set q color 2 of qlabNewCue to qlabSecondColor
				end if
			end if
		end try
		
		set currentCueNumber to currentCueNumber + increment
	end repeat
end tell

(*

Changes-

12/19/2023 - Left out logic to choose MIDI patch. Made it a little more universal if you want to change it.
12/22/2023 - Accidentally left some testing code in that would make the script difficult to use. Also added some more universal code.

*)
