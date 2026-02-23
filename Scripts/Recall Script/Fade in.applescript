-- Example configuration for Add Fade
set CUE_TYPE to "fade"
set FADE_DURATION to 6
set FADE_MODE to "absolute"
set FADE_STOP_TARGET to false
set TARGET_LIST_NAME to "Cue List"
set USE_DIRECT_SELECTION_TARGET to false
set APPEND_TARGET_TO_NAME to false
set LEVEL_PROMPT_DELTA to false
set LEVEL_DB to 0
set LEVEL_RELATIVE to false
set LEVEL_MATRIX_LIST to {{0, 0}}


-- Inicializa as Utilities
set utils to getScriptFromLibrary("Applescript Utilities.scpt")
utils's initGlobals()
run getScriptFromLibrary("Cue:Add Cue.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary