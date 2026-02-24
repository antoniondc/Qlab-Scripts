--------------------------------------------------------------------------------
-- Set Color
--------------------------------------------------------------------------------
--set EXTENDED_COLORS to false


--------------------------------------------------------------------------------
-- Inicializa as Utilities
--------------------------------------------------------------------------------
set utils to getScriptFromLibrary("Applescript Utilities.scpt")
utils's initGlobals()
run getScriptFromLibrary("Cue:Inspector:Basics:Set Color.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary


--------------------------------------------------------------------------------
-- Script metadata
--------------------------------------------------------------------------------
property SCRIPT_DESCRIPTION : "Pick a QLab cue or cue list color from basic or extended set with emoji visual. Can also be called externally with a specific color."
property SCRIPT_AUTHOR : "Antonio Nunes"
property SCRIPT_VERSION : "2.1"