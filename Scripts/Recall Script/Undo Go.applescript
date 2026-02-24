--------------------------------------------------------------------------------
-- Inicializa as Utilities
--------------------------------------------------------------------------------
--set utils to getScriptFromLibrary("Applescript Utilities.scpt")
--utils's initGlobals()
run getScriptFromLibrary("View:Undo Go.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary


--------------------------------------------------------------------------------
-- Script metadata
--------------------------------------------------------------------------------
property SCRIPT_DESCRIPTION : "Stops all cues from previous GO chain, cancelling any active pre/post waits. Uses stop vs panic based on wait conditions, traverses forward through continue chain (including group children). Skips disarmed cues unless they have active/configured wait. Prevents duplicate panic/stop for same playable target, but always stops wait cues (including groups and Start cues with waits)."
property SCRIPT_AUTHOR : "Antonio Nunes"
property SCRIPT_VERSION : "5.10"