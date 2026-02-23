-- Example configuration for Switch List Cue
--set userCueList to ""
--set USER_CUE_LIST_INDEX to 1
--set PRESERVE_PLAYHEAD to true


set utils to getScriptFromLibrary("Applescript Utilities.scpt")
utils's initGlobals()
run getScriptFromLibrary("View:Switch List Cue.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary
