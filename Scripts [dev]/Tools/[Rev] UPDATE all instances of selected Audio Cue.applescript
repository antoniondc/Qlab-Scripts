-- Copy almost all the scriptable settings from the "Time & Loops" and "Device & Levels" tabs of the Inspector for the selected cue, and then apply them to every Audio Cue in the workspace that references the same file target; the script does not process the "integrated fade envelope toggle", as it can't copy the fades themselvesÉ

-- Best run as a separate process so it can be happening in the background

set userChannelCount to 64 -- Set how many outputs you are using (no point settings levels or gangs beyond this number)
set userLevels to true -- Set this to false if you don't want to update levels
set userGangs to true -- Set this to false if you don't want to update gangs
set userPatch to true -- Set this to false if you don't want to update the Audio Output Patch
set userTimes to true -- Set this to false if you don't want to update start/end times and loop settings
set userSlices to true -- Set this to false if you don't want to update the slice settings (including last slice play count)
set userRate to true -- Set this to false if you don't want to update rate & pitch shift settings

-- Declarations

global dialogTitle, startTime
set dialogTitle to "Update all instances"

-- Find the last Audio Cue in the selection and check it has a valid target, or give up

tell application id "com.figure53.QLab.4"
	
	tell front workspace
		
		try
			set selectedCue to last item of (selected as list)
		on error
			return -- No selection
		end try
		
		if q type of selectedCue is "Audio" then
			set theTarget to file target of selectedCue
		else
			return -- Not an Audio Cue
		end if
		
		if theTarget is missing value then
			display dialog "The selected Audio Cue does not have a valid target." with title dialogTitle with icon 0 Â
				buttons {"OK"} default button "OK" giving up after 5
			return
		end if
		
		my startTheClock()
		
		-- Copy the general properties (get them all regardless as only getting the ones we need would take longer)
		
		set theID to uniqueID of selectedCue
		set thePatch to patch of selectedCue
		set theStart to start time of selectedCue
		set theEnd to end time of selectedCue
		set thePlayCount to play count of selectedCue
		set theInfiniteLoop to infinite loop of selectedCue
		set theLastSlicePlayCount to last slice play count of selectedCue
		set theLastSliceInfiniteLoop to last slice infinite loop of selectedCue
		set theSliceRecord to slice markers of selectedCue
		set theRate to rate of selectedCue
		set thePitchShift to pitch shift of selectedCue
		set howManyChannels to audio input channels of selectedCue
		
		-- Copy the levels
		
		if userLevels is true then
			set theLevels to {}
			repeat with i from 0 to howManyChannels
				repeat with j from 0 to userChannelCount
					set end of theLevels to getLevel selectedCue row i column j
				end repeat
			end repeat
			set theLevelsRef to a reference to theLevels
		end if
		
		-- Copy the gangs
		
		if userGangs is true then
			set theGangs to {}
			repeat with i from 0 to howManyChannels
				repeat with j from 0 to userChannelCount
					set end of theGangs to getGang selectedCue row i column j
				end repeat
			end repeat
			set theGangsRef to a reference to theGangs
		end if
		
		-- Find the other instances
		
		set allInstances to cues whose broken is false and q type is "Audio" and file target is theTarget and uniqueID is not theID
		set allInstancesRef to a reference to allInstances
		set countInstances to count allInstancesRef
		
		repeat with i from 1 to countInstances
			
			set eachCue to item i of allInstancesRef
			
			if userLevels is true then
				repeat with j from 0 to howManyChannels
					repeat with k from 0 to userChannelCount
						setLevel eachCue row j column k db (item (1 + j * (userChannelCount + 1) + k) of theLevelsRef)
					end repeat
				end repeat
			end if
			
			if userGangs is true then
				repeat with j from 0 to howManyChannels
					repeat with k from 0 to userChannelCount
						set storedValue to item (1 + j * (userChannelCount + 1) + k) of theGangsRef
						if storedValue is missing value then set storedValue to ""
						setGang eachCue row j column k gang storedValue
					end repeat
				end repeat
			end if
			
			if userPatch is true then
				set patch of eachCue to thePatch
			end if
			
			if userTimes is true then
				set start time of eachCue to theStart
				set end time of eachCue to theEnd
				set play count of eachCue to thePlayCount
				set infinite loop of eachCue to theInfiniteLoop
			end if
			
			if userSlices is true then
				set last slice play count of eachCue to theLastSlicePlayCount
				set last slice infinite loop of eachCue to theLastSliceInfiniteLoop
				set slice markers of eachCue to theSliceRecord
			end if
			
			if userRate is true then
				set rate of eachCue to theRate
				set pitch shift of eachCue to thePitchShift
			end if
			
			if i < countInstances then -- Countdown timer (and opportunity to escape)
				my countdownTimer(i, countInstances, "instances")
			end if
			
		end repeat
		
		my finishedDialog()
		
	end tell
	
