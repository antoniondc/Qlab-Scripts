-- Example configuration for Move to Cut List
set TARGET_LIST_NAME to "Cut List"


-- Inicializa as Utilities
set utils to getScriptFromLibrary("Applescript Utilities.scpt")
utils's initGlobals()
run getScriptFromLibrary("Tools:Move to Cut List.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary
