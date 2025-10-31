-- Best run as a separate process so it can be happening in the background
-- This script will create a Group Cue containing a sequence of soundcheck cues, made from an Audio Cue you choose 
--© 2019 rich walsh | www.allthatyouhear.com

set userSoundcheckList to "Soundcheck" -- Use this to set the name of the cue list in which to search for the root Audio Cue
set userMinVolume to -120 -- Set what level you mean by "faded out" (you can adjust this to match the workspace "Min Volume Limit" if necessary)

set userVerboseMode to true -- Set this to false to use the next 4 user settings below without any dialogs
set userNumberOfOutputsToCheck to 32 -- Set your preferred option for how many outputs to check Ð confirmed by dialog
set userCrossfadeDuration to 1 -- Set your preferred option for how long the crossfades should be Ð confirmed by dialog
set userStartSequenceWithFadeIn to true -- Set your preferred option for fading in at the start Ð confirmed by dialog
set userAutomaticFollowOnTime to "" -- Set the time spent at each output (or "" for no follow-ons) Ð confirmed by dialog

set userDefaultCueNumberForSoundcheckCue to "999" -- Set the Cue Number for the soundcheck cue (or "" for workspace default)

set userStartCueName to "Start soundcheck" -- Set the name for the first cue
set userFadeInCueName to "Fade in output " -- Set the name for the fade-in cue, if used
set userMoveCuesBaseName to "Move to output " -- Set the base name for the move cues
set userMoveCuesBaseNotes to "You are listening to output " -- Set the base Notes for the move cues
set userFollowOnCueNames to {"     Automatic follow-onÉ", "     ÉAutomatic follow-on"} -- Set the names for the cues used to create the follow-ons, if used
set userStopCueName to "Stop soundcheck" -- Set the name for the final cue

-- Explanations

set theExplanation to "This script will create a Group Cue containing a sequence of soundcheck cues made from an Audio Cue you choose from the \"" & Â
	userSoundcheckList & "\" cue list (the Audio Cue needs to be directly in the cue list, not inside a Group Cue). " & Â
	"The soundcheck will step through one output at a time via a sequence of default crossfades.

Before running the script you should configure the Audio Cue to play at the desired levels out of all the outputs you wish to check, " & Â
	"as these levels will be used in the fades. The script will not adjust crosspoints.

Several additional user settings can be adjusted by editing the script itself."

-- Declarations

global dialogTitle
set dialogTitle to "Make a soundcheck sequence"

set qLabMaxAudioChannels to 64

-- Preamble