end tell

-- Subroutines

(* === OUTPUT === *)

on startTheClock() -- [Shared subroutine]
	tell application id "com.figure53.QLab.4"
		display dialog "One moment callerÉ" with title dialogTitle with icon 1 buttons {"OK"} default button "OK" giving up after 1
	end tell
	set startTime to current date
end startTheClock

on countdownTimer(thisStep, totalSteps, whichCuesString) -- [Shared subroutine]
	set timeTaken to round (current date) - startTime rounding as taught in school
	set timeString to my makeMSS(timeTaken)
	tell application id "com.figure53.QLab.4"
		if frontmost then
			display dialog "Time elapsed: " & timeString & " Ð " & thisStep & " of " & totalSteps & " " & whichCuesString & Â
				" doneÉ" with title dialogTitle with icon 1 buttons {"Cancel", "OK"} default button "OK" cancel button "Cancel" giving up after 1
		end if
	end tell
end countdownTimer

on finishedDialog() -- [Shared subroutine]
	set timeTaken to round (current date) - startTime rounding as taught in school
	set timeString to my makeNiceT(timeTaken)
	tell application id "com.figure53.QLab.4"
		activate
		display dialog "Done." & return & return & "(That took " & timeString & ".)" with title dialogTitle with icon 1 Â
			buttons {"OK"} default button "OK" giving up after 60
	end tell
end finishedDialog

(* === TIME === *)

on makeMSS(howLong) -- [Shared subroutine]
	set howManyMinutes to howLong div 60
	set howManySeconds to howLong mod 60 div 1
	return (howManyMinutes as text) & ":" & my padNumber(howManySeconds, 2)
end makeMSS

on makeNiceT(howLong) -- [Shared subroutine]
	if howLong < 1 then
		return "less than a second"
	end if
	set howManyHours to howLong div 3600
	if howManyHours is 0 then
		set hourString to ""
	else if howManyHours is 1 then
		set hourString to "1 hour"
	else
		set hourString to (howManyHours as text) & " hours"
	end if
	set howManyMinutes to howLong mod 3600 div 60
	if howManyMinutes is 0 then
		set minuteString to ""
	else if howManyMinutes is 1 then
		set minuteString to "1 minute"
	else
		set minuteString to (howManyMinutes as text) & " minutes"
	end if
	set howManySeconds to howLong mod 60 div 1
	if howManySeconds is 0 then
		set secondString to ""
	else if howManySeconds is 1 then
		set secondString to "1 second"
	else
		set secondString to (howManySeconds as text) & " seconds"
	end if
	set theAmpersand to ""
	if hourString is not "" then
		if minuteString is not "" and secondString is not "" then
			set theAmpersand to ", "
		else if minuteString is not "" or secondString is not "" then
			set theAmpersand to " and "
		end if
	end if
	set theOtherAmpersand to ""
	if minuteString is not "" and secondString is not "" then
		set theOtherAmpersand to " and "
	end if
	return hourString & theAmpersand & minuteString & theOtherAmpersand & secondString
end makeNiceT

(* === TEXT WRANGLING === *)

on padNumber(theNumber, minimumDigits) -- [Shared subroutine]
	set paddedNumber to theNumber as text
	repeat while (count paddedNumber) < minimumDigits
		set paddedNumber to "0" & paddedNumber
	end repeat
	return paddedNumber
end padNumber