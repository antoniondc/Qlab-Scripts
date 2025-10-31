-- Shift+Ctrl+DEL: DELETE selected cue(s) including their File Targets
-- ===== © 2019 rich walsh | www.allthatyouhear.com =====

tell application id "com.figure53.QLab.4" to tell front workspace
	repeat with eachCue in (selected as list)
		try
			set eachTarget to file target of eachCue
			if eachTarget as text does not contain ".Trash" then
				tell application "Finder"
					delete eachTarget
				end tell
			end if
		end try
		set eachCueID to uniqueID of eachCue
		delete cue id eachCueID of parent of eachCue
	end repeat
end tell