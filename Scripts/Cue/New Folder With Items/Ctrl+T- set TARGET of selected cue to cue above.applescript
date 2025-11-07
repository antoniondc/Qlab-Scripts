(*
--For a selected Fade Cue, the script will find the closest preceding Group, Audio, Mic, Video, Camera or Text Cue (rather than just the cue above); likewise, Devamp Cues will look for the closest Audio or Video Cue
-- Declarations

set simpleCases to {"Start", "Stop", "Pause", "Load", "Reset", "GoTo", "Target", "Arm", "Disarm"}
set specialCases to {"Fade", "Devamp"}
set acceptableTargets to {{"Group", "Audio", "Mic", "Video", "Camera", "Text"}, {"Audio", "Video"}}

-- Main routine

tell front workspace
	try -- This protects against no selection (can't get last item of (selected as list))
		set originalCue to last item of (selected as list)
		set originalType to q type of originalCue
		if originalType is in simpleCases then
			set targetCue to cue before originalCue
			set cue target of originalCue to targetCue
			set targetName to q list name of targetCue
			if targetName is "" then
				set targetName to q display name of targetCue
			end if
			set q name of originalCue to originalType & ": " & targetName
		else if originalType is in specialCases then
			repeat with i from 1 to count specialCases
				if originalType is item i of specialCases then
					set acceptableTypes to item i of acceptableTargets
					exit repeat
				end if
			end repeat
			set foundType to ""
			set checkedCue to originalCue
			repeat while foundType is not in acceptableTypes
				set targetCue to cue before checkedCue
				set foundType to q type of targetCue
				if targetCue is first item of cues of current cue list then -- Protect against infinite loop if no acceptable target found
					exit repeat
				end if
				set checkedCue to targetCue
			end repeat
			if foundType is in acceptableTypes then -- Don't change the target if we've gone all the way up the cue list without finding one
				set cue target of originalCue to targetCue
				set targetName to q list name of targetCue
				if targetName is "" then
					set targetName to q display name of targetCue
				end if
				set q name of originalCue to originalType & ": " & targetName
			end if
		end if
	end try
end tell
*)