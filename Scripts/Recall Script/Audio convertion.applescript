--------------------------------------------------------------------------------
-- Audio Convert
--------------------------------------------------------------------------------
set TARGET_FORMAT to "wav" -- "wav", "mp3", "flac", "aac", "alac"
set BIT_DEPTH to 24 -- 16, 8
set SAMPLE_RATE to 48000 -- 44100, 48000, 96000
set PREFERRED_TOOL to "afconvert" -- "afconvert" or "ffmpeg" (flac/mp3 somente no ffmpeg)


--------------------------------------------------------------------------------
-- Inicializa as Utilities
--------------------------------------------------------------------------------
set utils to getScriptFromLibrary("Applescript Utilities.scpt")
utils's initGlobals()
run getScriptFromLibrary("Cue:Inspector:Audio Level:Audio Convert.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary


--------------------------------------------------------------------------------
-- Script metadata
--------------------------------------------------------------------------------
property SCRIPT_DESCRIPTION : "For each selected Audio cue: retarget to existing converted file in [workspace]/../audio or convert if missing. Preserves cue times."
property SCRIPT_AUTHOR : "Antonio Nunes"
property SCRIPT_VERSION : "2.4"