-- @description jump to the next cue if the cue is desarmed. Need to set this script to space bar
-- @author Mic Pool
-- @link https://qlab.app/cookbook/
-- @version 1.0
-- @testedmacos 10.15.7
-- @testedqlab 4.0.8
-- @about needs to find the TRUE sorce link
-- @separateprocess TRUE

-- @changelog
--   v1.0  

set skip to true
tell application id "com.figure53.QLab.4" to tell front workspace
	go
	repeat until skip is false
		set thecue to last item of (selected as list)
		if the armed of thecue is false then
			moveSelectionDown
		else
			set skip to false
		end if
	end repeat
end tell