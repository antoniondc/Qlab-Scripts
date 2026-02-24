--------------------------------------------------------------------------------
-- Script metadata - Navigate Cues
--------------------------------------------------------------------------------
set USER_CUE_MODE to "BROKEN" -- "SHARED", "BROKEN", "LOADED", "PAUSED", "RUNNING", "AUDIO", "VIDEO", "OUTPUT"
--set NAVCUES_POPUP to false -- true = popup selection, false = direct navigation
--set USER_DIRECTION to "previous" -- "forward" or "previous"
--set USER_PRESELECT_CUE to false -- true = preselect next/previous cue in list
--set USER_INCLUDE_INDIRECT_MEDIA to true
--set USER_OUTPUT_COLUMN to 1 -- For "OUTPUT" mode only, 0 for "MASTER"
--set USER_THRESH to -100 -- Output level threshold (dB)


--------------------------------------------------------------------------------
-- Inicializa as Utilities
--------------------------------------------------------------------------------
set utils to getScriptFromLibrary("Applescript Utilities.scpt")
utils's initGlobals()
run getScriptFromLibrary("View:Navigate Cues.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary


--------------------------------------------------------------------------------
-- Script metadata
--------------------------------------------------------------------------------
property SCRIPT_DESCRIPTION : "Navigate and select cues by state, output level, color, shared target, or shared media file."
property SCRIPT_AUTHOR : "Antonio Nunes"
property SCRIPT_VERSION : "3.6"