--WARNING!!!! This script will move selected cues out of any Group Cues they are in and into the new Group Cue. If you want a Group Cue to remain intact when it is moved, DO NOT include its children in the selection! Also, remember that new cues are inserted into the cue list after the last cue that was selected (which is not always the same as the cue at the bottom of the selection); this will dictate where the new Group Cue is made, and hence what is moved into it – as the script can't move an existing Group Cue inside the new Group Cue if the new Group Cue is made within the existing Group Cue… It is subtly different to the built-in behaviour when making a new Group Cue with a selection, not least because it acts on single selected cues! The new Group Cue's settings will follow the Workspace Preferences, by the way. (Doesn't fire in a cart!)
(*
IT IS VERY EASY TO CONSTRUCT ELABORATE NESTS OF GROUPS THAT WILL CAUSE THIS SCRIPT TO HANG QLAB!
tell front workspace

	
	if q type of current cue list is "Cart" then return -- This will stop the script if we're in a cart, as it doesn't make sense to continue!
	
	set selectedCues to (selected as list)
	
	if (count selectedCues) is not 0 then
		
		set selected to last item of selectedCues -- Protect against default behaviour
		make type "Group"
		set groupCue to last item of (selected as list)
		set groupCueIsIn to parent of groupCue
		
		repeat with eachCue in selectedCues
			if contents of eachCue is not groupCueIsIn then -- Skip a Group Cue that contains the new Group Cue
				set eachCueID to uniqueID of eachCue
				try
					move cue id eachCueID of parent of eachCue to end of groupCue
				end try
			end if
		end repeat
		
	end if
	
end tell

*)