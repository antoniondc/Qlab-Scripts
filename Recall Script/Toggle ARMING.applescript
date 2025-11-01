-- Example configuration for QLab Multi Toggle
set CUE_PROPERTY to "armed"
set RELATIVE_MODE to false


set utils to getScriptFromLibrary("Applescript Utilities.scpt")
utils's initGlobals()
run getScriptFromLibrary("Cue:Inspector:Basics:QLab Multi Toggle.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary
