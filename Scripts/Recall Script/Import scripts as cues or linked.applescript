--------------------------------------------------------------------------------
-- Inicializa as Utilities
--------------------------------------------------------------------------------
--set utils to getScriptFromLibrary("Applescript Utilities.scpt")
--utils's initGlobals()
run getScriptFromLibrary("Import scripts as cues or linked.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary


--------------------------------------------------------------------------------
-- Script metadata
--------------------------------------------------------------------------------
property SCRIPT_DESCRIPTION : "Auto QLab Script Importer: verifica QLab (3/4/5), pergunta instalar Recall Script ou modo manual, e cria Script Cues automaticamente (Full Script para .applescript, Loader padrão para .scpt quando não houver wrapper no Recall Script)."
property SCRIPT_AUTHOR : "Antonio Nunes"
property SCRIPT_VERSION : "3.8"