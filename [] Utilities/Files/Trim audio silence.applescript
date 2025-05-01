-- @description Reposition the start marker, trim the silence from audio, not perfect.
-- @author Mic Pool
-- @link https://qlab.app/cookbook/top-and-tail/
-- @version 1.0
-- @testedmacos 10.15.7
-- @testedqlab 4.0.8
-- @about This script requires a network cue  numbered "DETECT" sending the following OSC message at 30 fps for a duration of 10 s to port 53000 on localhost
-- /cue/RMS/postWait #/cue/selected/liveAverageLevel/1 0 1#
-- This script requires a memo cue numbered "RMS" to store the current sound level
-- @separateprocess TRUE

-- @changelog
--   v1.0 

set threshold to 0.005 --detect threshold value between 0 and 100
set endThreshold to 0.005
set theStartPad to 0.2
set theEndPad to 0.5
set confirmTime to 0.5 --time to show each edit on screen before moving on 
-----------

display dialog "Set the Start Times of selected audio cues to start of audio" & return & return & "CAUTION: This plays each cue AT FULL LEVEL until the start of the audio" & return & return & " The first 1/10 second of each cue will be audible AND MIGHT BE VERY LOUD!"
--try
tell application id "com.figure53.QLab.4" to tell front workspace
	set theselected to (selected as list)
	repeat with eachCue in theselected
		set mainLevel to (getLevel eachCue row 0 column 0)
		set ch1Level to (getLevel eachCue row 0 column 1)
		setLevel eachCue row 0 column 0 db 0
		setLevel eachCue row 1 column 0 db 0
		set the selected to eachCue
		set the start time of eachCue to 0
		set the end time of eachCue to 99999
		set the post wait of cue "RMS" to 0
		delay 0.1
		start cue "DETECT"
		delay 0.1
		start eachCue
		delay 0.1
		repeat until post wait of cue "RMS" > threshold
			delay 0.01
		end repeat
		pause eachCue
		set the start time of eachCue to the (action elapsed of eachCue) - theStartPad
		stop eachCue
		
		delay confirmTime
		set theIndex to (end time of eachCue) - 0.2 - the (start time of eachCue)
		set x to 999999
		set post wait of cue "RMS" to 0
		repeat until post wait of cue "RMS" > endThreshold
			set theIndex to (theIndex) - 0.2
			delay 0.1
			load (eachCue) time theIndex
			delay 0.1
			start eachCue
			delay 0.2
			set x to theIndex
			pause eachCue
			delay 0.2
		end repeat
		stop eachCue
		set the end time of eachCue to x + (start time of eachCue) + theEndPad
		stop cue "DETECT"
		delay confirmTime
		
		
		setLevel eachCue row 0 column 0 db mainLevel
		setLevel eachCue row 1 column 0 db ch1Level
	end repeat
end tell
--on error
--display dialog "Something Went Wrong!" & return & "Are selected cues all audio?"
--end try

