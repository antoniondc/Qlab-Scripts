tell application id "com.figure53.QLab.4"
	tell front workspace
		set myCue to cue "AMB006"
		
		if myCue exists then
			set infinite loop of myCue to true
			start myCue
		else
			display dialog "? Cue 'AMB006' not found." buttons {"OK"} default button "OK"
		end if
	end tell
end tell

--loop de um cue especifico

