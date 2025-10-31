(* 

11/8/2023
Tested with EOS 3.2.5 and QLab v5.3 on macOS Ventura 13.6.1

Please refer to my repository for any updates or to report problems you may find
https://github.com/acousticnonchalant/ScriptsForQLab

ETC EOS Single Cue Generator for QLab
This script will generate a single light cue when called. Change the variables listed below and then the script will prompt you for the cue number.

This code is still a little messy. Please reach out to me if you notice any problems.

ETC SHOW CONTROL USER GUIDE:
https://www.etcconnect.com/workarea/DownloadAsset.aspx?id=10737461372

File Name: QLab 5 - ETC EOS - Single Cue Generator

Written by Chase Elison 
chase@chaseelison.com

*)

set qlabFirstColor to "" -- Leave as "" if you want no color
set qlabUseSecondColor to false
set qlabSecondColor to "" -- Leave as "" if you want no color

set eosSpecifyUser to false -- For network only, specify whether or not you want to specify an EOS user number.
set eosUser to 5 -- The user number. Doesn't matter if you're not specifying a user.

set eosCueList to 0 -- Cue list in EOS. Use 0 to not specify a list.

set qlabCueType to "Network" -- One of: {"Network", "MIDI"}
set qlabCuePatch to 1 -- The patch number, for either Network or MIDI.
set qlabMidiDeviceID to 1 -- This doesn't matter if you are making a network cue
set cueNamePrefix to "Q" -- What the cue name says before the number.


tell application id "com.figure53.QLab.5" to tell front workspace
	--
	-- BEGIN QLab VERSION CHECK SNIPPET
	-- Chase Elison 9/17/2023
	--
	set versionOfQLab to get version of application "QLab"
	set text item delimiters of AppleScript to "."
	set versionNumber to text items of versionOfQLab
	set isVersion5 to (item 1 of versionNumber is "5") as boolean
	set isNewVersionWithUser to false as boolean
	-- By default, it will not add user data
	if (item 2 of versionNumber is "0") and (item 3 of versionNumber as integer is 9) then
		-- Is build .0.9 or higher, therefore will add user info in cues.
		set isNewVersionWithUser to true
	else if item 2 of versionNumber as integer is greater than or equal to 1 then
		-- Is greater than build .1.x, it will be presumed that newer versions will follow the same format
		-- At time of writing this, 9/17/2023, QLab 5.2.3 is newest version.
		set isNewVersionWithUser to true
	end if
	--
	-- END QLab VERSION CHECK SNIPPET
	-- Variable isNewVersionWithuser will indicate whether the cues should be generated with user data or not.
	--
	set dialogText to "Making a " & qlabCueType & " Cue
"
	if qlabCueType is "network" and eosSpecifyUser then
		set dialogText to dialogText & ("Specifying user " & eosUser) & "
"
	else if qlabCueType is "network" and eosSpecifyUser is false then
		set dialogText to dialogText & "Not specifying user
"
	end if
	set dialogText to (dialogText & "Cue list " & eosCueList as text) & "
"
	set dialogText to dialogText & "Prefix: " & cueNamePrefix & "
"
	display dialog dialogText & "EOS Cue Number?" with icon 1 default answer "1"
	set eosCueNumber to text returned of result as text
	
	if eosCueList is 0 then
		set eosSpecifyCueList to false
		set eosCueListPrefix to ""
	else if eosCueList is 1 then
		set eosSpecifyCueList to true
		set eosCueListPrefix to ""
	else
		set eosSpecifyCueList to true
		set eosCueListPrefix to (eosCueList as integer as text) & "/"
	end if
	
	set qlabCueName to cueNamePrefix & eosCueListPrefix & eosCueNumber
	
	set qlabCueProblems to 0
	
	
	
	if qlabCueType is "Network" then
		make type "network"
		set qlabNewCue to last item of (selected as list)
		(* QLab 5: *)
		--
		-- BEGIN EOS Cue Generator Snippet
		-- Chase Elison 11/28/2022
		--
		
		-- First item will always be "cue"
		set networkCueValues to {"cue"}
		if isNewVersionWithUser then
			-- Check with the version snippet to see if user info is required
			if eosSpecifyUser then
				-- if specifying the user, the 2nd item will be "yes" and the 3rd item will be the user number
				set networkCueValues to networkCueValues & "yes" & eosUser
			else
				-- if not, the 2nd item will be "no"
				set networkCueValues to networkCueValues & "no"
			end if
		end if
		if eosSpecifyCueList then
			-- if specifying the list, the next 2 values will be "fireInList" and the list number.
			set networkCueValues to networkCueValues & "fireInList" & eosCueList
		else
			--if not, the next 1 value will be "fire"
			set networkCueValues to networkCueValues & "fire"
		end if
		-- Lastly, the cue number.
		set networkCueValues to networkCueValues & eosCueNumber
		set network patch number of qlabNewCue to qlabCuePatch
		set parameter values of qlabNewCue to networkCueValues
		if (count of parameter values of qlabNewCue) is not (count of networkCueValues) then
			set q name of qlabNewCue to "PROBLEM - " & q display name of qlabNewCue
			set q color of qlabNewCue to "red"
			set flagged of qlabNewCue to true
			set qlabCueProblems to qlabCueProblems + 1
		end if
		--
		-- END EOS Cue Generator Snippet
		--
	else if qlabCueType is "MIDI" then
		make type "midi"
		set qlabNewCue to last item of (selected as list)
		set message type of qlabNewCue to msc
		set midi patch number of qlabNewCue to qlabCuePatch
		set command format of qlabNewCue to 1 -- Lighting (General)
		set command number of qlabNewCue to 1 -- GO
		set deviceID of qlabNewCue to qlabMidiDeviceID
		if eosSpecifyCueList then
			set q_list of qlabNewCue to eosCueList
		else
			set q_list of qlabNewCue to ""
		end if
		set q_number of qlabNewCue to eosCueNumber
	end if
	set pre wait of qlabNewCue to 0
	set duration of qlabNewCue to 0
	set post wait of qlabNewCue to 0
	set continue mode of qlabNewCue to do_not_continue
	if qlabCueProblems is 0 then
		set q name of qlabNewCue to qlabCueName
	end if
	--set patch of qlabNewCue to qlabCuePatch
	if q type of qlabNewCue is "network" then
		--if (countOfItems is not 4 and eosCueList is not "0") or (countOfItems is not 3 and eosCueList is "0") then
		if qlabCueProblems > 0 then
			set patchName to network patch name of qlabNewCue
			display dialog "It appears your patch is not set correctly. Please first check that the patch you have chosen, network patch \"" & patchName & "\" is correct. If it is, please go to your settings (Gear icon in the bottom right of QLab) and under network, change the type of \"" & patchName & "\" to \"ETC Eos Family\"." with title "EOS CSV Cue Generator" with icon 1 buttons "OK" default button "OK"
			return
		end if
	end if
	try
		if qlabFirstColor is not "" then
			set q color of qlabNewCue to qlabFirstColor
			if qlabUseSecondColor then
				set use q color 2 of qlabNewCue to true
				set q color 2 of qlabNewCue to qlabSecondColor
			end if
		end if
	end try
	set q number of qlabNewCue to ""
end tell

(*

Changes-

11/8/2023 - Added variables to set a color for new cues at the top of the script.

*)
