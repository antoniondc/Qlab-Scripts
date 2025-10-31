(* 

12/4/2023
Tested with EOS 3.2.5 and QLab v5.3.2 on macOS Ventura 13.6.1

Please refer to my repository for any updates or to report problems you may find
https://github.com/acousticnonchalant/ScriptsForQLab

ETC EOS QLab Cue Renumber
This script will renumber existing EOS control cues in QLab. It renumbers the conrol and tries to renumber the Q name too.

ETC SHOW CONTROL USER GUIDE:
https://www.etcconnect.com/workarea/DownloadAsset.aspx?id=10737461372

File Name: QLab 5 - ETC EOS - Renumber Existing Cues

Written by Chase Elison 
chase@chaseelison.com

*)

use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

set defaultPrefix to "Q"

tell application id "com.figure53.qlab.5" to tell front workspace
	if edit mode is false then return
	set theSelection to selected as list
	repeat with eachCue in theSelection
		if q type of eachCue is in {"Network", "MIDI"} then
			set changeThisCue to false
			set cueType to ""
			set netCustomMessage to false
			if q type of eachCue is "Network" then
				set parameterValues to parameter values of eachCue
				if item 1 of parameterValues is "cue" then
					set oldCueNumber to last item of parameterValues
					set changeThisCue to true
					set cueType to "Network"
				else if custom message of eachCue is not "" then
					set customMessage to custom message of eachCue
					set AppleScript's text item delimiters to the "/"
					set the itemList to every text item of customMessage
					set AppleScript's text item delimiters to the "  -  "
					--set whichOne to choose from list itemList with prompt "Which one is the cue number?" default items item ((count of itemList) - 1) of itemList
					--display dialog whichOne as text
					set listLocation to ((count of itemList) - 1)
					set oldCueNumber to item listLocation of itemList
					set changeThisCue to true
					set cueType to "Network"
					set netCustomMessage to true
				end if
			else if q type of eachCue is "MIDI" and message type of eachCue is msc then
				set oldCueNumber to q_number of eachCue
				set changeThisCue to true
				set cueType to "MIDI"
			end if
			if changeThisCue then
				display dialog "\"" & q display name of eachCue & "\" [Q" & oldCueNumber & "] New Cue #?" with icon 1 default answer oldCueNumber
				set newCueNumber to text returned of result
				if newCueNumber is "" or newCueNumber is oldCueNumber then
					set changeThisCue to false
				end if
			end if
			if changeThisCue then
				if cueType is "Network" then
					if netCustomMessage then
						set item listLocation of itemList to newCueNumber
						set AppleScript's text item delimiters to the "/"
						set newCommand to the itemList as string
						set custom message of eachCue to newCommand
					else
						set last item of parameterValues to newCueNumber
						set parameter values of eachCue to parameterValues
					end if
				else --Assumes it's MIDI
					set q_number of eachCue to newCueNumber
				end if
				if q display name of eachCue contains oldCueNumber then
					set newQDisplayName to q display name of eachCue
					set AppleScript's text item delimiters to the oldCueNumber
					set the NameList to every text item of newQDisplayName
					set AppleScript's text item delimiters to the newCueNumber
					set q name of eachCue to the NameList as string
				else
					set oldQDisplayName to q display name of eachCue
					set q name of eachCue to "[" & defaultPrefix & newCueNumber & "] " & oldQDisplayName
				end if
			end if
		end if
	end repeat
end tell
