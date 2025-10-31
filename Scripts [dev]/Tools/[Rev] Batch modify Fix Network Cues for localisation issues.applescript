-- Run this ONCE to localise the Network Cues in the template if you use "," rather than "." for the decimal point

set userSearchFor to "." -- Number separator to be replaced
set userReplaceWith to "," -- Replacement value

tell application id "com.figure53.QLab.4" to tell front workspace
	set vulnerableCues to cues whose q type is "Network" and custom message contains userSearchFor
	set currentTIDs to AppleScript's text item delimiters
	repeat with eachCue in vulnerableCues
		set AppleScript's text item delimiters to userSearchFor
		set eachMessage to custom message of eachCue
		set eachList to text items of eachMessage
		set AppleScript's text item delimiters to userReplaceWith
		set custom message of eachCue to eachList as text
	end repeat
	set AppleScript's text item delimiters to currentTIDs
end tell