tell application id "com.figure53.QLab.4" to tell front workspace
	
	-- Display introductory dialog, if in verbose mode
	
	if userVerboseMode is true then
		display dialog theExplanation with title dialogTitle with icon 1 buttons {"Cancel", "OK"} default button "OK" cancel button "Cancel"
	end if
	
	-- Exit if userSoundcheckList doesn't exist
	
	try
		set soundcheckList to first cue list whose q name is userSoundcheckList
	on error
		display dialog "The cue list \"" & userSoundcheckList & "\" can not be foundÉ" with title dialogTitle with icon 0 Â
			buttons {"OK"} default button "OK" giving up after 5
		return
	end try
	
	-- Exit if userSoundcheckList is a cart
	
	try
		set notCaseSensitiveMatch to q name of soundcheckList
		if q type of soundcheckList is "Cart" then
			display dialog "The destination cue list \"" & notCaseSensitiveMatch & "\" is a cart, so no Group Cues can be madeÉ" with title dialogTitle Â
				with icon 0 buttons {"OK"} default button "OK"
			return
		end if
	end try
	
	-- Exit if there aren't any Audio Cues in userSoundcheckList
	
	set possibleCues to cues of soundcheckList whose q type is "Audio" and broken is false
	set countPossibleCues to count possibleCues
	
	if countPossibleCues is 0 then
		display dialog "No Audio Cues found directly in the \"" & userSoundcheckList & "\" cue list." with title dialogTitle with icon 0 Â
			buttons {"OK"} default button "OK" giving up after 5
		return
	end if
	
	-- Check to see if any possible Audio Cues have Cue Numbers, and prepare the choose from list dialog accordingly
	
	set possibleCueNames to q list name of cues of soundcheckList whose q type is "Audio" and broken is false
	set possibleCueNumbers to q number of cues of soundcheckList whose q type is "Audio" and broken is false
	
	set currentTIDs to AppleScript's text item delimiters
	set AppleScript's text item delimiters to "" -- Should not assume this
	if possibleCueNumbers as text is not "" then
		repeat with i from 1 to countPossibleCues
			set item i of possibleCueNames to (item i of possibleCueNumbers & tab & item i of possibleCueNames) as text
		end repeat
	end if
	set AppleScript's text item delimiters to currentTIDs
	
	-- Choose which Audio Cue
	
	set theAudioCueName to my pickFromList(possibleCueNames, "Please choose the Audio Cue:")
	
	repeat with i from 1 to countPossibleCues
		if theAudioCueName is item i of possibleCueNames then
			set theAudioCue to item i of possibleCues
			exit repeat
		end if
	end repeat
	
	-- Get all output levels from the Audio Cue (except Master)
	
	set allOutCheck to true
	set originalCueLevels to {}
	repeat with i from 1 to qLabMaxAudioChannels
		set thisOutputLevel to theAudioCue getLevel row 0 column i
		if thisOutputLevel is not userMinVolume then
			set allOutCheck to false
		end if
		set end of originalCueLevels to thisOutputLevel
	end repeat
	
	-- Exit if there are no levels set in the Audio Cue
	
	if allOutCheck is true then
		display dialog "The last selected Audio Cue has all its individual output levels set to \"-INF\".

