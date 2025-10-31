(* 

Version 5.2
7/6/2023

Please refer to my repository for any updates or to report problems you may find
https://github.com/acousticnonchalant/ScriptsForQLab

QLab 5 NEO Cue Range Generator

This script will generate a range of cues for Phillips NEO. This was done
quick and dirty and is not the cleanest code in the world.

Written by Chase Elison 
chase@chaseelison.com

Tested with QLab v5.2 on macOS Monterey 12.6.5

*)

tell application id "com.figure53.QLab.5" to tell front workspace
	
	display dialog "First Cue Number?" default answer "1" with title "QLab 5 EOS Cue Range Generator" with icon 1 buttons {"OK", "Cancel"} default button "OK"
	if button returned of result = "cancel" then
		return
	else
		set firstCueNumber to (text returned of result) as integer
	end if
	
	display dialog "Last Cue Number?" default answer "1" with title "QLab 5 EOS Cue Range Generator" with icon 1 buttons {"OK", "Cancel"} default button "OK"
	if button returned of result = "cancel" then
		return
	else
		set lastCueNumber to (text returned of result) as integer
	end if
	
	display dialog "Increment?" default answer "1" with title "QLab 5 EOS Cue Range Generator" with icon 1 buttons {"OK", "Cancel"} default button "OK"
	set incrementResult to result
	if button returned of incrementResult = "cancel" then
		return
	else
		if text returned of incrementResult is "0" then
			display dialog "You certified silly goose, it can't be 0" with title "Silly goose" with icon 1 buttons {"I accept my fate as a silly goose"} default button "I accept my fate as a silly goose"
			return
		else
			set increment to (text returned of incrementResult)
		end if
	end if
	
	display dialog "Prefix? For example, Q, LQ, Light Cue..." default answer "Q" with title "QLab 5 EOS Cue Range Generator" with icon 1 buttons {"OK", "Cancel"} default button "OK"
	if button returned of result = "cancel" then
		return
	else
		set cueNamePrefix to (text returned of result) as string
	end if
	
	set currentCueNumber to firstCueNumber
	repeat while (currentCueNumber ≤ lastCueNumber) and (currentCueNumber ≥ firstCueNumber) --in case a silly goose tries a negative increment
		make type "network"
		set qlabNewCue to last item of (selected as list)
		--Following if block was added because it kept giving values like "10.0" instead of "10" and it appears to work for now. 
		if (currentCueNumber as integer) is currentCueNumber then
			set cueDisplayNumber to currentCueNumber as integer as text
		else
			set cueDisplayNumber to currentCueNumber as text
		end if
		set q name of qlabNewCue to cueNamePrefix & cueDisplayNumber
		set q number of qlabNewCue to ""
		
		set custom message of qlabNewCue to "/NEO/CUE" & cueDisplayNumber & "/GO/"
		
		set currentCueNumber to currentCueNumber + increment
	end repeat
end tell
