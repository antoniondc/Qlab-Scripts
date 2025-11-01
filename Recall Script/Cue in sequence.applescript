-- Example configuration for Cues in Sequence
set APPLY_TO to "q name" --q name, q number
set DEFAULT_INCREMENT to 1
set PREFIX_POPUP to true
set SUFFIX_POPUP to false
set INCREMENT_POPUP to false
set USE_GROUP_SUFFIX to true


set utils to getScriptFromLibrary("Applescript Utilities.scpt")
utils's initGlobals()
run getScriptFromLibrary("Tools:Renumber select cues.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary
