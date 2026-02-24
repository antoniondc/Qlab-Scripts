--------------------------------------------------------------------------------
-- Create Line Check Cues
--------------------------------------------------------------------------------
--set TARGET_LIST_NAME to ""
--set SOUNDCHECK_MODE to "speech" -- "audio", "speech"
--set LINE_CHECK_POPUP to false
set FADE_DURATION to 1
set FOLLOW_WAIT to 2 -- valor em segundos, "" para Manual


--------------------------------------------------------------------------------
-- Inicializa as Utilities
--------------------------------------------------------------------------------
set utils to getScriptFromLibrary("Applescript Utilities.scpt")
utils's initGlobals()
run getScriptFromLibrary("Tools:Create Line Check Cues.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary


--------------------------------------------------------------------------------
-- Script metadata
--------------------------------------------------------------------------------
property SCRIPT_DESCRIPTION : "Build a Line Check group in the target cue list. • audio = fades on a selected Audio/Video (or its target). • speech = one cue per output using TTS/Sub.wav. Single popup (advance + time)."
property SCRIPT_AUTHOR : "Antonio Nunes / Based on Ben Smith & Rich Walsh"
property SCRIPT_VERSION : "4.3.2"