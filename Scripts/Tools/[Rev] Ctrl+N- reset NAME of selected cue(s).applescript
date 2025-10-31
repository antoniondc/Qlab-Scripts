-- This script can optionally convert note numbers in MIDI Cues to note names and mark looped cues: use the variables below to set the behaviour

set userMIDIConversionMode to item 1 of {"Numbers", "Names", "Both"} -- Use this to choose how MIDI note values will be included in cue names
set userNote60Is to item 1 of {"C3", "C4"} -- Use this to set which note name corresponds to note 60

set userFlagInfiniteLoops to true -- Set whether to append the comments below to the default names of Audio & Video Cues that contain infinite loops
set userInfiniteCueFlag to "!! Infinite loop !!"
set userInfiniteSliceFlag to "!! Infinite slice !!"

-- Declarations

global userMIDIConversionMode, noteNames, octaveConvention
set noteNames to {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"}
if userNote60Is is "C3" then
	set octaveConvention to -2
else
	set octaveConvention to -1
end if

set mscCommandFormat to {1, "Lighting (General)", 2, "Moving Lights", 3, "Color Changers", 4, "Strobes", 5, "Lasers", 6, "Chasers", Â
	16, "Sound (General)", 17, "Music", 18, "CD Players", 19, "EPROM Playback", 20, "Audio Tape Machines", 21, "Intercoms", 22, "Amplifiers", Â
	23, "Audio Effects Devices", 24, "Equalizers", 32, "Machinery (General)", 33, "Rigging", 34, "Flys", 35, "Lifts", 36, "Turntables", 37, "Trusses", Â
	38, "Robots", 39, "Animation", 40, "Floats", 41, "Breakaways", 42, "Barges", 48, "Video (General)", 49, "Video Tape Machines", Â
	50, "Video Cassette Machines", 51, "Video Disc Players", 52, "Video Switchers", 53, "Video Effects", 54, "Video Character Generators", Â
	55, "Video Still Stores", 56, "Video Monitors", 64, "Projection (General)", 65, "Film Projectors", 66, "Slide Projectors", 67, "Video Projectors", Â
	68, "Dissolvers", 69, "Shutter Controls", 80, "Process Control (General)", 81, "Hydraulic Oil", 82, "H2O", 83, "CO2", 84, "Compressed Air", Â
	85, "Natural Gas", 86, "Fog", 87, "Smoke", 88, "Cracked Haze", 96, "Pyrotechnics (General)", 97, "Fireworks", 98, "Explosions", 99, "Flame", Â
	100, "Smoke Pots", 127, "All Types"}
set mscCommandNumber to {1, "GO", 2, "STOP", 3, "RESUME", 4, "TIMED_GO", 5, "LOAD", 6, "SET", 7, "FIRE", 8, "ALL_OFF", Â
	9, "RESTORE", 10, "RESET", 11, "GO_OFF", 16, "GO/JAM_CLOCK", 17, "STANDBY_+", 18, "STANDBY_-", 19, "SEQUENCE_+", Â
	20, "SEQUENCE_-", 21, "START_CLOCK", 22, "STOP_CLOCK", 23, "ZERO_CLOCK", 24, "SET_CLOCK", 25, "MTC_CHASE_ON", Â
	26, "MTC_CHASE_OFF", 27, "OPEN_CUE_LIST", 28, "CLOSE_CUE_LIST", 29, "OPEN_CUE_PATH", 30, "CLOSE_CUE_PATH"}
set mscCommandTakesQNumber to {1, 2, 3, 4, 5, 11, 16}
set mscCommandTakesQList to {1, 2, 3, 4, 5, 11, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28}
set mscCommandTakesQPath to {1, 2, 3, 4, 5, 11, 16, 29, 30}
set mscCommandTakesMacro to {7}
set mscCommandTakesControl to {6}
set mscCommandTakesTC to {4, 6, 24}

-- Main routine

tell application id "com.figure53.QLab.4" to tell front workspace
	repeat with eachCue in (selected as list)
		try -- Audio, Video or MIDI File Cues
			set eachFile to file target of eachCue as alias
			tell application "System Events"
				set eachNameList to {name of eachFile}
			end tell
			try
				if infinite loop of eachCue is true then
					set end of eachNameList to userInfiniteCueFlag
				end if
				if last slice infinite loop of eachCue is true then
					set end of eachNameList to userInfiniteSliceFlag
				end if
			end try
			set currentTIDs to AppleScript's text item delimiters
			set AppleScript's text item delimiters to " | "
			set q name of eachCue to eachNameList as text
			set AppleScript's text item delimiters to currentTIDs
		on error
			try -- Fade, Start, Stop, Pause, Load, Reset, Devamp, GoTo, Target, Arm or Disarm Cues
				set eachTarget to q list name of cue target of eachCue
				if eachTarget is "" then
					set eachTarget to q display name of cue target of eachCue
				end if
				set eachType to q type of eachCue
				if eachType is "Fade" then
					if stop target when done of eachCue is true then
						set q name of eachCue to "Fade out: " & eachTarget
					else
						set q name of eachCue to "Fade: " & eachTarget
					end if
				else
					set q name of eachCue to eachType & ": " & eachTarget
				end if
			on error
				try -- MIDI Cues
					set messageType to message type of eachCue
					if messageType is voice then
						set eachChannel to channel of eachCue
						set eachCommand to command of eachCue
						if eachCommand is note_on then
							set byteOne to byte one of eachCue
							set byteTwo to byte two of eachCue
							set q name of eachCue to "Channel " & eachChannel & " | Note On | " & my convertMIDINoteValues(byteOne, byteTwo)
						else if eachCommand is note_off then
							set byteOne to byte one of eachCue
							set byteTwo to byte two of eachCue
							set q name of eachCue to "Channel " & eachChannel & " | Note Off | " & my convertMIDINoteValues(byteOne, byteTwo)
						else if eachCommand is program_change then
							set byteOne to byte one of eachCue
							set q name of eachCue to "Channel " & eachChannel & " | Program Change | " & byteOne
						else if eachCommand is control_change then
							set byteOne to byte one of eachCue
							set byteTwo to byte two of eachCue
							if integrated fade of eachCue is disabled then
								set q name of eachCue to "Channel " & eachChannel & " | Control Change | " & byteOne & " @ " & byteTwo
							else
								set endValue to end value of eachCue
								set q name of eachCue to "Channel " & eachChannel & " | Control Change | " & byteOne & " @ " & byteTwo Â
									& " É " & endValue
							end if
						else if eachCommand is key_pressure then
							set byteOne to byte one of eachCue
							set byteTwo to byte two of eachCue
							if integrated fade of eachCue is disabled then
								set q name of eachCue to "Channel " & eachChannel & " | Key Pressure | " & my convertMIDINoteValues(byteOne, byteTwo)
							else
								set endValue to end value of eachCue
								set q name of eachCue to Â
									"Channel " & eachChannel & " | Key Pressure | " & my convertMIDINoteValues(byteOne, byteTwo & " É " & endValue)
							end if
						else if eachCommand is channel_pressure then
							set byteOne to byte one of eachCue
							set q name of eachCue to "Channel " & eachChannel & " | Channel Pressure | " & byteOne
							if integrated fade of eachCue is disabled then
							else
								set endValue to end value of eachCue
								set q name of eachCue to "Channel " & eachChannel & " | Channel Pressure | " & byteOne & " É " & endValue
							end if
						else if eachCommand is pitch_bend then
							set byteCombo to (byte combo of eachCue) - 8192
							if integrated fade of eachCue is disabled then
								set q name of eachCue to "Channel " & eachChannel & " | Pitch Bend | " & byteCombo
							else
								set endValue to (end value of eachCue) - 8192
								set q name of eachCue to "Channel " & eachChannel & " | Pitch Bend | " & byteCombo & " É " & endValue
							end if
						end if
					else if messageType is msc then
						set mscProperties to {}
						set mscEmptyQNumber to false
						set mscEmptyQList to false
						set end of mscProperties to my lookUp(command format of eachCue, mscCommandFormat)
						set end of mscProperties to {"Device ID " & deviceID of eachCue}
						set mscCommand to command number of eachCue
						set end of mscProperties to my lookUp(mscCommand, mscCommandNumber)
						if mscCommand is in mscCommandTakesQNumber then
							set mscQNumber to q_number of eachCue
							if mscQNumber is not "" then
								set end of mscProperties to "Q " & mscQNumber
							else
								set mscEmptyQNumber to true
							end if
						end if
						if mscCommand is in mscCommandTakesQList and mscEmptyQNumber is false then
							set mscQList to q_list of eachCue
							if mscQList is not "" then
								set end of mscProperties to "List " & mscQList
							else
								set mscEmptyQList to true
							end if
						end if
						if mscCommand is in mscCommandTakesQPath and mscEmptyQNumber is false and mscEmptyQList is false then
							set mscQPath to q_path of eachCue
							if mscQPath is not "" then set end of mscProperties to "Path " & mscQPath
						end if
						if mscCommand is in mscCommandTakesMacro then
							set end of mscProperties to macro of eachCue
						end if
						if mscCommand is in mscCommandTakesControl then
							set end of mscProperties to (control number of eachCue & " @ " & control value of eachCue) as text
						end if
						if mscCommand is in mscCommandTakesTC and send time with set of eachCue is true then
							set end of mscProperties to my padNumber(hours of eachCue, 2) & Â
								":" & my padNumber(minutes of eachCue, 2) & Â
								":" & my padNumber(seconds of eachCue, 2) & Â
								":" & my padNumber(frames of eachCue, 2) & Â
								"/" & my padNumber(subframes of eachCue, 2) -- Not sophisticated enough to use ";" for drop frame rates
						end if
						set currentTIDs to AppleScript's text item delimiters
						set AppleScript's text item delimiters to " | "
						set q name of eachCue to mscProperties as text
						set AppleScript's text item delimiters to currentTIDs
					else
						set q name of eachCue to "MIDI SysEx"
					end if
				on error -- Network Cues
					if q type of eachCue is "Network" then
						set q name of eachCue to "" -- Reset to default
					end if
				end try
			end try
		end try
	end repeat
end tell

-- Subroutines

(* === DATA WRANGLING === *)

on lookUp(lookUpValue, lookUpTable) -- [Shared subroutine]
	repeat with i from 1 to (count lookUpTable) by 2
		if lookUpValue is item i of lookUpTable then
			return item (i + 1) of lookUpTable
		end if
	end repeat
end lookUp

(* === TEXT WRANGLING === *)

on configureNoteNameString(noteNumber) -- [Shared subroutine]
	set theOctave to (noteNumber div 12) + octaveConvention
	set theNote to item (noteNumber mod 12 + 1) of noteNames
	set noteNameString to theNote & theOctave
	return noteNameString
end configureNoteNameString

on convertMIDINoteValues(noteNumber, noteVelocity) -- [Shared subroutine]
	if userMIDIConversionMode is "Numbers" then
		return noteNumber & " @ " & noteVelocity
	else if userMIDIConversionMode is "Names" then
		return my configureNoteNameString(noteNumber) & " @ " & noteVelocity
	else if userMIDIConversionMode is "Both" then
		return noteNumber & " @ " & noteVelocity & " | " & my configureNoteNameString(noteNumber)
	end if
end convertMIDINoteValues

on padNumber(theNumber, minimumDigits) -- [Shared subroutine]
	set paddedNumber to theNumber as text
	repeat while (count paddedNumber) < minimumDigits
		set paddedNumber to "0" & paddedNumber
	end repeat
	return paddedNumber
end padNumber