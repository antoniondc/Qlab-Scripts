-------------------------------------------------------------------------------
-- Trim Audio Silence
--------------------------------------------------------------------------------
--set theStartPad to 0.2
--set theEndPad to 0.2
--set TRIM_END_ENABLED to false


-------------------------------------------------------------------------------
-- Inicializa as Utilities
--------------------------------------------------------------------------------
set utils to getScriptFromLibrary("Applescript Utilities.scpt")
utils's initGlobals()
run getScriptFromLibrary("Cue:Inspector:Time & Loops:Trim Audio Silence.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary


--------------------------------------------------------------------------------
-- Script metadata
--------------------------------------------------------------------------------
property SCRIPT_DESCRIPTION : "Trim silence from selected audio cues by detecting real audio start and end. Preserves levels and optionally skips end trim."
property SCRIPT_AUTHOR : "Mic Pool (adapted by Antonio Nunes)"
property SCRIPT_VERSION : "1.7 (2025-07-27)"
property SEPARATE_PROCESS : false