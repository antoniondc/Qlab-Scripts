--------------------------------------------------------------------------------
-- Renumber Select Cues
--------------------------------------------------------------------------------
--set APPLY_TO to "q name" -- "q name", "q number"
--set DEFAULT_INCREMENT to 10
--set PREFIX_POPUP to false
--set SUFFIX_POPUP to true
--set INCREMENT_POPUP to true
--set USE_GROUP_SUFFIX to false


--------------------------------------------------------------------------------
-- Inicializa as Utilities
--------------------------------------------------------------------------------
set utils to getScriptFromLibrary("Applescript Utilities.scpt")
utils's initGlobals()
run getScriptFromLibrary("Tools:Renumber select cues.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary


--------------------------------------------------------------------------------
-- Script metadata
--------------------------------------------------------------------------------
property SCRIPT_DESCRIPTION : "Numera cues selecionados, padding inteligente, sufixo/prefixo/incremento opcionais via popup. Para filhos de group cue, aplica hierarquia '.1', '.2', '.1.1' (suporte a múltiplos níveis) se USE_GROUP_SUFFIX=true."
property SCRIPT_AUTHOR : "Antonio Nunes"
property SCRIPT_VERSION : "4.5"