--------------------------------------------------------------------------------
-- Global Define - for Add Cue
--------------------------------------------------------------------------------
set TARGET_LIST_NAME to ""
--set MEMO_AUTO_CONTINUE to true
--set HEADING_POSITION to "after" -- "after", "before", "section"
--set SECTION_NAME to "==== New Section ===="

--------------------------------------------------------------------------------
-- Inicializa as Utilities
--------------------------------------------------------------------------------
set utils to getScriptFromLibrary("Applescript Utilities.scpt")
utils's initGlobals()

run getScriptFromLibrary("Tools:Add Section Heading.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary


--------------------------------------------------------------------------------
-- Script metadata
--------------------------------------------------------------------------------
property SCRIPT_DESCRIPTION : "Add a section heading (Memo cue) before, after, or both (section) around the selection."
property SCRIPT_AUTHOR : "Antonio Nunes"
property SCRIPT_VERSION : "2.3"