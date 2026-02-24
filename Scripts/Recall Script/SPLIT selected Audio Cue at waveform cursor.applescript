--------------------------------------------------------------------------------
-- Inicializa as Utilities
--------------------------------------------------------------------------------
--set utils to getScriptFromLibrary("Applescript Utilities.scpt")
--utils's initGlobals()
run getScriptFromLibrary("Cue:Inspector:Time & Loops:SPLIT selected Audio Cue at waveform cursor.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary


--------------------------------------------------------------------------------
-- Script metadata
--------------------------------------------------------------------------------
property SCRIPT_DESCRIPTION : "Duplica o Audio cue selecionado e divide em 2 na posição do cursor do waveform (Time & Loops → Start/End)."
property SCRIPT_AUTHOR : "A Credidar..."
property SCRIPT_VERSION : "1.0"