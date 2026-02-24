--------------------------------------------------------------------------------
-- Inicializa as Utilities
--------------------------------------------------------------------------------
--set utils to getScriptFromLibrary("Applescript Utilities.scpt")
--utils's initGlobals()
run getScriptFromLibrary("File:Import and export csv.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary


--------------------------------------------------------------------------------
-- Script metadata
--------------------------------------------------------------------------------
property SCRIPT_DESCRIPTION : "Exports all cues in a selected workspace to CSV/TSV, including levels for cues that support them. Uses workspace's folder by default."
property SCRIPT_AUTHOR : "Antonio Nunes, ChatGPT"
property SCRIPT_VERSION : "2.1"