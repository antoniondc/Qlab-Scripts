(*
--This script rather assumes that you are working in such a way that every cue that is triggered by a manual GO is a Group Cue (either "Timeline" or "Start first child and go to next cue"). In addition to Group Cues, it will also process any selected Memo Cues Ð but it will ignore all other cue types. For best results, select the first Group Cue that should still be playing and all intervening cues up to and including the last Group Cue you wish to jump into, but not any of its children. (Doesn't fire in a cart!)




-- Declarations

global dialogTitle
set dialogTitle to "Jump into a string of cues"

-- Main routine

tell front workspace
	
	-- Check we're not in a cart
	
	if q type of current cue list is "Cart" then return
	
	-- Check more than one cue selected
	
	try
		set selectedCues to items 1 thru -2 of (selected as list)
	on error
		display dialog "You need to select more than one cue!" with title dialogTitle with icon 0 buttons {"OK"} default button "OK" giving up after 5
		return
	end try
	
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
	
	set promptText to "This script will load the last selected cue to the time you enter below and attempt to load any other Group Cues selected " & Â
		"so that any fades will effectively have completed when you start the selected cues." & return & return & Â
		"THIS IS NOT GUARANTEED TO WORK!" & return & return & "Enter the load time (seconds or minutes:seconds):"
	set {theTime, unusedVariable, inputText} to my enterATimeWithIconWithExtraOptionButton(promptText, clipboardContents, {}, true, false)
	
	-- Copy the input text to the Clipboard
	
	set the clipboard to inputText as text
	
	-- Clean out cues that won't be processed, and prepare a list for checking to see if remaining selection contains its own childrenÉ
	
	set selectedCuesClean to {}
	set childrenIDs to {}
	repeat with eachCue in selectedCues
		if q type of eachCue is in {"Group", "Memo"} then
			set end of selectedCuesClean to eachCue
			try -- This will fail silently for Memo Cues
				set childrenIDs to childrenIDs & uniqueID of cues of eachCue
			end try
		end if
	end repeat
	
	-- Exit if no cues left to process
	
	if (count selectedCuesClean) is 0 then
		display dialog "Not enough Group or Memo Cues selected to proceed." with title dialogTitle with icon 0 Â
			buttons {"OK"} default button "OK" giving up after 5
		return
	end if
	
	-- Work out the total time to which to load, and temporarily set each Group/Memo Cue to auto-continue
	
	set longestGroupTime to 0
	set summedWaits to 0
	set processedCues to {}
	set continueModes to {}
	
	repeat with eachCue in selectedCuesClean
		
		try
			
			set groupTime to 0
			
			try
				set eachMode to mode of eachCue
			on error -- Memo Cue
				set eachMode to ""
			end try
			
			-- Skip cues that are children of selected Group Cues
			
			if uniqueID of eachCue is in childrenIDs then
				error -- Skip any selected children of selected Group Cues so as not to process them twice
			end if
			
			(* The total time of a "Timeline" Group Cue Ð the time to which to load it to "complete" -
			is the sum of the Pre Wait and Duration of the Fade Cue that will take longest to complete *)
			
			if eachMode is timeline then
				set fadeCues to (cues of eachCue whose q type is "Fade")
				set longestChildFadeTime to 0
				repeat with eachChild in fadeCues
					set eachChildFadeTime to (pre wait of eachChild) + (duration of eachChild)
					if eachChildFadeTime > longestChildFadeTime then
						set longestChildFadeTime to eachChildFadeTime
					end if
				end repeat
				set groupTime to longestChildFadeTime
			end if
			
			(* The total time of a "Start first child and go to next cue" Group Cue Ð the time to which to load it to "complete" -
			is the sum of all the Pre Waits and Post Waits of cues that continue, plus the Duration of the longest Fade Cue *)
			
			if eachMode is fire_first_go_to_next_cue then
				set longestChildFadeTime to 0
				repeat with eachChild in cues of eachCue
					set groupTime to groupTime + (pre wait of eachChild)
					set eachContinueMode to continue mode of eachChild
					if eachContinueMode is auto_continue then
						set groupTime to groupTime + (post wait of eachChild)
						if q type of eachChild is "Fade" then
							set eachChildFadeTime to duration of eachChild
							if eachChildFadeTime > longestChildFadeTime then
								set longestChildFadeTime to eachChildFadeTime
							end if
						end if
					else if eachContinueMode is auto_follow then
						set groupTime to groupTime + (duration of eachChild)
					else
						exit repeat -- No point looking at children after this as they aren't part of the sequence; this child's Pre Wait has been counted
					end if
				end repeat
				set groupTime to groupTime + longestChildFadeTime
			end if
			
			-- Since the Group Cues are being set to auto-continue, loading to the longest of their total times will load them all to "completion"
			
			if groupTime > longestGroupTime then
				set longestGroupTime to groupTime
			end if
			
			(* If any of the Group/Memo Cues have non-zero Pre or Post Waits then these will effectively extend the time to which we have to load,
			so these are summed too *)
			
			set end of processedCues to eachCue
			set end of continueModes to continue mode of eachCue
			set continue mode of eachCue to auto_continue
			set summedWaits to summedWaits + (pre wait of eachCue)
			if contents of eachCue is not last item of selectedCuesClean then
				(* Don't include the penultimate cue's Post wait in the sum as it will be set temporarily to 0 *)
				set summedWaits to summedWaits + (post wait of eachCue)
			end if
			
		end try
		
	end repeat
	
	-- Temporarily change Post Wait of penultimate Group/Memo Cue in selection so that when the string is loaded all other cues will "complete"
	
	set lastPost to post wait of last item of selectedCuesClean
	set post wait of last item of selectedCuesClean to longestGroupTime + summedWaits
	
	-- Load the cue string and prompt to start it
	
	load first item of selectedCuesClean time longestGroupTime + summedWaits + theTime -- This includes the load to time specified by the user in the dialog
	
	try -- This try means that the rest of the script will complete even if the user cancels
		display dialog "Ready to go?" with title dialogTitle with icon 1 buttons {"Cancel", "OK"} default button "OK" cancel button "Cancel"
		start first item of selectedCuesClean
	end try
	
	-- Reset the cues
	
	repeat with i from 1 to count processedCues
		set continue mode of item i of processedCues to item i of continueModes
	end repeat
	set post wait of last item of selectedCuesClean to lastPost
	
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