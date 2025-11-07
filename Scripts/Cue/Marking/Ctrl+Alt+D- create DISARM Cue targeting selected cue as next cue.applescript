(*
tell front workspace
	if q type of current cue list is "Cart" then return -- This will stop the script if we're in a cart, as it doesn't make sense to continue!
	try -- This protects against no selection (can't get last item of (selected as list))
		set originalCue to last item of (selected as list)
		make type "Disarm"
		set newCue to last item of (selected as list)
		set cue target of newCue to originalCue
		set targetName to q list name of originalCue
		if targetName is "" then
			set targetName to q display name of originalCue
		end if
		set q name of newCue to "Disarm: " & targetName
	end try
end tell

*)