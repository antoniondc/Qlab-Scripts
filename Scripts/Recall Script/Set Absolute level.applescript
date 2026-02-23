-- Example configuration for Level Utility
set LEVEL_DB to 0
set LEVEL_MATRIX_LIST to {{0, 0}}
set LEVEL_RELATIVE to false
set LEVEL_PROMPT_DELTA to false


set utils to getScriptFromLibrary("Applescript Utilities.scpt")
utils's initGlobals()
run getScriptFromLibrary("Cue:Inspector:Audio Level:Set Level.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary
