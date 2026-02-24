--------------------------------------------------------------------------------
-- Inicializa as Utilities
--------------------------------------------------------------------------------
--set utils to getScriptFromLibrary("Applescript Utilities.scpt")
--utils's initGlobals()
run getScriptFromLibrary("Files:Bundle & organize")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary


--------------------------------------------------------------------------------
-- Script metadata
--------------------------------------------------------------------------------
property SCRIPT_DESCRIPTION : "Bundle & Organize: move/copy all media of current workspace into correct show folders; update targets; import loose files to proper cue lists (green)."
property SCRIPT_AUTHOR : "Antonio Nunes"
property SCRIPT_VERSION : "1.1"
property SCRIPT_SEPARATE_PROCESS : true