set mycue to "LOG3"
set themessage to "Curtain Up Act 2"
tell application id "com.figure53.QLab.4" to tell front workspace
	set notes of cue mycue to (do shell script "date +%s") as integer
	set thedate to current date
	set this_data to (thedate as string) & space & themessage & return
	set the notes of cue "WRITE" to this_data
	start cue "WRITE"
end tell