It makes no sense to proceedÉ" with title dialogTitle with icon 0 buttons {"OK"} default button "OK"
		return
	end if
	
	-- Skip the dialogs if userVerboseMode is false
	
	if userVerboseMode is false then
		
		set howManyOutputs to userNumberOfOutputsToCheck
		set howLong to userCrossfadeDuration
		set fadeIn to userStartSequenceWithFadeIn
		set followOn to userAutomaticFollowOnTime
		
	else
		
		-- Prompt for how many outputs to test
		
		set howManyOutputs to my enterANumberWithRangeWithCustomButton("How many outputs do you wish to check?", userNumberOfOutputsToCheck, Â
			2, true, qLabMaxAudioChannels, true, true, {}, 2)
		
		-- Prompt for length of crossfades
		
		set howLong to my enterANumberWithRangeWithCustomButton("Enter a duration for the crossfades (in seconds):", userCrossfadeDuration, Â
			0, true, false, false, false, {}, 2)
		
		-- Prompt for whether there should be a fade in at the start
		
		if userStartSequenceWithFadeIn is true then
			set fadeButtons to {"Cancel", "No", "Yes"}
		else
			set fadeButtons to {"Cancel", "Yes", "No"}
		end if
		set fadeQuestion to button returned of (display dialog "Would you like the sequence to start by fading in?" with title dialogTitle with icon 1 Â
			buttons fadeButtons default button 3 cancel button 1)
		if fadeQuestion is "Yes" then
			set fadeIn to true
		else
			set fadeIn to false
		end if
		
		-- Prompt for whether the sequence should automatically follow-on
		
		set followOnMessage to "Set the time spent at each output (in seconds):"
		if userAutomaticFollowOnTime is "" then
			set followOnDefault to 1
			set followOnMessage to followOnMessage & return & return & "(You'll need to click \"OK\" to enter a time, not press return.)"
			-- ###FIXME### This could be more elegant: use text returned to test for an entry
		else
			set followOnDefault to 3
		end if
		
		set followOn to my enterANumberWithRangeWithCustomButton(followOnMessage, userAutomaticFollowOnTime, Â
			0, true, false, false, false, "No follow-ons", followOnDefault)
		
		if followOn is "No follow-ons" then
			set followOn to ""
		end if
		
	end if
	
	-- The bit of the script that actually does the work starts hereÉ
	
	display dialog "One moment callerÉ" with title dialogTitle with icon 1 buttons {"OK"} default button "OK" giving up after 1
	
	-- Switch to userSoundcheckList
	
	set current cue list to soundcheckList
	
	-- Make a new Group Cue for the sequence: after the Audio Cue
	
	set selected to theAudioCue -- This also protects against the default behaviour of grouping selection if more than 2 selected
	make type "Group"
	set theGroupCue to last item of (selected as list)
	set mode of theGroupCue to fire_first_enter_group
	set q name of theGroupCue to userStartCueName
	if userDefaultCueNumberForSoundcheckCue is not "" then
		set q number of theGroupCue to userDefaultCueNumberForSoundcheckCue
	end if
	
	-- Move the Audio Cue inside the Group Cue
	
	set theAudioCueID to uniqueID of theAudioCue
	set theAudioCueIsIn to parent of theAudioCue
	set theGroupCueID to uniqueID of theGroupCue
	move cue id theAudioCueID of theAudioCueIsIn to end of cue id theGroupCueID
	set selected to theAudioCue -- The Group Cue was the last selection, so we need to select a cue inside the group before making the fades
	
	-- Set outputs 2 & above to -INF (do all the outputs regardless of userNumberOfOutputsToCheck so there's no unexpected audio from higher output numbers)
	
	set outputOneGang to getGang theAudioCue row 0 column 1
	if outputOneGang is not missing value then
		setGang theAudioCue row 0 column 1 gang "" -- Temporarily override gang for output 1 (it affects setLevel on the Audio Cue, but not on any fades)
	end if
	
	repeat with i from 2 to qLabMaxAudioChannels
		theAudioCue setLevel row 0 column i db userMinVolume
	end repeat
	
	if outputOneGang is not missing value then
		setGang theAudioCue row 0 column 1 gang outputOneGang
	end if
	
	-- Create fade in, if necessary
	
	if fadeIn is true then
		theAudioCue setLevel row 0 column 1 db userMinVolume
		set continue mode of theAudioCue to auto_continue
		make type "Fade"
		set newCue to last item of (selected as list)
		set cue target of newCue to theAudioCue
		set duration of newCue to howLong
		set newCueLevels to item 1 of originalCueLevels
		newCue setLevel row 0 column 1 db newCueLevels
		if followOn is "" then
			set q name of newCue to userFadeInCueName & "1"
		else
			my makeCrashableWait(newCue, followOn, true, Â
				userFadeInCueName & "1", item 2 of userFollowOnCueNames, userMoveCuesBaseName & "2", userMoveCuesBaseNotes & "1")
		end if
	else
		if followOn is "" then
			set continue mode of theAudioCue to do_not_continue
		else
			my makeCrashableWait(theAudioCue, followOn, false, Â
				false, item 2 of userFollowOnCueNames, userMoveCuesBaseName & "2", userMoveCuesBaseNotes & "1")
		end if
	end if
	
	-- Make fades
	
	repeat with i from 2 to howManyOutputs
		make type "Fade"
		set newCue to last item of (selected as list)
		set cue target of newCue to theAudioCue
		set duration of newCue to howLong
		set newCueLevels to item i of originalCueLevels
		newCue setLevel row 0 column i db newCueLevels
		newCue setLevel row 0 column (i - 1) db userMinVolume
		if followOn is "" then
			set q name of newCue to userMoveCuesBaseName & i
			set notes of newCue to userMoveCuesBaseNotes & (i - 1)
		else if i < howManyOutputs then
			my makeCrashableWait(newCue, followOn, true, Â
				item 1 of userFollowOnCueNames, item 2 of userFollowOnCueNames, userMoveCuesBaseName & (i + 1), userMoveCuesBaseNotes & i)
		else
			my makeCrashableWait(newCue, followOn, true, Â
				item 1 of userFollowOnCueNames, item 2 of userFollowOnCueNames, userStopCueName, userMoveCuesBaseNotes & i)
		end if
	end repeat
	
	-- Make final fade out
	
	make type "Fade"
	set newCue to last item of (selected as list)
	set cue target of newCue to theAudioCue
	set duration of newCue to howLong
	newCue setLevel row 0 column howManyOutputs db userMinVolume
	set stop target when done of newCue to true
	if followOn is "" then
		set q name of newCue to userStopCueName
		set notes of newCue to userMoveCuesBaseNotes & howManyOutputs
	else
		set q name of newCue to item 2 of userFollowOnCueNames
	end if
	
	activate
	display dialog "Done." with title dialogTitle with icon 1 buttons {"OK"} default button "OK" giving up after 60
	
end tell

-- Subroutines

(* === INPUT === *)

on enterANumberWithRangeWithCustomButton(thePrompt, defaultAnswer, Â
	lowRange, acceptEqualsLowRange, highRange, acceptEqualsHighRange, integerOnly, customButton, defaultButton) -- [Shared subroutine]
	tell application id "com.figure53.QLab.4"
		set theQuestion to ""
		repeat until theQuestion is not ""
			set {theQuestion, theButton} to {text returned, button returned} of (display dialog thePrompt with title dialogTitle Â
				default answer defaultAnswer buttons (customButton as list) & {"Cancel", "OK"} default button defaultButton cancel button "Cancel")
			if theButton is customButton then
				set theAnswer to theButton
				exit repeat
			end if
			try
				if integerOnly is true then
					set theAnswer to theQuestion as integer -- Detects non-numeric strings
					if theAnswer as text is not theQuestion then -- Detects non-integer input
						set theQuestion to ""
					end if
				else
					set theAnswer to theQuestion as number -- Detects non-numeric strings
				end if
				if lowRange is not false then
					if acceptEqualsLowRange is true then
						if theAnswer < lowRange then
							set theQuestion to ""
						end if
					else
						if theAnswer ² lowRange then
							set theQuestion to ""
						end if
					end if
				end if
				if highRange is not false then
					if acceptEqualsHighRange is true then
						if theAnswer > highRange then
							set theQuestion to ""
						end if
					else
						if theAnswer ³ highRange then
							set theQuestion to ""
						end if
					end if
				end if
			on error
				set theQuestion to ""
			end try
		end repeat
		return theAnswer
	end tell
end enterANumberWithRangeWithCustomButton

on pickFromList(theChoice, thePrompt) -- [Shared subroutine]
	tell application id "com.figure53.QLab.4"
		choose from list theChoice with prompt thePrompt with title dialogTitle default items item 1 of theChoice
		if result is not false then
			return item 1 of result
		else
			error number -128
		end if
	end tell
end pickFromList

(* === PROCESSING === *)

on makeCrashableWait(originalCue, waitTime, autoFollow, originalCueName, startCueName, stopCueName, stopCueNotes)
	tell application id "com.figure53.QLab.4" to tell front workspace
		if autoFollow is false then
			set continue mode of originalCue to auto_continue
		else
			set continue mode of originalCue to auto_follow
		end if
		if originalCueName is not false then
			set q name of originalCue to originalCueName
		end if
		make type "Start"
		set newStartCue to last item of (selected as list)
		set cue target of newStartCue to current cue list
		set pre wait of newStartCue to waitTime
		set q name of newStartCue to startCueName
		make type "Stop"
		set newStopCue to last item of (selected as list)
		set cue target of newStopCue to newStartCue
		set q name of newStopCue to stopCueName
		set notes of newStopCue to stopCueNotes -- The "crashable wait" pauses on the Stop Cue
		set continue mode of newStopCue to auto_continue
	end tell
end makeCrashableWait