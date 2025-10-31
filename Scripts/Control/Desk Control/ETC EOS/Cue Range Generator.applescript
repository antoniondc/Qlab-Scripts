(* 

1/19/2025
Tested with EOS 3.2.10 and QLab v5.4.8 on macOS Sequoia 15.2

Please refer to my repository for any updates or to report problems you may find
https://github.com/acousticnonchalant/ScriptsForQLab

ETC EOS Cue Range Generator for QLab
This script will generate a single light cue when called. Change the variables listed below and then the script will prompt you for the cue number.

ETC SHOW CONTROL USER GUIDE:
https://www.etcconnect.com/workarea/DownloadAsset.aspx?id=10737461372

File Name: QLab 5 - ETC EOS - Cue Range Generator

Written by Chase Elison 
chase@chaseelison.com

*)

set qlabFirstColor to "Forest" -- Leave as "" if you want no color
set qlabUseSecondColor to false
set qlabSecondColor to "" -- Leave as "" if you want no color

set eosPromptForUser to true -- Set this to true if you don't want to set the user in the two variables below.
set eosSpecifyUser to false -- For network only, specify whether or not you want to specify an EOS user number.
set eosUser to 5 -- The user number. Doesn't matter if you're not specifying a user.

set eosCueList to -1 -- Cue list in EOS. Use 0 to not specify a list. Use -1 to prompt.

set qlabCueType to "" -- One of: {"Network", "MIDI"}. Use "" to prompt.
set qlabCuePatch to 0 -- The patch number, for either Network or MIDI. Use 0 to prompt.
set qlabMidiDeviceID to -1 -- This doesn't matter if you are making a network cue. Use -1 to prompt.
set cueNamePrefix to "" -- What the cue name says before the number. Use "" to prompt.

set useSpacerBlocks to true -- Set this to true if you would like spacers between a number of cues
set spacerDistance to 50 -- Change this to how often you would like a spacer block
-- (This is helpful if you are scrolling through a long list of cue numbers)


tell application id "com.figure53.QLab.5" to tell front workspace
	if edit mode is false then return
	--
	-- BEGIN QLab VERSION CHECK SNIPPET
	-- Chase Elison 9/18/2023
	--
	set versionOfQLab to get version of application "QLab"
	set text item delimiters of AppleScript to "."
	set versionNumber to text items of versionOfQLab
	set isVersion5 to (item 1 of versionNumber is "5") as boolean
	set isNewVersionWithUser to false as boolean
	-- By default, it will not add user data
	if (item 2 of versionNumber is "0") and (item 3 of versionNumber as integer is greater than or equal to 9) then
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
	
	if qlabCueType is "" then
		display dialog "Do you need to generate OSC (network) cues or  MIDI cues?" with title "EOS CSV Cue Generator" with icon 1 buttons {"Network", "MIDI"} default button "Network"
		if button returned of result = "Network" then
			set qlabCueType to "Network"
		else if button returned of result = "MIDI" then
			set qlabCueType to "MIDI"
		else
			return
		end if
	end if
	
	if qlabCuePatch is 0 then
		display dialog qlabCueType & " Destination (Patch)? Leave as 1 if you have only one destination, which is the console." with icon 1 default answer "1"
		try
			set qlabCuePatch to (text returned of result) as integer
			if (qlabCuePatch is 0) or (qlabCuePatch > 16) then
				display dialog "ERROR - must be a number between 1 and 16" with icon 1 buttons {"OK"} default button 1
				return
			end if
		on error the errorMessage
			display dialog "ERROR - " & errorMessage with icon 1 buttons {"OK"} default button 1
			return
		end try
	end if
	--
	--BEGIN ETC EOS Library Definition Validation Station
	--Chase Elison 9/17/2023
	--
	if qlabCueType is "Network" then
		make type "network"
		set networkTestingCue to last item of (selected as list)
		set network patch number of networkTestingCue to qlabCuePatch
		if isNewVersionWithUser then
			set networkTestingCueParameterValues to {"cue", "yes", 2, "fireInList", 3, 4}
		else
			set networkTestingCueParameterValues to {"cue", "fireInList", 3, 4}
		end if
		set parameter values of networkTestingCue to networkTestingCueParameterValues
		set networkCueTestResult to count of parameter values of networkTestingCue
		set patchName to network patch name of networkTestingCue
		tell parent of networkTestingCue
			delete cue id (uniqueID of networkTestingCue)
		end tell
		if networkCueTestResult is not (count of networkTestingCueParameterValues) then
			display dialog "It appears your patch is not set correctly. Please first check that the patch you have chosen, network patch \"" & patchName & "\" is correct. If it is, please go to your settings (Gear icon in the bottom right of QLab) and under network, change the type of \"" & patchName & "\" to \"ETC Eos Family\"." with title "EOS CSV Cue Generator" with icon 1 buttons "OK" default button "OK"
			return
		end if
	end if
	--
	--END ETC EOS Library Definition Validation Station
	--It'll end the script and throw an error message if the patch is wrong
	--
	
	if qlabCueType is "MIDI" and (qlabMidiDeviceID < 0 or qlabMidiDeviceID > 127) then
		display dialog "EOS - MIDI RX Device ID?" with icon 1 default answer "0"
		try
			set qlabMidiDeviceID to (text returned of result) as integer
			if (qlabMidiDeviceID < 0) or (qlabMidiDeviceID > 127) then
				display dialog "ERROR - must be a number between 0 and 127" with icon 1 buttons {"OK"} default button 1
				return
			end if
		on error the errorMessage
			display dialog "ERROR - " & errorMessage with icon 1 buttons {"OK"} default button 1
			return
		end try
	end if
	
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
	
	if eosCueList is less than 0 then
		display dialog "Specific cue list?" with title "QLab 5 EOS Cue Range Generator" with icon 1 buttons {"Yes", "No"} default button "Yes"
		if button returned of result = "yes" then
			display dialog "Which list?" default answer "1" with title "QLab 5 EOS Cue Range Generator" with icon 1 buttons {"OK", "Cancel"} default button "OK"
			set cueListResult to result
			if button returned of cueListResult = "cancel" then
				return
			else
				set eosSpecifyCueList to true
				set eosCueList to (text returned of cueListResult)
			end if
		else
			set eosSpecifyCueList to false
			set eosCueList to "0"
		end if
	end if
	
	
	if cueNamePrefix is "" then
		display dialog "Prefix? For example, Q, LQ, Light Cue..." default answer "Q" with title "QLab 5 EOS Cue Range Generator" with icon 1 buttons {"OK", "Cancel"} default button "OK"
		if button returned of result = "cancel" then
			return
		else
			set cueNamePrefix to (text returned of result) as string
		end if
	end if
	
	if isNewVersionWithUser and eosPromptForUser and qlabCueType is "Network" then
		display dialog "Do you wish to specify an EOS user number?" with title "QLab 5 EOS Cue Range Generator" with icon 1 buttons {"Yes", "No", "Cancel"} default button "No"
		if button returned of result = "cancel" then
			return
		else
			if button returned of result = "yes" then
				display dialog "Which user number?" default answer "1" with title "QLab 5 EOS Cue Range Generator" with icon 1 buttons {"OK", "Cancel"} default button "OK"
				set eosUserNumberResult to result
				set eosSpecifyUser to true
				set eosUser to text returned of eosUserNumberResult as string
			else
				set eosSpecifyUser to false
				set eosUser to "1"
			end if
		end if
	end if
	
	if eosCueList is 0 or eosCueList is "0" then
		set eosSpecifyCueList to false
		set eosCueListPrefix to ""
	else if eosCueList is 1 or eosCueList is "1" then
		set eosSpecifyCueList to true
		set eosCueListPrefix to ""
	else
		set eosSpecifyCueList to true
		set eosCueListPrefix to (eosCueList as integer as text) & "/"
	end if
	
	set qlabCueProblems to 0
	
	set currentCueNumber to firstCueNumber
	repeat while (currentCueNumber is less than or equal to lastCueNumber) and (currentCueNumber is greater than or equal to firstCueNumber) --in case a silly goose tries a negative increment
		
		if currentCueNumber as integer is currentCueNumber then
			set eosCueNumber to currentCueNumber as integer as text
		else
			set eosCueNumber to currentCueNumber as text
		end if
		set qlabCueName to cueNamePrefix & eosCueListPrefix & eosCueNumber
		
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
		
		if useSpacerBlocks then
			if currentCueNumber mod spacerDistance is 0 then
				repeat with newMemoCue from 1 to 3
					make type "Memo"
					set thisMemoCue to last item of (selected as list)
					if qlabFirstColor is in {"yellow", "Yellow"} then
						set q color of thisMemoCue to "Red"
					else
						set q color of thisMemoCue to "Yellow"
					end if
					set q number of thisMemoCue to ""
					set continue mode of thisMemoCue to do_not_continue
				end repeat
			end if
		end if
		
		set currentCueNumber to currentCueNumber + increment
	end repeat
end tell

(*

Changes-

11/8/2023 - Added variable to set a color for new cues at the top of the script.
1/19/2025 - Added spacer blocks to help navigate hundreds of cues faster and easier.

*)
