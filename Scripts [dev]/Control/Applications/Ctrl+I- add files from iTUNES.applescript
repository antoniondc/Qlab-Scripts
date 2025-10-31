-- This script will add selected files from iTunes and name the cues accordingly (it will also attempt to remove track numbers from the start of the names); remember to bundle the workspace at some point to get the audio files in the right place!

set userAttemptToRemoveTrackNumbers to true -- Set this to false if you don't mind having track numbers in your cue descriptions
set useriTunesSelectionCountLimit to 100 -- Protect against inadvertently trying to import entire playlists selected in the iTunes sidebar (you can increase this limit)

-- Declarations

global dialogTitle
set dialogTitle to "Add files from iTunes"

-- Check iTunes is running

tell application "System Events"
	set iTunesIsOpen to count (processes whose name is "iTunes")
end tell
if iTunesIsOpen is 0 then
	display dialog "iTunes is not running." with title dialogTitle with icon 0 buttons {"OK"} default button "OK" giving up after 5
	return
end if

-- Test for an acceptable selection

tell application "Podcasts"
	set iTunesSelectionCount to count (selection as list)
end tell
if iTunesSelectionCount is 0 then
	display dialog "There is no selection in iTunes." with title dialogTitle with icon 0 buttons {"OK"} default button "OK" giving up after 5
	return
else if iTunesSelectionCount > useriTunesSelectionCountLimit then
	display dialog "The selection in iTunes (" & iTunesSelectionCount & ") is larger than the limit (" & useriTunesSelectionCountLimit & ")." with title dialogTitle Â
		with icon 0 buttons {"OK"} default button "OK" giving up after 10
	return
end if

-- Offer escape hatch

if iTunesSelectionCount is 1 then
	set countString to "file"
else
	set countString to "files"
end if

display dialog "Adding " & iTunesSelectionCount & " selected " & countString & " from iTunesÉ" with title dialogTitle with icon 1 Â
	buttons {"Cancel", "OK"} default button "OK" cancel button "Cancel" giving up after 5 -- You have 5s to change your mind

-- Get the files

tell application "Podcasts"
	set selectedFiles to (location of selection) as list
end tell

-- Get the names

set selectedNames to {}
tell application "System Events"
	repeat with eachItem in selectedFiles
		set end of selectedNames to name of eachItem
	end repeat
end tell

-- Attempt to remove track numbers, as necessary

if userAttemptToRemoveTrackNumbers is true then
	set cleanedNames to {}
	set currentTIDs to AppleScript's text item delimiters
	set AppleScript's text item delimiters to space
	repeat with eachName in selectedNames
		if first character of first text item of eachName is in "01234567890" then
			set end of cleanedNames to rest of text items of eachName as text
		else
			set end of cleanedNames to eachName
		end if
	end repeat
	set AppleScript's text item delimiters to currentTIDs
else
	set cleanedNames to selectedNames
end if

-- Add the files

tell application id "com.figure53.QLab.4" to tell front workspace
	repeat with i from 1 to count selectedFiles
		make type "Audio"
		set newCue to last item of (selected as list)
		set file target of newCue to item i of selectedFiles
		set q name of newCue to item i of cleanedNames
	end repeat
end tell

display dialog "Done." with title dialogTitle with icon 1 buttons {"OK"} default button "OK" giving up after 5