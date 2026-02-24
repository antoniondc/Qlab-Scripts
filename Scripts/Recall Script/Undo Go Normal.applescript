--------------------------------------------------------------------------------
-- Inicializa as Utilities
--------------------------------------------------------------------------------
--set utils to getScriptFromLibrary("Applescript Utilities.scpt")
--utils's initGlobals()
run getScriptFromLibrary("View:Undo Go(normal).scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary


--------------------------------------------------------------------------------
-- Script metadata
--------------------------------------------------------------------------------
property SCRIPT_DESCRIPTION : "Stops all cues from previous GO chain using panic or stop based on wait conditions, traversing forward through continue chain, including group children. Skips disarmed cues after processing unless they have pre/post wait. Automatically moves playhead to the beginning of the previous GO chain."
property SCRIPT_AUTHOR : "Antonio Nunes"
property SCRIPT_VERSION : "4.0"