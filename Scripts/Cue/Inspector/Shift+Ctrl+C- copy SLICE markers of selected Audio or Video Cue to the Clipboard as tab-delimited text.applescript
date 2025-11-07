(*
set userHeaderRow to "Slice time" & tab & "Play count" -- Set this to false if you don't want a header
tell front workspace
	try -- This protects against no selection (can't get last item of (selected as list))
		set selectedCue to last item of (selected as list)
		set recordTable to my recordToDelimitedText(slice markers of selectedCue, tab, return)
		if userHeaderRow is not false then
			set recordTable to userHeaderRow & return & recordTable
		end if
		set the clipboard to recordTable as text
	end try
end tell

-- Subroutines

(* === TEXT WRANGLING === *)

on recordToDelimitedText(theRecord, theColumnDelimiter, theRowDelimiter) -- [Shared subroutine]
	set passedTIDs to AppleScript's text item delimiters
	set delimitedList to {}
	set AppleScript's text item delimiters to theColumnDelimiter
	repeat with eachItem in theRecord
		set end of delimitedList to (eachItem as list) as text
	end repeat
	set AppleScript's text item delimiters to theRowDelimiter
	set delimitedText to delimitedList as text
	set AppleScript's text item delimiters to passedTIDs
	return delimitedText
end recordToDelimitedText
*)