--This enhances the built-in functionality as it can act on more than one cue at a time; NB: running cues can't be loaded to time

(*
-- Declarations

global dialogTitle
set dialogTitle to "Load to time"

-- Check the Clipboard for a previous time

try
	set clipboardContents to the clipboard as text -- The time requested previously will have been copied to the Clipboard, and may still be on there
on error
	set clipboardContents to ""
end try

if (count paragraphs of clipboardContents) > 1 or (count words of clipboardContents) > 2 or Â
	((count words of clipboardContents) > 1 and clipboardContents does not contain ":") then -- Slight protection against spurious Clipboard contents
	set clipboardContents to ""
end if

-- Prompt to get the time

set promptText to "Load selected cues to this time (seconds or minutes:seconds):" & return & return Â
	& "(You can enter a negative value to specify a time remaining.)"
set {theTime, theOption, inputText} to enterATimeWithIconWithExtraOptionButton(promptText, clipboardContents, "Start the cues too", true, true)

-- Copy the input text to the Clipboard

set the clipboard to inputText as text

-- Load (and start) the cues

tell front workspace
	if theTime < 0 then
		repeat with eachCue in (selected as list)
			load eachCue time ((pre wait of eachCue) + (duration of eachCue) + theTime)
		end repeat
	else
		load selected time theTime
	end if
	if theOption is "Start the cues too" then
		start selected
	end if
end tell

-- Subroutines

(* === INPUT === *)

on enterATimeWithIconWithExtraOptionButton(thePrompt, defaultAnswer, extraOptionButton, clearDefaultAnswerAfterFirst, negativeAllowed) -- [Shared subroutine]
	tell application id "com.figure53.QLab.4"
		set theQuestion to ""
		repeat until theQuestion is not ""
			set {theQuestion, theButton} to {text returned, button returned} of (display dialog thePrompt with title dialogTitle with icon 1 Â
				default answer defaultAnswer buttons (extraOptionButton as list) & {"Cancel", "OK"} default button "OK" cancel button "Cancel")
			if clearDefaultAnswerAfterFirst is true then
				set defaultAnswer to ""
			end if
			try
				set theAnswer to theQuestion as number
				if negativeAllowed is false then
					if theAnswer < 0 then
						set theQuestion to ""
					end if
				end if
			on error
				if theQuestion contains ":" then
					if theQuestion begins with "-" then
						if negativeAllowed is false then
							set theAnswer to false
						else
							set theAnswer to -(my makeSecondsFromM_S(text 2 thru end of theQuestion))
						end if
					else
						set theAnswer to my makeSecondsFromM_S(theQuestion)
					end if
					if theAnswer is false then
						set theQuestion to ""
					end if
				else
					set theQuestion to ""
				end if
			end try
		end repeat
		return {theAnswer, theButton, theQuestion}
	end tell
end enterATimeWithIconWithExtraOptionButton

(* === TIME === *)

on makeSecondsFromM_S(howLong) -- [Shared subroutine]
	try
		set currentTIDs to AppleScript's text item delimiters
		set AppleScript's text item delimiters to ":"
		set theMinutes to first text item of howLong
		set theSeconds to rest of text items of howLong as text
		set AppleScript's text item delimiters to currentTIDs
		return theMinutes * 60 + theSeconds
	on error
		return false
	end try
end makeSecondsFromM_S

*)