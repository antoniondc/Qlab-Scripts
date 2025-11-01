-- Example configuration for this script
-- set VAR_NAME to value
set LEVEL_MATRIX_LIST to {{1, 0}, {2, 0}}
--set REFERENCE_LEVEL to -24 -- Default LUFS reference

set utils to getScriptFromLibrary("Applescript Utilities.scpt")
utils's initGlobals()
run getScriptFromLibrary("Cue:Inspector:Audio Level:Level Normalize:Level Normalize.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary
