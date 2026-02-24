--------------------------------------------------------------------------------
-- 📄 Script metadata - Move to Cut List
--------------------------------------------------------------------------------
set TARGET_LIST_NAME to "Cut List"
--set COLOR_NAME to "red"


--------------------------------------------------------------------------------
-- Inicializa as Utilities
--------------------------------------------------------------------------------
set utils to getScriptFromLibrary("Applescript Utilities.scpt")
utils's initGlobals()
run getScriptFromLibrary("Tools:Move to Cut List.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary


--------------------------------------------------------------------------------
-- Script metadata
--------------------------------------------------------------------------------
property SCRIPT_DESCRIPTION : "Move selected cues into a Cut List, disable triggers, prefix name/number, store metadata in notes, and allow restoring back to the original list."
property SCRIPT_AUTHOR : "Antonio Nunes"
property SCRIPT_VERSION : "5"