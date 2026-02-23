--------------------------------------------------------------------------------
-- Example configuration for Add Cue
--------------------------------------------------------------------------------

--set APPEND_TARGET_TO_NAME to true
--set USE_DIRECT_SELECTION_TARGET to true
--set TARGET_LIST_NAME to ""
--set CUE_TYPE to "start" --audio, video, start, pause, stop, devamp, fade....
--set ADD_CUE_POPUP to false
--set CREATE_LIST_IF_MISSING to false
--set LEVEL_POPUP to true
--set LEVEL_DB to 0
--set RELATIVE_MODE to true
--set LEVEL_MATRIX_LIST to {{0,0}}
--set FADE_DURATION to 6
--set FADE_MODE to "relative" --relative, absolute
--set FADE_STOP_TARGET to true
--set FADE_POPUP to true
--set SET_CUE_ARMED to false
--set SET_CUE_CONTINUE to "continue" --continue, follow, do not continue
--set SET_CUE_AUTOLOAD to true
--set SET_CUE_FLAGGED to true


--------------------------------------------------------------------------------
-- Inicializa as Utilities
--------------------------------------------------------------------------------
set utils to getScriptFromLibrary("Applescript Utilities.scpt")
utils's initGlobals()
--utils's enterCueList(TARGET_LIST_NAME)
run getScriptFromLibrary("Cue:Add Cue.scpt")


on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary
