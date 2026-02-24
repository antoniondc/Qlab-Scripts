--------------------------------------------------------------------------------
-- Global Define - Set Level
--------------------------------------------------------------------------------
set LEVEL_DB to 0
set LEVEL_MATRIX_LIST to {{0, 0}} -- {{0,0},{1,0},{2,0}}
set RELATIVE_MODE to true
set LEVEL_POPUP to true


--------------------------------------------------------------------------------
-- Inicializa as Utilities
--------------------------------------------------------------------------------
set utils to getScriptFromLibrary("Applescript Utilities.scpt")
utils's initGlobals()
run getScriptFromLibrary("Cue:Inspector:Audio Level:Set Level.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary


--------------------------------------------------------------------------------
-- Script metadata
--------------------------------------------------------------------------------
property SCRIPT_DESCRIPTION : "Sets levels for cue(s) in QLab. Supports multiple columns and rows, absolute or relative dB. Prompt for delta optional."
property SCRIPT_AUTHOR : "Antonio Nunes"
property SCRIPT_VERSION : "1.3"
property SCRIPT_SEPARATE_PROCESS : true