-- QLab retains slice points within the duration of a new File Target but resets the start & end times (this script maintains start & end times)

(*
tell front workspace
	try -- This protects against no selection (can't get last item of (selected as list))
		set selectedCue to last item of (selected as list)
		if q type of selectedCue is "Audio" then
			set currentStart to start time of selectedCue
			set currentEnd to end time of selectedCue
			set currentFileTarget to file target of selectedCue
			if currentFileTarget is not missing value then
				tell application "System Events"
					set whereToLook to (path of container of (currentFileTarget as alias)) as alias
				end tell
				set newFileTarget to choose file of type "public.audio" with prompt "Please select the new File Target:" default location whereToLook
			else
				set newFileTarget to choose file of type "public.audio" with prompt "Please select the new File Target:"
			end if
			set file target of selectedCue to newFileTarget
			set start time of selectedCue to currentStart
			set end time of selectedCue to currentEnd
		end if
	end try
end tell
*)