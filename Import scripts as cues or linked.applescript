-- @description Merged QLab Script Importer: choose between two import methods
-- @author Ben Smith
-- @version 1.2
-- @testedmacos 10.13.6
-- @testedqlab 4.6.10
-- @about Select between script imports or linking compiled scripts in QLab.
-- @separateprocess TRUE

use framework "Foundation"
use framework "OSAKit"
use scripting additions

global defaultSeparateProcess, versionWarnings

-- USER DEFINED VARIABLES -----------------
property defaultSeparateProcess : "TRUE" -- Default “Run in separate process” setting
property versionWarnings : true -- Warn on version mismatches
-- END OF USER DEFINED VARIABLES -----------

-- MAIN ENTRY POINT ------------------------
on run
	display dialog "Select import method:" buttons {"Import scripts", "Link Scripts"} default button "Import scripts"
	set importChoice to button returned of result
	if importChoice = "Import scripts" then
		importMetadataScripts()
	else
		compileAndImportScripts()
	end if
end run

-- METADATA IMPORT -------------------------
on importMetadataScripts()
	set scriptFiles to choose file with prompt "Select scripts to import" of type {"public.text", "com.apple.applescript.text"} with multiple selections allowed
	repeat with eachScript in scriptFiles
		-- read file
		set fileData to read eachScript as «class utf8»
		set lines to paragraphs of fileData
		set codeBody to ""
		-- strip metadata, build code body
		repeat with ln in lines
			if not (ln begins with "-- @") and not (ln begins with "--   ") then
				set codeBody to codeBody & linefeed & ln
			end if
		end repeat
		set codeBody to trimLine(codeBody, linefeed, 0)
		-- cue name from filename
		set fnInfo to info for eachScript
		set cueName to name of fnInfo
		-- insert into QLab
		tell application id "com.figure53.QLab.4" to tell front workspace
			if ((count of selected) as list = 1) and ((count of scriptFiles) = 1) and ((q type of item 1 of (selected as list)) is "Script") then
				set scCue to item 1 of (selected as list)
			else
				make type "Script"
				set scCue to last item of (selected as list)
			end if
			set q name of scCue to cueName
			set script source of scCue to codeBody
		end tell
	end repeat
end importMetadataScripts

-- LINK (COMPILED) IMPORT -----------------
on compileAndImportScripts()
	set scriptFiles to choose file with prompt "Select .applescript or .scpt files" of type {"com.apple.applescript.script", "applescript"} with multiple selections allowed
	repeat with eachScript in scriptFiles
		set psn to POSIX path of eachScript
		if psn ends with ".scpt" then
			set compiledPath to psn
		else
			-- compile to .scpt
			set urlIn to (current application's |NSURL|'s fileURLWithPath:psn)
			set urlOut to (urlIn's URLByDeletingPathExtension()'s URLByAppendingPathExtension:"scpt")
			set {osaScript, err1} to (current application's osaScript's alloc()'s initWithContentsOfURL:urlIn |error|:(reference))
			if osaScript is missing value then error err1's |description|() as text
			set {cOK, err2} to (osaScript's compileAndReturnError:(reference))
			if not (cOK as boolean) then error err2's |description|() as text
			set {wOK, err3} to (osaScript's writeToURL:urlOut ofType:"scpt" usingStorageOptions:0 |error|:(reference))
			if not (wOK as boolean) then error err3's |description|() as text
			set compiledPath to POSIX path of (urlOut as alias)
		end if
		-- cue name from filename
		set fnInfo to info for eachScript
		set cueName to name of fnInfo
		-- insert into QLab
		tell application id "com.figure53.QLab.4" to tell front workspace
			if ((count of selected) as list = 1) and ((count of scriptFiles) = 1) and ((q type of item 1 of (selected as list)) is "Script") then
				set scCue to item 1 of (selected as list)
			else
				make type "Script"
				set scCue to last item of (selected as list)
			end if
			set q name of scCue to cueName
			set script source of scCue to "set theScript to load script \"" & compiledPath & "\"
run theScript"
		end tell
	end repeat
end compileAndImportScripts

-- HELPER: trim whitespace ----------------
on trimLine(theText, trimChars, trimIndicator)
	set x to length of trimChars
	if length of theText ≤ x then return ""
	if trimIndicator = 0 or trimIndicator = 2 then
		repeat while theText begins with trimChars
			try
				set theText to text (x + 1) thru -1 of theText
			on error
				exit repeat
			end try
		end repeat
	end if
	if trimIndicator = 1 or trimIndicator = 2 then
		repeat while theText ends with trimChars
			try
				set theText to text 1 thru -(x + 1) of theText
			on error
				exit repeat
			end try
		end repeat
	end if
	return theText
end trimLine
