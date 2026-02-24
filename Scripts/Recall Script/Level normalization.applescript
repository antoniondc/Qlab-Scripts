--------------------------------------------------------------------------------
-- Level Normalization
--------------------------------------------------------------------------------
set LEVEL_MATRIX_LIST to {{1, 0}, {2, 0}} -- {{0,0},{1,0},{2,0}}
--set REFERENCE_LEVEL to -24 -- Default LUFS reference
--AUTO_CONVERT_AUDIO to false


--------------------------------------------------------------------------------
-- Inicializa as Utilities
--------------------------------------------------------------------------------
set utils to getScriptFromLibrary("Applescript Utilities.scpt")
utils's initGlobals()
run getScriptFromLibrary("Cue:Inspector:Audio Level:Level Normalize:Level Normalize.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary


--------------------------------------------------------------------------------
-- Script metadata
--------------------------------------------------------------------------------
property SCRIPT_DESCRIPTION : "Normalize all selected Audio cues to a reference LUFS, using a CLI loudness meter and fader correction. Make shure RMS t"
property SCRIPT_AUTHOR : "Mic pool + Refatorado por Antonio"
property SCRIPT_VERSION : "2024.3"