tell application id "com.figure53.QLab.4" to tell front workspace
	set themessage to "----------------------------------------------------------------------" & return & "SHOW FILE: " & q number of front document of application id "com.figure53.QLab.4" & return as string
	set the notes of cue "WRITE" to themessage
	start cue "WRITE"
	
end tell
