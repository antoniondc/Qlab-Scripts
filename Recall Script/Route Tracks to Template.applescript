-- Example configuration for this script
-- set VAR_NAME to value

--set TARGET_LIST_NAME to "Script Files"
--set TEMPLATE_LIST_NAME to "Script Files"
--set TEMPLATE_GROUP_NAME to "Routing templates"
--set TEMPLATE_NAME to ""
--set TEMPLATE_POPUP to true

set utils to getScriptFromLibrary("Applescript Utilities.scpt")
utils's initGlobals()
run getScriptFromLibrary("Cue:Inspector:Audio Level:Route cues to template.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary
