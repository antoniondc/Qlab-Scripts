set inDuration to 5 --set fade in duration here
set outDuration to 10 --set fade in duration here
set minVolume to -60 -- Set to match minimum volume set in settings/general
tell application id "com.figure53.QLab.4" to tell front workspace
	try
		set audioCue to last item of (selected as list)
		set q number of audioCue to ""
		if q type of audioCue is "Audio" then
			make type "Fade"
			set fadeOutCue to last item of (selected as list)
			set the q number of fadeOutCue to ""
			set cue target of fadeOutCue to audioCue
			set duration of fadeOutCue to outDuration
			fadeOutCue setLevel row 0 column 0 db minVolume
			set stop target when done of fadeOutCue to true
			set q name of fadeOutCue to "Fade out  " & q list name of audioCue & " (" & outDuration & "s)"
			set audioCueLevel to audioCue getLevel row 0 column 0
			fadeOutCue setLevel row 0 column 0 db minVolume
			moveSelectionUp
			make type "Fade"
			set fadeCue to last item of (selected as list)
			set q number of fadeCue to ""
			set cue target of fadeCue to audioCue
			set duration of fadeCue to inDuration
			fadeCue setLevel row 0 column 0 db audioCueLevel
			audioCue setLevel row 0 column 0 db minVolume
			set cuesToGroup to {audioCue, fadeCue}
			make type "Group"
			set groupCue to last item of (selected as list)
			set mode of groupCue to fire_all
			set q name of groupCue to "Fade in " & q list name of audioCue & " (" & inDuration & "s)"
			repeat with eachCue in cuesToGroup
				set eachCueID to uniqueID of eachCue
				move cue id eachCueID of parent of eachCue to end of groupCue
			end repeat
		end if
	end try
end tell
