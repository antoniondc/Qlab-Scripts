--------------------------------------------------------------------------------
-- Switch List Cue
--------------------------------------------------------------------------------
set TARGET_LIST_NAME to ""
set USER_CUE_LIST_INDEX to 5
--set PRESERVE_PLAYHEAD to false


--------------------------------------------------------------------------------
-- Inicializa as Utilities
--------------------------------------------------------------------------------
set utils to getScriptFromLibrary("Applescript Utilities.scpt")
utils's initGlobals()
run getScriptFromLibrary("View:Switch List Cue.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary


--------------------------------------------------------------------------------
-- Script metadata
--------------------------------------------------------------------------------
property SCRIPT_DESCRIPTION : "Navigates to a cue list by name (if provided) or by index. Optionally preserves the playhead position."
property SCRIPT_AUTHOR : "Antonio Nunes"
property SCRIPT_VERSION : "1.1"