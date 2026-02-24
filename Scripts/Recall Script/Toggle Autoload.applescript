--------------------------------------------------------------------------------
-- 📄 Script metadata - QLab Multi Toggle
--------------------------------------------------------------------------------
set CUE_PROPERTY to "autoload" -- "armed" | "flagged" | "autoload"
set RELATIVE_MODE to false -- true/false
--set MULTITOGGLE_POPUP to true -- true/false : if true, ask a search string before toggling
--set MULTITOGGLE_EXACT_MATCH to true -- true/false : match exactly vs contains
--set MULTITOGGLE_SCOPE_SELECTED_ONLY to  false -- true = só atua dentro da seleção atual, mesmo quando usar popup / false = pode buscar cues no workspace inteiro quando usar popup


--------------------------------------------------------------------------------
-- Inicializa as Utilities
--------------------------------------------------------------------------------
set utils to getScriptFromLibrary("Applescript Utilities.scpt")
utils's initGlobals()
run getScriptFromLibrary("Cue:Inspector:Basics:QLab Multi Toggle.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary


--------------------------------------------------------------------------------
-- Script metadata
--------------------------------------------------------------------------------
property SCRIPT_DESCRIPTION : "Toggle armed/flagged/autoload in batch. Works on current selection or by name match, supports relative or binary mode."
property SCRIPT_AUTHOR : "Antonio Nunes"
property SCRIPT_VERSION : "2024.10"