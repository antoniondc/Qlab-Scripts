(* 

6/9/2024
Tested with EOS 3.2.8 and QLab v5.3.8 on macOS Sonoma 14.4.1

Please refer to my repository for any updates or to report problems you may find
https://github.com/acousticnonchalant/ScriptsForQLab

ETC EOS Cue Batch Value Changer
This script will take existing selected EOS cues in QLab and change either the user number data or cue list data per your specifications.

ETC SHOW CONTROL USER GUIDE:
https://www.etcconnect.com/workarea/DownloadAsset.aspx?id=10737461372

File Name: QLab 5 - ETC EOS - Batch Change User or CueList

Written by Chase Elison 
chase@chaseelison.com

*)

use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

tell application id "com.figure53.QLab.5" to tell front workspace
	display dialog "What would you like to change?" with icon 1 buttons {"User", "Cue List", "Cancel"} default button "Cue List" cancel button "Cancel"
	if button returned of result is "User" then
		display dialog "Do you wish to specify a user?" with icon 1 buttons {"Yes", "No", "Cancel"} default button "No" cancel button "Cancel"
		if button returned of result is "Yes" then
			display dialog "What user number?" with icon 1 default answer "1"
			set userNumber to text returned of result
			set typeChange to "User"
			set useUser to true
		else if button returned of result is "No" then
			set typeChange to "User"
			set useUser to false
			set userNumber to 0
		end if
	else if button returned of result is "Cue List" then
		display dialog "Do you wish to specify a cue list?" with icon 1 buttons {"Yes", "No", "Cancel"} default button "Yes" cancel button "Cancel"
		if button returned of result is "Yes" then
			display dialog "What cue list number?" with icon 1 default answer "1"
			set listNumber to text returned of result
			set typeChange to "CueList"
			set useList to true
		else if button returned of result is "No" then
			set typeChange to "CueList"
			set useList to false
			set listNumber to 0
		end if
	end if
	
	if typeChange is "User" then
		if useUser then
			set newUserData to {"yes", userNumber as text}
		else
			set newUserData to {"no"}
		end if
	else if typeChange is "CueList" then
		if useList then
			set newListData to {"fireInList", listNumber as text}
		else
			set newListData to {"fire"}
		end if
	end if
	
	
	set theSelection to (selected as list)
	repeat with eachCue in theSelection
		if q type of eachCue is "Network" then
			set parameterValues to parameter values of eachCue
			if (item 1 of parameterValues) is "cue" then
				--display dialog "Yep: " & q display name of eachCue
				set successfulChange to false
				
				if typeChange is "User" then
					try
						if item 2 of parameterValues is "no" then
							set newValues to {"cue"}
							set newValues to newValues & newUserData
							set newValues to newValues & (items 3 through (count of parameterValues) of parameterValues)
							--display dialog newValues as text
							set successfulChange to true
						else if item 2 of parameterValues is "yes" then
							set newValues to {"cue"}
							set newValues to newValues & newUserData
							set newValues to newValues & (items 4 through (count of parameterValues) of parameterValues)
							--display dialog newValues as text
							set successfulChange to true
						end if
					end try
				else if typeChange is "CueList" then
					set repeatSucceeded to false
					repeat with x from 1 to count of parameterValues
						if item x of parameterValues is "fire" then
							set repeatSucceeded to true
							set cueCommandIndex to x
							set useList to false
						else if item x of parameterValues is "fireInList" then
							set repeatSucceeded to true
							set cueCommandIndex to x
							set useList to true
						else
							set x to x + 1
						end if
					end repeat
					try
						if repeatSucceeded then
							set newValues to (items 1 through (cueCommandIndex - 1) of parameterValues)
							set newValues to newValues & newListData
							set newValues to newValues & (item (count of parameterValues) of parameterValues)
							--display dialog newValues as text
							set successfulChange to true
						end if
					end try
				end if
				
				if successfulChange then
					set parameter values of eachCue to newValues
				end if
			end if
		end if
	end repeat
end tell
