(*
tell front workspace
	if q type of current cue list is "Cart" then return -- This will stop the script if we're in a cart, as it doesn't make sense to continue!
	try -- This protects against no selection (can't get last item of (selected as list))
		set originalCue to last item of (selected as list)
		make type "Arm"
		set newCue to last item of (selected as list)
		set cue target of newCue to originalCue
		set targetName to q list name of originalCue
		if targetName is "" then
			set targetName to q display name of originalCue
		end if
		set q name of newCue to "Arm: " & targetName
		set originalCueIsIn to parent of originalCue
		if parent of newCue is originalCueIsIn then -- Only reorder the cues if they are in the same group/cue list
			set originalCueID to uniqueID of originalCue
			set newCueID to uniqueID of newCue
			move cue id originalCueID of originalCueIsIn to after cue id newCueID of originalCueIsIn
		end if
	end try
end tell
*)