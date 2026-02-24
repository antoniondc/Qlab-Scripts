--------------------------------------------------------------------------------
-- Global Define - for Add Cue
--------------------------------------------------------------------------------
set TARGET_LIST_NAME to ""
set CUE_TYPE to "group" -- "audio", "video", "start", "pause", "stop", "devamp", "fade"....
--set APPEND_TARGET_TO_NAME to true
--set USE_DIRECT_SELECTION_TARGET to true
--set ADD_CUE_POPUP to false
--set CREATE_LIST_IF_MISSING to false
--set LEVEL_POPUP to true
--set LEVEL_DB to 0
--set LEVEL_MATRIX_LIST to {{0,0}} -- {{0,0},{1,0},{2,0}}
--set RELATIVE_MODE to true
--set FADE_DURATION to 6
--set FADE_MODE to "relative" -- "relative", "absolute"
--set FADE_STOP_TARGET to true
--set FADE_POPUP to true
--set SET_CUE_ARMED to false
--set SET_CUE_CONTINUE to "continue" -- "continue", "follow", "do not continue"
--set SET_CUE_AUTOLOAD to true
--set SET_CUE_FLAGGED to true
--set STORED_SELECTION to ""
--set RESTORE_ORIGINAL_LIST to true
--set SKIP_IF_LIST_EXISTS to true

--------------------------------------------------------------------------------
-- Inicializa as Utilities
--------------------------------------------------------------------------------
set utils to getScriptFromLibrary("Applescript Utilities.scpt")
utils's initGlobals()

run getScriptFromLibrary("Cue:Add Cue.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary


--------------------------------------------------------------------------------
-- Script metadata
--------------------------------------------------------------------------------
property SCRIPT_DESCRIPTION : "Creates specific cue types in QLab and assigns targets intelligently. Can be called via global configuration. Appends target info if desired, creating cues directly in specified list by changing current cue list, avoiding move operations."
property SCRIPT_AUTHOR : "Antonio Nunes"
property SCRIPT_VERSION : "4.4.2"
property SCRIPT_SEPARATE_PROCESS : true