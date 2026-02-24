--------------------------------------------------------------------------------
-- Inicializa as Utilities
--------------------------------------------------------------------------------
--set utils to getScriptFromLibrary("Applescript Utilities.scpt")
--utils's initGlobals()
run getScriptFromLibrary("Cue:Inspector:Basics:Skip Disarmed Cues.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary


--------------------------------------------------------------------------------
-- Script metadata
--------------------------------------------------------------------------------
property SCRIPT_DESCRIPTION : "Jump to the next cue if the current cue is disarmed. Intended for binding to space bar."
property SCRIPT_AUTHOR : "Mic Pool / Refactored by Antonio Nunes"
property SCRIPT_VERSION : "1.5"
property SCRIPT_SEPARATE_PROCESS : true
property URL : "https://qlab.app/cookbook/"