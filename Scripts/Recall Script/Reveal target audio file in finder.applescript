--------------------------------------------------------------------------------
-- Inicializa as Utilities
--------------------------------------------------------------------------------
--set utils to getScriptFromLibrary("Applescript Utilities.scpt")
--utils's initGlobals()
run getScriptFromLibrary("Cue:Inspector:Basics:Reveal target audio file in finder.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary


--------------------------------------------------------------------------------
-- Script metadata
--------------------------------------------------------------------------------
-- @description Reveal the file in Finder for any QLab cue, following one target level.
-- @author      Ben Smith (adapted & refactored by Antonio)
-- @link        bensmithsound.uk
-- @version     2.3