--------------------------------------------------------------------------------
-- Apply Cue Template
--------------------------------------------------------------------------------
set TARGET_LIST_NAME to "Script Files"
--set TEMPLATE_GROUP_NAME to "Routing templates"
--set TEMPLATE_NAME to "Default"
--set TEMPLATE_POPUP to false


--------------------------------------------------------------------------------
-- Inicializa as Utilities
--------------------------------------------------------------------------------
set utils to getScriptFromLibrary("Applescript Utilities.scpt")
utils's initGlobals()
run getScriptFromLibrary("Cue:Inspector:Audio Level:Apply Cue Template.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary


--------------------------------------------------------------------------------
-- Script metadata
--------------------------------------------------------------------------------
property SCRIPT_DESCRIPTION : "Route selected cues to match a routing template"
property SCRIPT_AUTHOR : "Antonio Nunes"
property SCRIPT_VERSION : "3.7"
property TESTED_MACOS : "10.14.6+"
property TESTED_QLAB : "4.7+"