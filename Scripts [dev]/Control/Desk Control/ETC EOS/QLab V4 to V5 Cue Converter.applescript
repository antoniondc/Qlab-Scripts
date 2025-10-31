(* 

9/18/2023
Tested with EOS 3.2.3 and QLab v5.2.3 on macOS Ventura 13.5.2

Please refer to my repository for any updates or to report problems you may find
https://github.com/acousticnonchalant/ScriptsForQLab

ETC EOS Cue QLab 4 to 5 converter
This script will take old EOS network cue commands from V4 and convert them to V5 cues, making use of the new libraries in QLab 5.

This code is still a little messy. Please reach out to me if you notice any problems.

ETC SHOW CONTROL USER GUIDE:
https://www.etcconnect.com/workarea/DownloadAsset.aspx?id=10737461372

File Name: QLab 5 - ETC EOS - Single Cue Generator

Written by Chase Elison 
chase@chaseelison.com

*)

set qlabCuePatch to 1
set eosSpecifyUser to false
set eosUser to 5

tell application id "com.figure53.QLab.5" to tell front workspace
	set qlabCueProblems to 0
	set selectedCues to selected as list
	
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
	
	repeat with eachCue in selectedCues
		if q type of eachCue is "network" then
			set text item delimiters of AppleScript to "/"
			set cueCommands to text items of (custom message of eachCue as text)
			set cueAppearsValid to true
			if (count of cueCommands) is 5 or (count of cueCommands) is 6 then
				if item 2 of cueCommands is not "eos" and item 3 of cueCommands is not "cue" and cueAppearsValid is true then
					set cueAppearsValid to false
				end if
			else
				set cueAppearsValid to false
			end if
			if cueAppearsValid then
				if (count of cueCommands) is 5 then
					set eosCueList to "0"
					set eosSpecifyCueList to false
					set eosCueNumber to item 4 of cueCommands
				else
					set eosCueList to item 4 of cueCommands
					set eosCueNumber to item 5 of cueCommands
					set eosSpecifyCueList to true
				end if
			end if
			if cueAppearsValid then
				make type "network"
				(* QLab 5: *)
				set qlabNewCue to last item of (selected as list)
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
				set parameter values of qlabNewCue to networkCueValues
				if (count of parameter values of qlabNewCue) is not (count of networkCueValues) then
					-- If the number of values is not the same, something has gone awry
					set q name of qlabNewCue to "PROBLEM - " & q display name of eachCue
					set q color of qlabNewCue to "red"
					set flagged of qlabNewCue to true
					set qlabCueProblems to qlabCueProblems + 1
				end if
				--
				-- END EOS Cue Generator Snippet
				--
				set pre wait of qlabNewCue to pre wait of eachCue
				set duration of qlabNewCue to 0
				set post wait of qlabNewCue to post wait of eachCue
				set network patch number of qlabNewCue to qlabCuePatch
				set newCueNumber to q number of eachCue
				set q number of eachCue to ""
				set q number of qlabNewCue to newCueNumber
				if cueAppearsValid then
					set q color of qlabNewCue to q color of eachCue
					set q name of qlabNewCue to q name of eachCue
				end if
				set continue mode of qlabNewCue to continue mode of eachCue
				set armed of qlabNewCue to armed of eachCue
				set armed of eachCue to false
			else
				set q name of eachCue to "INVALID - " & q display name of eachCue
				set q color of eachCue to "red"
				set flagged of eachCue to true
				set qlabCueProblems to qlabCueProblems + 1
			end if
		end if
	end repeat
end tell
